Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4743 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab3HOJb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 05:31:29 -0400
Message-ID: <520C9FE5.6000203@broadcom.com> (sfid-20130815_113132_846814_C38D300A)
Date: Thu, 15 Aug 2013 11:31:17 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Pedram Navid" <pedram@pedramnavid.com>
cc: brcm80211-dev-list@broadcom.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel Panic with Linux 3.10-6
References: <CAHgnS=pnv0AV7JoDq5MCFMsDO60g1a_av0b6F-UM6V0m-7e=eQ@mail.gmail.com>
In-Reply-To: <CAHgnS=pnv0AV7JoDq5MCFMsDO60g1a_av0b6F-UM6V0m-7e=eQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary=------------040601040706080405030205
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------040601040706080405030205
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

On 08/15/2013 03:28 AM, Pedram Navid wrote:
> With the latest 3.10-6 kernel I am receiving frequent and consistent
> kernel panics. Downgrading to 3.9.5 resolves the issue.

Thanks, Pedram

I have had a couple of other report about this particular panic and did 
some investigation. It is a divide-by-zero causing the panic. I do have 
a patch to avoid that, but the root cause is something else. Is 3.10.6 
you see this on the unmodified stable release?

The attached patch avoids the panic, but you will probably have crappy 
connectivity.

Regards,
Arend

> Other users are also reporting this issue:
> https://bbs.archlinux.org/viewtopic.php?pid=1312140
>
> Hope this is the right place to post this. For reference, here is my
> card, using the brcmsmac module.
>
> 02:00.0 Network controller [0280]: Broadcom Corporation BCM4313
> 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
> Subsystem: Broadcom Corporation Device [14e4:0510]
> Flags: bus master, fast devsel, latency 0, IRQ 17
> Memory at 56000000 (64-bit, non-prefetchable) [size=16K]
> Capabilities: <access denied>
> Kernel driver in use: bcma-pci-bridge
>


--------------040601040706080405030205
Content-Type: text/plain;
 name=0001-brcmsmac-avoid-kernel-panic-due-to-divide-by-zero-er.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0=0001-brcmsmac-avoid-kernel-panic-due-to-divide-by-zero-er.pa;
 filename*1=tch

>From aeca211f0bb6186eefb7f3a6ad98115e2256e53a Mon Sep 17 00:00:00 2001
From: Arend van Spriel <arend@broadcom.com>
Date: Mon, 12 Aug 2013 12:34:45 +0200
Subject: [PATCH] brcmsmac: avoid kernel panic due to divide-by-zero error

The patch avoid the kernel panic and adds a few error log messages.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9fd6f2f..ea92ea2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -630,10 +630,21 @@ static uint brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 		dur = PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
 		if (preamble_type == BRCMS_MM_PREAMBLE)
 			dur += PREN_MM_EXT;
+
+		if (mcs > BRCMS_MAXMCS) {
+			brcms_err(wlc->hw->d11core, "wl%d: invalid mcs: %u\n",
+				  wlc->pub->unit, mcs);
+			mcs = 0;
+		}
 		/* 1000Ndbps = kbps * 4 */
 		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec),
 				   rspec_issgi(ratespec)) * 4;
 
+		if (kNdps == 0) {
+			brcms_err(wlc->hw->d11core, "wl%d: invalid zero rate: rspec=0x%x\n",
+				  wlc->pub->unit, ratespec);
+			kNdps = 6500 * 4;
+		}
 		if (rspec_stc(ratespec) == 0)
 			nsyms =
 			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
-- 
1.7.10.4


--------------040601040706080405030205--

