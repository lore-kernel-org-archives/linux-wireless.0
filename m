Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:45365 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbZJLI54 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 04:57:56 -0400
Received: by ewy4 with SMTP id 4so2278610ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 01:57:19 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Quintin Pitts <geek4linux@gmail.com>
Subject: Re: [RFC] p54pci: skb_over_panic, soft lockup, stall under flood
Date: Mon, 12 Oct 2009 10:57:10 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <4AD1EBA7.904@gmail.com> <4AD1FA5E.1010201@lwfinger.net> <4AD273B2.5000607@gmail.com>
In-Reply-To: <4AD273B2.5000607@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_m9u0KTW57ptgW6c"
Message-Id: <200910121057.10381.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_m9u0KTW57ptgW6c
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Monday 12 October 2009 02:09:22 Quintin Pitts wrote:
> On Sun Oct 11 2009 10:31:42 GMT-0500 (CDT), Larry Finger wrote:
> > On 10/11/2009 09:28 AM, Quintin Pitts wrote:
> > As I understand it, this patch is to fix the driver to work around
> > firmware errors. If that is correct, please state that clearly. If
> > only partially correct, then indicate which parts are to fix firmware
> > errors, and which are to fix driver errors. Has your analysis included
> > thinking about where the driver might delay to avoid firmware problems.
> 
> I think Christian has hit the nail on the head.
> Mostly flaky hardware or implementation (it8152 pci bridge) when pushed.

hmm, flaky hardware or simply incomplete linux support.
you've said that it works with win ce,
so I suppose the code is missing some important bits.

e.g.:

00:06.0 Network controller: Intersil Corporation ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
Subsystem: Intersil Corporation Device 0000
Flags: bus master, medium devsel, latency 56, IRQ 217

by the looks of it, something could wrong with the latency timer value.
(what's lspci -vvnnxxx output for the card?)

I've attached a minimal patch which c&p some latency-timer related logic
from the original prism54 driver code to p54pci.
Can you please give this a try?
I don't have a p54pci available for testing right now.

Regards,
	Chr

--Boundary-00=_m9u0KTW57ptgW6c
Content-Type: text/x-patch;
  charset="UTF-8";
  name="p54-latency.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-latency.diff"

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index d348c26..c1b1bee 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -473,6 +473,7 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 	struct ieee80211_hw *dev;
 	unsigned long mem_addr, mem_len;
 	int err;
+	u8 latency;
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -493,6 +494,12 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 		goto err_disable_dev;
 	}
 
+	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency);
+	if (latency < 64) {
+		dev_info(&pdev->dev, "set latency timer\n");
+		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 80);
+	}
+
 	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
 	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		dev_err(&pdev->dev, "No suitable DMA available\n");

--Boundary-00=_m9u0KTW57ptgW6c--
