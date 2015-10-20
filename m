Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34692 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbbJTGqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:16 -0400
Received: by lbbwb3 with SMTP id wb3so7785764lbb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:14 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 00/16] rtl8xxxu: eFUSE parsing for RTL8188EU chips
Date: Tue, 20 Oct 2015 08:45:30 +0200
Message-Id: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084619_913357_F9B4EEF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jes,

I'm posting this patch set to show in what direction the work is
going.  Hopefully any changes (e.g. renames) which you wouldn't see
fit for this driver can be identified early this way.

The work is nowhere near the end.  These changes only get me past the
parse_efuse() step in the probe() routine.

I've structured the patch set in such a way that changes that are not
RTL8188EU-specific (preparatory work) come first.  All but the last
two patches (tagged "rtl8188eu:") fall into this category.  If you
were considering to apply any of them, note that they were not tested
with any device that is known to work with rtl8xxxu, only a TP-Link
TL-WN725N (RTL8188EU) dongle.

The corresponding git branch for this patch set is at:

git https://github.com/jsitnicki/linux.git branch rtl8xxxu-rtl8188eu

Cheers,
Jakub

Jakub Sitnicki (16):
  rtl8xxxu: Treat REG_9346CR as an 8-bit wide register
  rtl8xxxu: Use REG_EFUSE_TEST register only on multifunctional devices
  rtl8xxxu: Don't check for illegal offset when reading from efuse
  rtl8xxxu: Skip disabled efuse words early
  rtl8xxxu: Unbreak a user-visible string
  rtl8xxxu: rtl8723au: Introduce a pointer to efuse
  rtl8xxxu: rtl8192cu: Introduce a pointer to efuse
  rtl8xxxu: Extract TX power fields from struct rtl8xxu_priv
  rtl8xxxu: Rename struct struct rtl8723au_tx_power fields
  rtl8xxxu: Rename struct rtl8723au_idx
  rtl8xxxu: Make efuse content length a parameter
  rtl8xxxu: Prepare to have more than one kind of struct *_tx_power
  rtl8xxxu: Make set_tx_power a chip-type-dependent operation
  rtl8xxxu: Introduce a device agnostic constant for efuse map length
  rtl8xxxu: rtl8188eu: Add stubbed fileops and chip-specific constants
  rtl8xxxu: rtl8188eu: Implement parse_efuse()

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 318 ++++++++++++++---------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  96 +++++--
 2 files changed, 262 insertions(+), 152 deletions(-)

-- 
2.1.0

