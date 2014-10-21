Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:45419 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaJUIgD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 04:36:03 -0400
Message-ID: <54461AEF.7040304@openwrt.org> (sfid-20141021_103610_561324_F974DF37)
Date: Tue, 21 Oct 2014 10:35:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?UTF-8?B?TGF1cmVuyJtpdSBOaWNvbGE=?= <lnicola@dend.ro>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi: Reason 7 periodic disconnect
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com> <1413510814.22769.6.camel@dcbw.local> <1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com> <CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com> <1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com> <CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com> <CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com> <1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com> <CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com> <1413833365.2949853.181221645.22D54845@webmail.messagingengine.com> <CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com> <54461740.5000903@openwrt.org> <1413879792.3500640.181427549.198E9452@webmail.messagingengine.com>
In-Reply-To: <1413879792.3500640.181427549.198E9452@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-10-21 10:23, Laurențiu Nicola wrote:
> It's an ASUS RT-N66U running NEWD-2/K3X from r24160.
This is a Broadcom based device, so it should behave in the same way as
other APs/Routers running the Broadcom drivers.
The driver should only send Reason 7 when receiving a PS-Poll, BlockAck,
BlockAckReq or Action frame from a station that's not associated, so
probably it has already kicked out your iwlwifi client earlier. Not sure
why that doesn't show up in the log though.

- Felix
