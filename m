Return-Path: <SRS0=36rf=O7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5FFC43387
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Dec 2018 18:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00DE321917
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Dec 2018 18:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=thecshore.com header.i=@thecshore.com header.b="oZMGCs/T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbeLVSex (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Dec 2018 13:34:53 -0500
Received: from mailb.thecshore.com ([144.217.14.6]:45786 "EHLO
        mailb.thecshore.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbeLVSew (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Dec 2018 13:34:52 -0500
X-Greylist: delayed 4201 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2018 13:34:51 EST
Received: from finalmail.lan (finalmail.lan [10.50.50.83])
        by mailb.lan (Postfix) with ESMTPS id 770EC114;
        Sat, 22 Dec 2018 01:09:43 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailb.lan 770EC114
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thecshore.com;
        s=mailb; t=1545458984;
        bh=EeCvTl5z79vuPd44arlmyY3dIS+/bt9gN6q0YcdhEMg=;
        h=From:To:Cc:Subject:Date:From;
        b=oZMGCs/T9HcpeUZ7unEziHBwoFdEHJJoodAKAR42VcetV7ao6x+oCkiqVhxYiy9vm
         KZYaQVFDUdAWY5MtUUc07Y/tWlwf5PJQ70Qo870ZZvfTvBgy01PrbQyGMM3pG3XwGM
         LvBpJdUI3H3cWZ2EcGhT65kZULUa910b3pa5BP8c=
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.100.2 at mailb.thecshore.com
Received: from danielpm (danielpm.lan [10.50.50.61])
        by finalmail.lan (Postfix) with ESMTP id 047E31219;
        Sat, 22 Dec 2018 01:09:43 -0500 (EST)
Received: by danielpm (Postfix, from userid 1001)
        id E8E3B100; Sat, 22 Dec 2018 01:09:42 -0500 (EST)
From:   "Daniel F. Dickinson" <cshored@thecshore.com>
To:     ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Cc:     chunkeey@gmail.com, kvalo@codeaurora.org,
        "Daniel F. Dickinson" <cshored@thecshore.com>
Subject: [PATCH] ath9k: Avoid OF no-EEPROM quirks without qca,no-eeprom
Date:   Sat, 22 Dec 2018 01:09:13 -0500
Message-Id: <20181222060913.28434-1-cshored@thecshore.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ath9k_of_init() function[0] was initially written on the assumption that
if someone had an explicit ath9k OF node that "there must be something
wrong, why would someone add an OF node if everything is fine"[1]
(Quoting Martin Blumenstingl <martin.blumenstingl@googlemail.com>)

"it turns out it's not that simple. with your requirements I'm now aware
of two use-cases where the current code in ath9k_of_init() doesn't work
without modifications"[1]

The "your requirements" Martin speaks of is the result of the fact that I
have a device (PowerCloud Systems CR5000) has some kind of default - not
unique mac address - set and requires to set the correct MAC address via
mac-address devicetree property, however:

"some cards come with a physical EEPROM chip [or OTP] so "qca,no-eeprom"
should not be set (your use-case). in this case AH_USE_EEPROM should be
set (which is the default when there is no OF node)"[1]

The other use case is:

the firmware on some PowerMac G5 seems to add a OF node for the ath9k
card automatically. depending on the EEPROM on the card AH_NO_EEP_SWAP
should be unset (which is the default when there is no OF node). see [3]

After this patch to ath9k_of_init() the new behavior will be:

    if there's no OF node then everything is the same as before
    if there's an empty OF node then ath9k will use the hardware EEPROM
      (before ath9k would fail to initialize because no EEPROM data was
      provided by userspace)
    if there's an OF node with only a MAC address then ath9k will use
      the MAC address and the hardware EEPROM (see the case above)
    with "qca,no-eeprom" EEPROM data from userspace will be requested.
      the behavior here will not change
[1]

Martin provides additional background on EEPROM swapping[1].

Thanks to Christian Lamparter <chunkeey@gmail.com> for all his help on
troubleshooting this issue and the basis for this patch.

Fixes: 138b41253d9c ("ath9k: parse the device configuration from an OF node")

[0]https://elixir.bootlin.com/linux/v4.20-rc7/source/drivers/net/wireless/ath/ath9k/init.c#L615
[1]https://github.com/openwrt/openwrt/pull/1645#issuecomment-448027058
[2]https://github.com/openwrt/openwrt/pull/1613
[3]https://patchwork.kernel.org/patch/10241731/

Signed-off-by: Daniel F. Dickinson <cshored@thecshore.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Additional Background on EEPROM swapping[0] (quoting Martin again):

some additional information on the EEPROM swapping (for the curious who
want some additional context why I'm suggesting to move both flags
together): we need AH_NO_EEP_SWAP on a few devices. one of them is the
BT Home Hub 5A (lantiq target). this flag decides whether ath9k will
look at the first two "magic" bytes (0x5aa5 or 0xa55a). if this
doesn't match ath9k's expectations (defined at compile-time: big or
little endian) then ath9k calls swab16 on the whole EEPROM data.
however, this assumes that whoever defined the EEPROM data knew how to
set the magic bytes correctly (which is not the case - at least on
BT Home Hub 5A).  The EEPROM data itself (assuming all bytes are in the
correct place - which may require calling swab16 on the whole EEPROM
data) has an endianness bit which decided whether all u16/u32 values
are to be interpreted as little (default) or big endian.
Some EEPROM authors got the magic bytes wrong, but as far as I know
everyone got the EEPMISC endianness bit right.

[0]https://github.com/openwrt/openwrt/pull/1645#issuecomment-448027058

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c070a9e51ebf..fae572b38416 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -636,15 +636,15 @@ static int ath9k_of_init(struct ath_softc *sc)
 		ret = ath9k_eeprom_request(sc, eeprom_name);
 		if (ret)
 			return ret;
+
+		ah->ah_flags &= ~AH_USE_EEPROM;
+		ah->ah_flags |= AH_NO_EEP_SWAP;
 	}
 
 	mac = of_get_mac_address(np);
 	if (mac)
 		ether_addr_copy(common->macaddr, mac);
 
-	ah->ah_flags &= ~AH_USE_EEPROM;
-	ah->ah_flags |= AH_NO_EEP_SWAP;
-
 	return 0;
 }
 
-- 
2.19.1

