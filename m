Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54184 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1AJFs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 00:48:58 -0500
Message-ID: <4D2A9DC6.1030405@candelatech.com>
Date: Sun, 09 Jan 2011 21:48:54 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 2/2] ath9k:  Fix incorrect tx-hang detection logic.
References: <1294423259-8163-1-git-send-email-greearb@candelatech.com> <1294423259-8163-2-git-send-email-greearb@candelatech.com> <20110110053835.GB5656@vasanth-laptop>
In-Reply-To: <20110110053835.GB5656@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2011 09:38 PM, Vasanthakumar Thiagarajan wrote:
> On Fri, Jan 07, 2011 at 11:30:59PM +0530, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> It is not guaranteed that the ath_tx_complete_poll_work runs
>> after some fixed duration because the channel-reset logic
>> removes the work and then re-adds it to run immediately.
>> Two channel-changes 1ms apart, with a transmit was being
>> attempted, could thus incorrectly trigger a reset by
>> the ath_tx_complete_poll_work method.
>
> I don't think so. axq_tx_inprogress is reset in ath_draintxq().

Ahhh, I see now.

I'll remove this patch from my queue and make sure it still runs
as well.

Thanks,
Ben

>
> Vasanth


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
