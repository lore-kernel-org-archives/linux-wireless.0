Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1799 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3GESCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 14:02:20 -0400
Message-ID: <51D70A22.20607@broadcom.com> (sfid-20130705_200223_761051_6521DC39)
Date: Fri, 5 Jul 2013 20:02:10 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hector Palacios" <hector.palacios@digi.com>
cc: "Kalle Valo" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
Subject: Re: Passing a custom MAC to ath6kl
References: <51D6E484.9060000@digi.com>
 <87vc4pf1ln.fsf@kamboji.qca.qualcomm.com> <51D6EC90.40009@digi.com>
In-Reply-To: <51D6EC90.40009@digi.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2013 05:56 PM, Hector Palacios wrote:
> Dear Kalle,
>
> On 07/05/2013 05:49 PM, Kalle Valo wrote:
>> Hector Palacios <hector.palacios@digi.com> writes:
>>
>>> Is there a way to pass a custom MAC address to the ath6kl upstream
>>> driver?
>>
>> Not right now. It has been a common feature request so I'm hoping
>> someone will implement it soon.
>>
>>> In the ISC version of the driver, a softmac.c file is provided that
>>> reads a MAC from a file if a module parameter softmac_enable=1 is
>>> passed. Is there any reason why this has not made it upstream?
>>
>> Providing mac address through a file is too ugly for upstream. We need
>> to implement it properly using the proper interface.
>
> I totally agree. What would be the proper interface for that?

Add .ndo_set_mac_address() callback in main.c and go from there.

int (*ndo_set_mac_address)(struct net_device *dev, void *addr);

Regards,
Arend

> Best regards,
> --
> Hector Palacios
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


