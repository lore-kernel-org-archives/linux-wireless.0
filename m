Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28749 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab2AILqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 06:46:50 -0500
Message-ID: <4F0AD3A1.5020100@qca.qualcomm.com> (sfid-20120109_124654_126883_CA80C432)
Date: Mon, 9 Jan 2012 13:46:41 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Thirumalai <tpachamu@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 0/4] Enable uAPSD support in AP mode
References: <1326095083-1538-1-git-send-email-tpachamu@qca.qualcomm.com>	 (sfid-20120109_084754_846351_9C65331D) <1326099268.3451.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1326099268.3451.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 10:54 AM, Johannes Berg wrote:
> On Mon, 2012-01-09 at 13:14 +0530, Thirumalai wrote:
>> In addition to legacy power save, this series of patch adds
>> support for uAPSD in AP mode.
>>
>> When connected station goes into suspend state, the driver will
>> start queuing pkts in the separate queue (called uapsd queue)
>> until the station ask for it. 
>>
>> The moment driver starting queuing, it will enable traffic indication
>> bit for the client connected to indicate data availability. 
>> Once station ask for the data (via Trigger frame), the driver will 
>> dequeue and send pkt one by one to the station.
> 
> The way you describe this sounds incorrect, but I'll leave it to Kalle
> to figure out what you're doing and whether it is correct or not ... if
> only some ACs are trigger-enabled those don't influence the TIM bit.

Yeah, that does sound odd. Thirumalai, does the code really this way or
is it just a problem with the description? (I need to study the code in
detail still.)

Johannes, thanks for pointing this out.

Kalle
