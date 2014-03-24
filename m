Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39601 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaCXQui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 12:50:38 -0400
Message-ID: <53306239.2020006@candelatech.com> (sfid-20140324_175059_432744_B2FEC4F7)
Date: Mon, 24 Mar 2014 09:50:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: Add debugging for tx-credits usage.
References: <1395428150-31996-1-git-send-email-greearb@candelatech.com> <871txr7svw.fsf@kamboji.qca.qualcomm.com> <CA+BoTQmquq7dXTV0sSV1mJ0+8-9OuiCnqz2iN8VNO4J3iaeexQ@mail.gmail.com>
In-Reply-To: <CA+BoTQmquq7dXTV0sSV1mJ0+8-9OuiCnqz2iN8VNO4J3iaeexQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/2014 04:21 AM, Michal Kazior wrote:
> On 24 March 2014 12:12, Kalle Valo <kvalo@qca.qualcomm.com> wrote:

>>> -     status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
>>> +     status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb, __LINE__);
>>
>> Using line numbers in debug messages is very cumbersome. Some people
>> cherry pick patches, have their own changes and whatnot which will make
>> it more difficult to read the debug logs. Isn't there any better way to
>> do this?
> 
> I would prefer to explicitly wait for tx credit replenishment in
> ath10k_wmi_cmd_send() after a command is sent instead of all these
> prints. This way you can get a full call trace if it times out.

Would that be a performance problem (by effectively allowing only a single
item to be sent to the firmware at any given time?)

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

