Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58511 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab2DQOiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 10:38:08 -0400
Received: by bkcik5 with SMTP id ik5so4627558bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 07:38:06 -0700 (PDT)
Date: Tue, 17 Apr 2012 16:37:46 +0200
From: Anisse Astier <anisse@astier.eu>
To: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Cc: linville@tuxdriver.com, RA-Shiang Tu <Shiang_Tu@ralinktech.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Kevin Chou <kevin.chou@mediatek.com>,
	John Li <chen-yang.li@mediatek.com>,
	RA-Jay Hung <Jay_Hung@ralinktech.com>
Subject: Re: RT5390 not working with rt2800pci
Message-ID: <20120417163746.35c232c8@destiny.ordissimo> (sfid-20120417_163812_740431_8F34BA56)
In-Reply-To: <20120413142352.3b927516@destiny.ordissimo>
References: <20120413142352.3b927516@destiny.ordissimo>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

On Fri, 13 Apr 2012 14:23:52 +0200, Anisse Astier <anisse@astier.eu> wrote :

> [resent with compressed dmesg(<40k) and removed one Cc:, sorry for the spam]
> 
> Hi,
> 
> I have two[1] (seemingly) identical mini pcie RT5390 wireless cards. One
> works, the other doesn't.
> By "doesn't" work, I mean it can't receive any network further than 1m(at
> least it's still "wireless" ;-)). Scan is empty, except if I put the AP
> right next to the laptop.
> 
> I'm using the rt2800pci in-kernel driver. Support for this card was added
> in 2.6.39. To make sure there was no regression, I tested the following
> kernels: 2.6.39.4, 3.0.8, 3.2.5, 3.3.1 and wireless-next as of today.
> I'm also using the latest firmware rt2860.bin version 34 from official
> linux-firmware git tree.
> 
> Behaviour is reproduced with or without plugging the antenna. Behaviour
> follows the card, if I put on another motherboard.
> 
> Markings on the chips are identical whether it's working or not:
>  - Ralink RT5390RL NAF8590109 1133STA1
> 
> lspci[3] doesn't change (except mac address) whether it's working or not.
> dmesg (attached) with rt2x00 debug output doesn't show anything special.
> 
> I've tried rt5390sta[2], and it doesn't help. Working card is working,
> non-working is not.
> 
> 
> Last, but not least, it works on windows. 
>  - if we reboot from windows, it works
>  - if we halt the hardware, and power it on, it doesn't work.
> Which means that the windows driver does something that rt2800pci
> doesn't, and that the state is preserved as long as we don't cut power.
> 
> 
> Regards,
> 
> Anisse
> 
> 
[...]

Ok, I've found a solution.

After looking into the latest ralink release, for chipset 5572, I saw
that rt5390 support was updated. And that support for the chip with rev
1502 was added, named RT5390R.
The only difference with "normal" 5390 is that this one supports hardware
antenna diversity, so the driver should tell the card which antenna to
use by default (the main one in my case).
This is replicated in the patch below, which has been tested on both
working and non-working 1502s, and is proving to work quite well.

I still don't know how to integrate this properly with rt2800pci's
antenna diversity code, since this is the first chipset to have hardware
antenna diversity in the rt2800 family (others had it in rt61 and rt73
for example).

I'll look into it over the next two weeks, and send a patch if no one
does before.



From: Anisse Astier <anisse@astier.eu>
Date: Tue, 17 Apr 2012 12:23:21 +0200
Subject: [PATCH] rt2800: add chipset RT5390R support

This is for testing Only !! Please don't merge !
---
 drivers/net/wireless/rt2x00/rt2800.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c |   12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 063bfa8..1ce2634 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -83,6 +83,7 @@
 #define REV_RT3090E			0x0211
 #define REV_RT3390E			0x0211
 #define REV_RT5390F			0x0502
+#define REV_RT5390R			0x1502
 
 /*
  * Signal information.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index bd19802..e94661f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3928,6 +3928,18 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 	}
 
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
+		rt2x00dev->default_ant.tx = ANTENNA_HW_DIVERSITY;
+		rt2x00dev->default_ant.rx = ANTENNA_HW_DIVERSITY;
+		rt2x00dev->default_ant.rx_chain_num = 0;
+		rt2x00dev->default_ant.tx_chain_num = 0;
+
+		rt2800_bbp_write(rt2x00dev, 150, 0);
+		rt2800_bbp_write(rt2x00dev, 151, 0);
+		rt2800_bbp_write(rt2x00dev, 154, 0);
+		rt2800_bbp_write(rt2x00dev, 152, 0x80);
+	}
+
 	return 0;
 }
 
-- 
1.7.9.4

