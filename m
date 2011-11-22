Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp204.alice.it ([82.57.200.100]:43627 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074Ab1KVTq5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 14:46:57 -0500
Received: from trisquel.localnet (80.116.67.249) by smtp204.alice.it (8.6.023.02) (authenticated as editempo@alice.it)
        id 4ECA5ECD000EC17A for linux-wireless@vger.kernel.org; Tue, 22 Nov 2011 20:46:55 +0100
From: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac + compat wireless + 2.6.35
Date: Tue, 22 Nov 2011 20:46:54 +0100
References: <201111221600.31514.GNUtoo@no-log.org>
In-Reply-To: <201111221600.31514.GNUtoo@no-log.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201111222046.54310.GNUtoo@no-log.org> (sfid-20111122_204702_708336_02F47192)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some more infos:

 * The version of compat wireless used is the following: 
compat-wireless-2011-11-21

 * adding an if 0 in brcmf_sdcard_intr_reg removes the problematic dmesg 
message:
int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
{
        brcmf_dbg(TRACE, "Entering\n");
#if 0
        sdio_claim_host(sdiodev->func[1]);
        sdio_claim_irq(sdiodev->func[1], brcmf_sdioh_irqhandler);
        sdio_release_host(sdiodev->func[1]);
#endif
        return 0;
}
but then:
# ifconfig wlan0 up
ifconfig: SIOCSIFFLAGS: Operation not permitted
(with rfkill state ok (soft = 0, hard = 0, state = 1) and beeing root.

Denis.
