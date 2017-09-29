Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:45988 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752468AbdI2Sko (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 14:40:44 -0400
Received: by mail-vk0-f53.google.com with SMTP id w23so290272vkw.2
        for <linux-wireless@vger.kernel.org>; Fri, 29 Sep 2017 11:40:43 -0700 (PDT)
MIME-Version: 1.0
From: Steve deRosier <derosier@gmail.com>
Date: Fri, 29 Sep 2017 11:40:42 -0700
Message-ID: <CALupW3CLewT6jj5RDa4M6Uys8V+SNB0Fkzj9wPpK1M9q=aRuAw@mail.gmail.com> (sfid-20170929_204048_053584_FCC26B89)
Subject: carl9170 issue with sniffer mode and dropping probe responses
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

A patch went in to the carl9170 driver about 5 years go that addressed
an issue with spurious ack noise from the hardware when it was put in
sniffer mode. It changed the driver to drop the sniffer mode and
instead keep it in STA mode with relaxed RX filtering. Patch [1]
Discussion [2]

All was thought to be well, but as it turns out it causes a specific
problem with injection as reported on the Kali Linux bug list [3].
Turns out it's not an issue with injection as the device transmits the
injected packets to the air just fine, but it's an issue with the
hardware filtering out the probe responses that are sent back to the
fake randomized MAC address that aireplay-ng is using as the sender on
the injected packets. aireplay-ng needs to get these probe response
packets back but they're getting filtered out by the hardware and
never even make it back up to the driver.

I've played with every RX filter flag and various attempts to
manipulate the MAC filters and I can't get anything to work. Only by
putting the AR9170_MAC_SNIFFER_ENABLE_PROMISC flag back in so we have
real monitor mode again, I was able to solve the issue. By putting the
flag back, the relevant probe responses are able to get back up to the
driver and aireplay-ng works again with carl9170.

I spent a long time avoiding adding sniffer mode back in due to the
explanation comments in the code. I played with the rx_fliter_cmd and
turned off the filters. I played with REG_MAC_ADDR, REG_BSSID and
REG_FRAMETYPE_FILTER. I attempted to manipulate the MAC filters by
playing with REG_GROUP_HASH_TBL.  Basically, I thoroughly went through
carl9170.h and played with every register  and command that looked
relevant.  If there's any other filter or MAC address filtering I
missed, please advise.

As mentioned, I put the sniffer back in play. But I chose to keep
AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER off. I throughly tested the
degradation mentioned that resulted in the earlier patch. With the
sniffer flag ON but dropping RX_CTRL_ACK_IN_SNIFFER, I didn't see the
channel throughput hit. The second I toggled the RX_CTRL flag back on,
the throughput on the channel dropped and I started seeing the effects
the previous patch mentioned.

So, I think we can add AR9170_MAC_SNIFFER_ENABLE_PROMISC back in with
AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER kept off and end up with carl9170
working in true sniffer mode but without getting the earlier problem.
Note that this is with the most current firmware, the 1.9.9, which is
newer than the original fix. Perhaps changes in firmware behavior are
resulting in the differences?

For specific point of discussion, I'll put my patch at the end of this
email.  Please advise to approach or anything that looks wrong and
I'll make adjustments and respin. Or if it looks OK, I'll submit the
patch.


Thanks,
- Steve

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit?id=e0509d3bdd7365d06c9bf570bf9f118cae6cbd58
[2] https://marc.info/?l=linux-wireless&m=134517238506033
[3] https://bugs.kali.org/view.php?id=4220

>From c46a994dd78befbe94e66771db41c18351be2aae Mon Sep 17 00:00:00 2001
From: Steve deRosier <derosier@cal-sierra.com>
Date: Fri, 29 Sep 2017 10:48:19 -0700
Subject: [PATCH] wireless: carl9170: Enable sniffer mode promisc flag to fix
 injection

The removal of the AR9170_MAC_SNIFFER_ENABLE_PROMISC flag to fix an issue
many years ago caused the AR9170 to not be able to pass probe response
packets with different MAC addresses back up to the driver. In general
operation, this doesn't matter, but in the case of packet injection with
aireplay-ng it is important. aireplay-ng specifically injects packets with
spoofed MAC addresses on the probe requests and looks for probe responses
back to those addresses. No other combination of filter flags seem to fix
this issue and so AR9170_MAC_SNIFFER_ENABLE is required to get these packets.

This was originally caused by commit e0509d3bdd7365d06c9bf570bf9f11 which
removed this flag in order to avoid spurious ack noise from the hardware.
In testing for this issue, keeping this flag but not restoring the
AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER flag on the rc_ctrl seems to solve this
issue, at least with the most current firmware v1.9.9.

Signed-off-by: Steve deRosier <derosier@cal-sierra.com>
---
 drivers/net/wireless/ath/carl9170/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/carl9170/mac.c
b/drivers/net/wireless/ath/carl9170/mac.c
index 7d4a72dc98db..c617e883f47a 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -309,6 +309,7 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
  u32 rx_ctrl = AR9170_MAC_RX_CTRL_DEAGG |
       AR9170_MAC_RX_CTRL_SHORT_FILTER;
  u32 sniffer = AR9170_MAC_SNIFFER_DEFAULTS;
+ u32 mac_ftf = AR9170_MAC_FTF_DEFAULTS;
  int err = 0;

  rcu_read_lock();
@@ -373,6 +374,9 @@ int carl9170_set_operating_mode(struct ar9170 *ar)

  if (ar->sniffer_enabled) {
  enc_mode |= AR9170_MAC_ENCRYPTION_RX_SOFTWARE;
+ mac_ftf = AR9170_MAC_FTF_MONITOR;
+ sniffer |= AR9170_MAC_SNIFFER_ENABLE_PROMISC;
+ mac_addr = NULL;
  }

  err = carl9170_set_mac_reg(ar, AR9170_MAC_REG_MAC_ADDR_L, mac_addr);
@@ -384,6 +388,7 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
  return err;

  carl9170_regwrite_begin(ar);
+ carl9170_regwrite(AR9170_MAC_REG_FRAMETYPE_FILTER, mac_ftf);
  carl9170_regwrite(AR9170_MAC_REG_SNIFFER, sniffer);
  carl9170_regwrite(AR9170_MAC_REG_CAM_MODE, cam_mode);
  carl9170_regwrite(AR9170_MAC_REG_ENCRYPTION, enc_mode);
-- 
2.14.1
