Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36667 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932478AbaJUT44 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 15:56:56 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by gateway2.nyi.internal (Postfix) with ESMTP id 1C44020CFD
	for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 15:56:56 -0400 (EDT)
Message-Id: <1413921415.3763081.181696749.20A0A495@webmail.messagingengine.com> (sfid-20141021_215700_244733_7ABC9B27)
From: =?UTF-8?Q?Lauren=C8=9Biu=20Nicola?= <lnicola@dend.ro>
To: poma <pomidorabelisima@gmail.com>, Felix Fietkau <nbd@openwrt.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
In-Reply-To: <54463CE9.3060400@gmail.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
 <1413510814.22769.6.camel@dcbw.local>
 <1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
 <CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
 <1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>
 <CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>
 <CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
 <1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com>
 <CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com>
 <1413833365.2949853.181221645.22D54845@webmail.messagingengine.com>
 <CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
 <54461740.5000903@openwrt.org>
 <1413879792.3500640.181427549.198E9452@webmail.messagingengine.com>
 <54461AEF.7040304@openwrt.org> <54463CE9.3060400@gmail.com>
Subject: Re: iwlwifi: Reason 7 periodic disconnect
Date: Tue, 21 Oct 2014 22:56:55 +0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yep! `scb_timeout` is 60 on my router.

On Tue, Oct 21, 2014, at 14:00, poma wrote:
> On 21.10.2014 10:35, Felix Fietkau wrote:
> > On 2014-10-21 10:23, Laurențiu Nicola wrote:
> >> It's an ASUS RT-N66U running NEWD-2/K3X from r24160.
> > This is a Broadcom based device, so it should behave in the same way as
> > other APs/Routers running the Broadcom drivers.
> > The driver should only send Reason 7 when receiving a PS-Poll, BlockAck,
> > BlockAckReq or Action frame from a station that's not associated, so
> > probably it has already kicked out your iwlwifi client earlier. Not sure
> > why that doesn't show up in the log though.
> > 
> 
> Whether this might refer to the Station Control Block Timeout value
> 
> http://www.dd-wrt.com/wiki/index.php/Wl#scb_timeout
> ...
> scb_timeout
> 
> AP only: inactivity timeout value for authenticated stas
> 
> 
> poma
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
