Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wal-mailgw1.qinetiq-na.com ([65.209.22.159]:1391 "EHLO
	WALQNAOMAIL1T.qnao.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752268AbZKTN4d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 08:56:33 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Kernel oops in ath9k
Date: Fri, 20 Nov 2009 08:56:09 -0500
Message-ID: <712C9C7AD151C847B09F32EDA56A94CF0115C73C@WALQNAOMAIL1T.qnao.net>
In-Reply-To: <1258687496.12864.35.camel@ct>
References: <712C9C7AD151C847B09F32EDA56A94CF0115C555@WALQNAOMAIL1T.qnao.net> <1258687496.12864.35.camel@ct>
From: "Douglass, Woodrow" <Woodrow.Douglass@QinetiQ-NA.com>
To: "Pavel Roskin" <proski@gnu.org>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the quick reply Pavel! I've seen this Oops with kernel
2.6.31.6, as well as with the  latest linux-wireless that I downloaded
on the 18th of november. Also, it's interesting that the card is
identified as having a AR9280 chipset, the website for the card
(http://www.ubnt.com/products/sr7112.php) says the card has an AR9220
chipset. Could this be causing the problem?

I'm going to repost this to the ath9k mailing list you mentioned.

Thanks again,
Woody

> -----Original Message-----
> From: Pavel Roskin [mailto:proski@gnu.org] 
> Sent: Thursday, November 19, 2009 10:25 PM
> To: Douglass, Woodrow
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: Kernel oops in ath9k
> 
> On Thu, 2009-11-19 at 09:54 -0500, Douglass, Woodrow wrote:
> > Hi all,
> > 
> > I'm not sure if this is the right place to post this, but I 
> may have a 
> > bug report for the ath9k driver.
> 
> You may want to post to ath9k-devel@lists.ath9k.org, as the 
> problem seems to be specific to the Atheros driver.
> 
> > I'm running a single board computer with a 600Mhz celeron 
> processor. 
> > On the minipci bus I have a Ubiquiti SR71-12 802.11n card.
> 
> It would be helpful if you also specified the exact version 
> of the kernel.
> 
> >  Also attached is
> > a shell script with the commands I run to cause the oops. Note that 
> > the first time the ifconfig line in this script is run, a 
> "SIOCSIFFLAGS:
> > Input/Output Error" is triggered, the kernel oops happens about 5 
> > seconds after the ifconfig line is run a second time.
> 
> I can reproduce "Input/Output Error" with SR71-12, but not 
> the oops with the current linux-wireless.
> 
> I know that it's caused by returning false in this code in 
> file drivers/net/wireless/ath/ath9k/calib.c, function 
> ath9k_hw_init_cal():
> 
>                 /* Poll for offset calibration complete */
>                 if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, 
> AR_PHY_AGC_CONTROL_CAL,
>                                    0, AH_WAIT_TIMEOUT)) {
>                         ath_print(common, ATH_DBG_CALIBRATE,
>                                   "offset calibration failed to "
>                                   "complete in 1ms; noisy 
> environment?\n");
>                         return false;
>                 }
> 
> With full debugging (modprobe ath9k debug=0xffffffff), the 
> kernel messages are (with some context):
> 
> ath: Reset TXQ, inactive queue: 7
> ath: Reset TX queue: 8
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 9
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: ah->misc_mode 0x4
> ath: timeout (100000 us) on reg 0x9860: 0xdeadbeef & 
> 0x00000001 != 0x00000000
> ath: offset calibration failed to complete in 1ms; noisy environment?
> ath: Unable to reset hardware; reset status -5 (freq 2412 MHz)
> 
> I have access to various Ubiquiti cards, but SR71-12 is the 
> only one that fails.  I know that it works in Windows XP with 
> the Ubiquiti driver for other SR71 cards (the inf file should 
> be tweaked to recognize the revision of SR71-12).  That makes 
> me think the problem is not in the hardware and not in the 
> noisy environment.
> 
> ath9k identifies the card as:
> 
> phy0: Atheros AR9280 Rev:2 mem=0xffffc90010da0000, irq=18
> 
> # lspci -vnn -s 03:01.0
> 03:01.0 Network controller [0280]: Atheros Communications 
> Inc. AR922X Wireless Network Adapter [168c:0029] (rev 01)
>         Subsystem: Device [0777:4002]
>         Flags: bus master, 66MHz, medium devsel, latency 168, IRQ 18
>         Memory at fe3f0000 (32-bit, non-prefetchable) [size=64K]
>         Capabilities: [44] Power Management version 2
>         Kernel driver in use: ath9k
>         Kernel modules: ath9k
> 
> --
> Regards,
> Pavel Roskin
> 
