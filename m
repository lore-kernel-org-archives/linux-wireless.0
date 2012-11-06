Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.freestuffjunction.co.uk ([109.169.51.71]:38487 "EHLO
	mail.freestuffjunction.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab2KFTgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 14:36:14 -0500
Message-ID: <5099669E.2040301@ehuk.net> (sfid-20121106_203626_441621_920D8287)
Date: Tue, 06 Nov 2012 19:35:58 +0000
From: Eddie Chapman <eddie@ehuk.net>
Reply-To: eddie@ehuk.net
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: Linux 3.6.5
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>     <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>     (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>    <509838F4.4010301@ehuk.net>   <1352188621.9440.4.camel@jlt4.sipsolutions.net>  <50992E0E.3040606@ehuk.net>  <1352217244.9440.16.camel@jlt4.sipsolutions.net>  <50995E25.6080601@ehuk.net> <1352229634.8814.8.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352229634.8814.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/12 19:20, Johannes Berg wrote:
> On Tue, 2012-11-06 at 18:59 +0000, Eddie Chapman wrote:
>> On 06/11/12 15:54, Johannes Berg wrote:
>>> The problem here is that some devices (notably iwlwifi) will not allow
>>> (by firmware) to connect to such an AP as HT40- if that is not allowed.
>>> So I prevented it generally, but we can make it device dependent. I
>>> don't like it much, but I suppose we can do it. Try this patch:
>>>
>>> http://p.sipsolutions.net/0129f39c7d882289.txt
>>>
>>> It will still prohibit this configuration when the driver said it's not
>>> allowed, but will allow it when there were other reasons to not allow
>>> it.
>>
>> Just to report, with the patch under discussion re-applied
>> (3a40414f826a8f1096d9b94c4a53ef91b25ba28d), plus the patch at your link
>> above, my throughput is back to normal again.
>
> Ok, thanks.
>
>> So I guess the above patch resolves the issue (on the face of it) for
>> me, but whether it is a suitable solution I've no idea.
>
> Right, we're still looking at that. It seems that it's not an ideal
> solution, the regulatory change I proposed is probably better. Could you
> check if it helps as well? That is, remove this patch, and apply this
> one: http://p.sipsolutions.net/8877cbe3440d94b1.txt

OK, so I've removed 0129f39c7d882289.txt, applied 8877cbe3440d94b1.txt, 
and I've kept 3a40414f826a8f1096d9b94c4a53ef91b25ba28d applied.

Rebooted, and happy to report throughput is still good, so 
8877cbe3440d94b1.txt also "fixes" it for me.

Eddie
