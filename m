Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1520 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1KVWQl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 17:16:41 -0500
Message-ID: <4ECC1F41.90003@broadcom.com> (sfid-20111122_231644_906016_BD5D387F)
Date: Tue, 22 Nov 2011 14:16:33 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac + compat wireless + 2.6.35
References: <201111221600.31514.GNUtoo@no-log.org>
 <201111222046.54310.GNUtoo@no-log.org>
In-Reply-To: <201111222046.54310.GNUtoo@no-log.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis,

On 11/22/2011 11:46 AM, Denis 'GNUtoo' Carikli wrote:
>   * adding an if 0 in brcmf_sdcard_intr_reg removes the problematic dmesg
> message:
> int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
> {
>          brcmf_dbg(TRACE, "Entering\n");
> #if 0
>          sdio_claim_host(sdiodev->func[1]);
>          sdio_claim_irq(sdiodev->func[1], brcmf_sdioh_irqhandler);
>          sdio_release_host(sdiodev->func[1]);
> #endif
>          return 0;
> }
> but then:
> # ifconfig wlan0 up
> ifconfig: SIOCSIFFLAGS: Operation not permitted
> (with rfkill state ok (soft = 0, hard = 0, state = 1) and beeing root.

Root cause for the mmc complain is that there is no handler for function 
2 interrupt. 4329 generate a SDIO interrupt when there are something 
available for the driver to retrieve from the dongle. It will flag both 
function 1 and function 2 at the same time. They are identical. A empty 
dummy irq handler register to function 2 irq will make the warning go 
away. FWIW, it doesn't affect anything here since they have been taken 
care in function 1 irq handler. I will submit a patch too add the dummy 
handler.

Thanks,
Franky

