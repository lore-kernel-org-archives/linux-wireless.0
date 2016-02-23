Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54436 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbcBWVPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 16:15:18 -0500
Subject: Re: [PATCH] mac80211: Let VHT work on 2.4Ghz
To: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes@sipsolutions.net>
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
 <1456236627.9910.10.camel@sipsolutions.net> <20160223210821.GA8062@w1.fi>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56CCCBE5.5040700@candelatech.com> (sfid-20160223_221522_804965_1BA52202)
Date: Tue, 23 Feb 2016 13:15:17 -0800
MIME-Version: 1.0
In-Reply-To: <20160223210821.GA8062@w1.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2016 01:08 PM, Jouni Malinen wrote:
> On Tue, Feb 23, 2016 at 03:10:27PM +0100, Johannes Berg wrote:
>> What you really "want" is to use VHT modulations, mostly for the
>> dubious purpose of marketing benchmarks to reach 256-QAM modulations.
>>
>> I think the de-facto standard for this would be to use IEs similar to
>> VHT ones, encapsulated in some (Broadcom?) vendor IE. We may have to
>> work with that, but that's not what this patch does. Jouni had some
>> better idea how this worked, I think.
>
> hostapd has code to negotiate this using the vendor specific element. I
> think we ended up getting this working with AP side (i.e., ath10k on the
> AP) and if I've understood correctly, this does not need any additional
> changes on top of what is available in upstream kernel and hostapd.
>
> Station mode is something that may have been left open since this issue
> of what and how to advertise as capabilities came up and there was not
> strong enough push at the time to get more than AP side functional..

Hostapd and supplicant did not need any changes in my testing.

But, you *have* to modify the kernel or it will disable VHT no matter
what supplicant says...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

