Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:52132 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab1BAPFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 10:05:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 07:04:48 -0800
Message-ID: <4D482115.3090504@atheros.com>
Date: Tue, 1 Feb 2011 20:34:53 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Fix memory leak due to failed PAPRD frames
References: <1296460529-13669-1-git-send-email-mshajakhan@atheros.com> <AANLkTimbtr8zKf6Nj0GmTccKU2u2ubTkL3a5BVSGfUK0@mail.gmail.com> <4D478F12.1070404@atheros.com> <20110201140538.GA2560@tuxdriver.com>
In-Reply-To: <20110201140538.GA2560@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 February 2011 07:35 PM, John W. Linville wrote:
> On Tue, Feb 01, 2011 at 10:11:54AM +0530, Mohammed Shafi wrote:
>    
>> On Tuesday 01 February 2011 12:13 AM, Luis R. Rodriguez wrote:
>>      
>>> On Sun, Jan 30, 2011 at 11:55 PM, Mohammed Shafi Shajakhan
>>> <mshajakhan@atheros.com>   wrote:
>>>        
>>>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>>
>>>> free the skb's when the Tx of PAPRD frames fails and also add a debug
>>>> message indicating that.
>>>>
>>>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>>          
>>> Is this a stable fix?
>>>        
>> No Luis, this problem came from some recent changes in PAPRD before
>> that it was Ok.
>>      
> The patch applied to wireless-2.6 without changes, and the error
> handling for ath_tx_start matched existing usage.  So, I have it
> queued now in wireless-2.6 with an added "Cc: stable@kernel.org".
>
> Should I not?
>    
John this will be applicable for only 2.6.38 stable kernel.
The issue fixes for 2.6.37-rc5+  and this problem is not handled in the 
following commit id:

commit 7607cbe2ad6931400c5d15ced342ab329ab8f92c
Date:   Mon Dec 13 08:40:52 2010 +0100

This will not be even applicable for 2.6.37. It will introduce a 
regression of double freeing skb's.

thanks,
shafi


> John
>    
