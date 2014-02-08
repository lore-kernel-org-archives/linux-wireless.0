Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53254 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaBHSKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Feb 2014 13:10:31 -0500
Received: by mail-wi0-f173.google.com with SMTP id hn9so1717049wib.12
        for <linux-wireless@vger.kernel.org>; Sat, 08 Feb 2014 10:10:30 -0800 (PST)
Message-ID: <52F67313.1030706@gmail.com> (sfid-20140208_191057_616441_17B08A8C)
Date: Sat, 08 Feb 2014 20:10:27 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Petko Manolov <petkan@nucleusys.com>
CC: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi crash with 3.13
References: <20140123091659.GE9077@localhost> <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com> <20140123123125.GA3424@localhost> <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com> <20140123200045.GA4064@localhost> <52E17698.9070607@gmail.com> <20140123202142.GC4064@localhost> <20140207214054.GB7167@localhost>
In-Reply-To: <20140207214054.GB7167@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/07/2014 11:40 PM, Petko Manolov wrote:
> On 14-01-23 22:21:42, Petko Manolov wrote:
>> On 14-01-23 22:07:52, Emmanuel Grumbach wrote:
>>>
>>> Unfortunately, I can't see the loading of iwlwifi.
>>
>> It overflowed.  That's what happen when debug != 0 ... :)
>>
>>> Doesn't matter any more - I found the issue.
>>
>> Ah, good.  Cheers.
> 
> Hello Emmanuel, did you manage to fix the problem?  I can see iwlwifi related patch went into 3.13.2, but in case it was supposed to fix the 
> issue - it didn't do that for me.  As usual, can i help with anything?
> 

There is no problem to be fixed. When I said that I found the issue, I
meant that you are using a NIC which is not supposed to work on 5GHz on
these channels and this leads to the issues.
The fact that it doesn't work for you with -8.ucode proves that I am
correct.
I sent a patch that will disable 5GHz band for you from the driver level
so that you won't suffer from firmware asserts.

You told me you could work on 5GHz with this NIC - good for you.
Conclude whatever you want from this, this is none of my business - but
for sure, the "issues" you are seeing are related to the fact that your
NIC isn't supposed to be working on 5GHz, and hence, there is no bug to
be fixed.
