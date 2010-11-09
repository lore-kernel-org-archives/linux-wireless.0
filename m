Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:41744 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab0KIWlS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 17:41:18 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 14:41:06 -0800
Date: Tue, 9 Nov 2010 14:41:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	David Quan <David.Quan@Atheros.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: What kind of Atheros device is this?
Message-ID: <20101109224116.GD12756@tux>
References: <4CD8A71E.6040604@lwfinger.net>
 <AANLkTi=sxSRLFEF6-kBtb_94ViyaKCmP3ra099X3G44H@mail.gmail.com>
 <93781E992CBA7843962D8B0E7D683F3C16331A1E0D@SC1EXMB-MBCL.global.atheros.com>
 <4CD9CC4E.9060208@lwfinger.net>
 <AANLkTikK+1xMAJ_4M3BKMivikKcaisEazuP_nbDbm3qJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTikK+1xMAJ_4M3BKMivikKcaisEazuP_nbDbm3qJ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 09, 2010 at 02:35:01PM -0800, Luis R. Rodriguez wrote:
> On Tue, Nov 9, 2010 at 2:33 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > On 11/09/2010 03:35 PM, David Quan wrote:
> >>
> >> "Atheros AR2427 Wireless Network Adapter"
> >>
> >> Legacy 11b/g 2.4Ghz.
> >
> > Was there a driver in Linux for this device that has been removed? The OP on the
> > openSUSE Forum claims that it "used to work".
> 
> 
> One second.

Havem them try something like this:

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index b5b6514..eab555f 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -26,6 +26,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x002B) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x002C) }, /* PCI-E 802.11n bonded out */
+	{ PCI_VDEVICE(AZWAVE,  0x1112) }, /* PCI-E 802.11n bonded out */
 	{ PCI_VDEVICE(ATHEROS, 0x002D) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
