Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:32772 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753831AbdBNUJJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 15:09:09 -0500
Received: by mail-qk0-f175.google.com with SMTP id p22so41747966qka.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 12:09:09 -0800 (PST)
Subject: Re: [RFC V2 1/5] nl80211: allow multiple active scheduled scan
 requests
To: Johannes Berg <johannes@sipsolutions.net>
References: <1484566941-27000-1-git-send-email-arend.vanspriel@broadcom.com>
 <1484566941-27000-2-git-send-email-arend.vanspriel@broadcom.com>
 <1485250815.7244.8.camel@sipsolutions.net>
 <fd4c2573-caea-1cdc-ee33-f010bb0aad58@broadcom.com>
 <1487076714.4705.11.camel@sipsolutions.net>
 <deef3e83-b6d8-f99d-516d-dc6e99013560@broadcom.com>
 <1487077927.4705.14.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e2ec8547-4e0d-881b-5f4e-1e61d4b8b047@broadcom.com> (sfid-20170214_210913_313988_AA4C6B89)
Date: Tue, 14 Feb 2017 21:09:06 +0100
MIME-Version: 1.0
In-Reply-To: <1487077927.4705.14.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-2-2017 14:12, Johannes Berg wrote:
> On Tue, 2017-02-14 at 14:07 +0100, Arend Van Spriel wrote:
> 
>>> No. But there was a size limit on how much older userspace could
>>> process before we did the splitting.
>>
>> I see. So basically adding stuff to (split_start == 0) is not wanted.
> 
> Correct.

Uhm. Now I am staring at the code there and wonder about following. Up
until (split_start == 7) I see:

		state->split_start++;
		if (state->split)
			break;

For the remaining cases the break is unconditional. Any idea how to
interpret that?
	
>> Just trying to get a clear requirement/rule here. Do we (still) know
>> the exact size limit?
> 
> No, I don't remember. It's pretty ancient versions of iw/wpa_s that
> weren't able to deal with it. There was also interaction with the
> allocations in the dump function in nl80211 code itself, but we made
> those pretty big already and userspace limits came into play iirc.

Thanks,
Arend
