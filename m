Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37579 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaJUJ5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 05:57:44 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so905282wgh.5
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 02:57:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P29rXx6i=N0RGTA9arExqaANGNtaVV40T9rDY8M42Yo2g@mail.gmail.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
 <1413510814.22769.6.camel@dcbw.local> <1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
 <CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
 <1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>
 <CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>
 <CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
 <1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com>
 <CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com>
 <1413833365.2949853.181221645.22D54845@webmail.messagingengine.com>
 <CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
 <54461740.5000903@openwrt.org> <1413879792.3500640.181427549.198E9452@webmail.messagingengine.com>
 <54461AEF.7040304@openwrt.org> <CABPxzYKVzjXJQsi4WSwuw5fD5a9cD=ONJiUxdgrahurZk0K9Qg@mail.gmail.com>
 <CANUX_P29rXx6i=N0RGTA9arExqaANGNtaVV40T9rDY8M42Yo2g@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 21 Oct 2014 15:27:16 +0530
Message-ID: <CABPxzYLm98e6p8jojCxHeaQRfhyLH+jaMHYWj1K+BqhhwtsRYg@mail.gmail.com> (sfid-20141021_115748_541425_219CA940)
Subject: Re: iwlwifi: Reason 7 periodic disconnect
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?Q?Lauren=C8=9Biu_Nicola?= <lnicola@dend.ro>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2014 at 2:46 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Tue, Oct 21, 2014 at 12:05 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> On Tue, Oct 21, 2014 at 2:05 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> On 2014-10-21 10:23, Laurențiu Nicola wrote:
>>>> It's an ASUS RT-N66U running NEWD-2/K3X from r24160.
>>> This is a Broadcom based device, so it should behave in the same way as
>>> other APs/Routers running the Broadcom drivers.
>>> The driver should only send Reason 7 when receiving a PS-Poll, BlockAck,
>>> BlockAckReq or Action frame from a station that's not associated, so
>>> probably it has already kicked out your iwlwifi client earlier. Not sure
>>> why that doesn't show up in the log though.
>>>
>> May be iwlwifi is dozing and did not Rx that frame?
>
> yep - this is most probably what happens. iwlwifi goes to sleep and it
> get a deauth that it doesn't hear. Then it wakes up with an NDP and
> gets kicked out.
> But shouldn't the deauth be buffered and indicated through the TIM IE?

Yes, but not all AP's do that, at least the one i faced the issue was
not doing that.



-- 
Thanks,
Regards,
Chaitanya T K.
