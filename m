Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:43907 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751377AbdK2C5e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 21:57:34 -0500
Subject: Re: [PATCH] ath10k: handling qos at STA side based on AP WMM
 enable/disable
To: bpothuno@qti.qualcomm.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <1511863650-9419-1-git-send-email-bpothuno@qti.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <5ec76365-7ca2-15bd-0bcc-9cc19b9f3b27@dd-wrt.com> (sfid-20171129_035738_204823_323754C3)
Date: Wed, 29 Nov 2017 03:57:31 +0100
MIME-Version: 1.0
In-Reply-To: <1511863650-9419-1-git-send-email-bpothuno@qti.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

did you notice  that Marvell 88W8964 based clients will crash 10.4-3.5.3 
firmwares?  (tested with 9984 and 10.4-3.5.3-00038)
client device was a linksys wrt3200acm running dd-wrt for testing

Am 28.11.2017 um 11:07 schrieb bpothuno@qti.qualcomm.com:
> From: Balaji Pothunoori <bpothuno@qti.qualcomm.com>
>
> Data packets are not sent by STA in case of STA joined to
> non QOS AP (WMM disabled AP). This is happening because of STA
> is sending data packets to firmware from host with qos enabled
> along with non qos queue value(TID = 16).
> Due to qos enabled, firmware is discarding the packet.
>
> This patch fixes this issue by updating the qos based on station
> WME capability field if WMM is disabled in AP.
>
> This patch is required by 10.4 family chipsets like
> QCA4019/QCA9888/QCA9884/QCA99X0.
> Firmware Versoin : 10.4-3.5.1-00018.
>
> For 10.2.4 family chipsets QCA988X/QCA9887 and QCA6174 this patch
> has no effect.
>
> Signed-off-by: Balaji Pothunoori <bpothuno@qti.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/mac.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 0a947ee..2616b99 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2563,7 +2563,7 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
>   		}
>   		break;
>   	case WMI_VDEV_TYPE_STA:
> -		if (vif->bss_conf.qos)
> +		if (sta->wme)
>   			arg->peer_flags |= arvif->ar->wmi.peer_flags->qos;
>   		break;
>   	case WMI_VDEV_TYPE_IBSS:


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
