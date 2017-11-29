Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:53850 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751558AbdK2Idl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Nov 2017 03:33:41 -0500
Subject: Re: [PATCH] ath10k: handling qos at STA side based on AP WMM
 enable/disable
To: Balaji Pothunoori <bpothuno@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1511863650-9419-1-git-send-email-bpothuno@qti.qualcomm.com>
 <5ec76365-7ca2-15bd-0bcc-9cc19b9f3b27@dd-wrt.com>
 <e93273148ad44a54bfb39bc7018bfcc0@aptaiexm02b.ap.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <e84f2a95-178b-dc07-bc6e-9dc779e0db0f@dd-wrt.com> (sfid-20171129_093402_578641_49327924)
Date: Wed, 29 Nov 2017 09:33:36 +0100
MIME-Version: 1.0
In-Reply-To: <e93273148ad44a54bfb39bc7018bfcc0@aptaiexm02b.ap.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 29.11.2017 um 07:58 schrieb Balaji Pothunoori:
> Hi Sebastian,
>
> If I am not wrong you are seeing the issue with WRT3200ACM (Marvell 88W8964) as client + QCA9984 (FW : 10.4-3.5.3-00038) as AP with below change you are seeing the crash while running traffic between the WRT3200ACM + QCA9984 ?
> Do you used  any other client in place of WRT3200ACM ?

there is not much  traffic required. as it seems the firmware crashes 
immediatly after association. the issue is also not present in 
10.4-3.4-0082ww

> Can you share the more details on firmware crash ?

so a firmware crashdump from log? i'll try to get it within the next 
hours. just need to resetup the test scenario


Sebastian


>
> Regards,
> Balaji.
>
> -----Original Message-----
> From: Sebastian Gottschall [mailto:s.gottschall@dd-wrt.com]
> Sent: Wednesday, November 29, 2017 8:28 AM
> To: Balaji Pothunoori <bpothuno@qti.qualcomm.com>; ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] ath10k: handling qos at STA side based on AP WMM enable/disable
>
> did you notice  that Marvell 88W8964 based clients will crash 10.4-3.5.3 firmwares?  (tested with 9984 and 10.4-3.5.3-00038) client device was a linksys wrt3200acm running dd-wrt for testing
>
> Am 28.11.2017 um 11:07 schrieb bpothuno@qti.qualcomm.com:
>> From: Balaji Pothunoori <bpothuno@qti.qualcomm.com>
>>
>> Data packets are not sent by STA in case of STA joined to non QOS AP
>> (WMM disabled AP). This is happening because of STA is sending data
>> packets to firmware from host with qos enabled along with non qos
>> queue value(TID = 16).
>> Due to qos enabled, firmware is discarding the packet.
>>
>> This patch fixes this issue by updating the qos based on station WME
>> capability field if WMM is disabled in AP.
>>
>> This patch is required by 10.4 family chipsets like
>> QCA4019/QCA9888/QCA9884/QCA99X0.
>> Firmware Versoin : 10.4-3.5.1-00018.
>>
>> For 10.2.4 family chipsets QCA988X/QCA9887 and QCA6174 this patch has
>> no effect.
>>
>> Signed-off-by: Balaji Pothunoori <bpothuno@qti.qualcomm.com>
>> ---
>>    drivers/net/wireless/ath/ath10k/mac.c |    2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
>> b/drivers/net/wireless/ath/ath10k/mac.c
>> index 0a947ee..2616b99 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -2563,7 +2563,7 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
>>    		}
>>    		break;
>>    	case WMI_VDEV_TYPE_STA:
>> -		if (vif->bss_conf.qos)
>> +		if (sta->wme)
>>    			arg->peer_flags |= arvif->ar->wmi.peer_flags->qos;
>>    		break;
>>    	case WMI_VDEV_TYPE_IBSS:
>
> --
> Mit freundlichen Grüssen / Regards
>
> Sebastian Gottschall / CTO
>
> NewMedia-NET GmbH - DD-WRT
> Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
> Registergericht: Amtsgericht Darmstadt, HRB 25473
> Geschäftsführer: Peter Steinhäuser, Christian Scheele http://www.dd-wrt.com
> email: s.gottschall@dd-wrt.com
> Tel.: +496251-582650 / Fax: +496251-5826565
>

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
