Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:53589 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdIOT4B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 15:56:01 -0400
Received: by mail-pf0-f177.google.com with SMTP id x78so1949598pff.10
        for <linux-wireless@vger.kernel.org>; Fri, 15 Sep 2017 12:56:01 -0700 (PDT)
Subject: Re: iwlwifi firmware load broken in current -git
To: Luca Coelho <luca@coelho.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Srinath Mannam <srinath.mannam@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <04c9b578-693c-1dc6-9f0f-904580231b21@kernel.dk>
 <1505232673.5400.243.camel@intel.com> <1505234187.5400.249.camel@coelho.fi>
 <4bcbcbc1-7c79-09f0-5071-bc2f53bf6574@kernel.dk>
 <1505246657.1974.11.camel@sipsolutions.net>
 <feabbc25-eb85-ffa2-0fd6-254c07e3574b@kernel.dk>
 <CAErSpo777jq9FVRtmoHXVbzE-ZOc7mnT+eRJ_PhP_Dd=MbKv4g@mail.gmail.com>
 <e7af2f85-0ab3-e524-a544-c2ccdf4f8bd6@kernel.dk>
 <CABe79T7WObM+LOGdPFfYC7hf0dKrhm5NwMgQ3DpcWst3eP6kNg@mail.gmail.com>
 <8de8d1e2-1673-e1ff-d0ac-6d3bb03e9e99@kernel.dk>
 <93bfbc9b-8829-66fa-f4d6-6d47124e460c@kernel.dk>
 <CABe79T79WhBh66iQB-5LLCQO0d37evg5tsKUGkj7+z8vNGTHcA@mail.gmail.com>
 <a5fd0c11-916f-1404-c979-2fd566ed72ec@kernel.dk>
 <ee04c95d-167b-0782-1860-253a2271d66c@kernel.dk>
 <CA+55aFzjz2c=q4Uatso1Lp6HAUOAyGdbZLWorFW56MiapoF5Sg@mail.gmail.com>
 <fe610637-ecfd-8096-8c44-4f78b4a5811a@kernel.dk>
 <1505505062.32032.1.camel@coelho.fi>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <79b26165-7baf-c6ee-7552-1ccccb3b7192@kernel.dk> (sfid-20170915_215612_918271_FE23443B)
Date: Fri, 15 Sep 2017 13:55:57 -0600
MIME-Version: 1.0
In-Reply-To: <1505505062.32032.1.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2017 01:51 PM, Luca Coelho wrote:
> On Fri, 2017-09-15 at 13:48 -0600, Jens Axboe wrote:
>> On 09/15/2017 01:38 PM, Linus Torvalds wrote:
>>> On Fri, Sep 15, 2017 at 12:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> In any case, your patch introduces a regression on systems. Please get
>>>>> it reverted now, and then you can come up with a new approach to fix the
>>>>> double enable of the upstream bridge.
>>>>
>>>> Who's sending in the revert? I can certainly do it if no one else does,
>>>> but it needs to be done.
>>>>
>>>> I'm not seeing any patches coming out of Srinath to fix up the
>>>> situation, so we should revert the broken patch until a better solution
>>>> exists.
>>>
>>> Hmm. I don't have the history here (apparently it never made lkml, for
>>> example), so I don't even know which commit you're talking about.
>>>
>>> From some of the context it looks like commit 40f11adc7cd9 ("PCI:
>>> Avoid race while enabling upstream bridges"), is that correct?
>>
>> Yes, Luca says that Bjorn already sent in the revert request, I just
>> didn't see it since I wasn't CC'ed on it. So looks like we're all
>> good, provided that makes it into -rc1. 40f11adc7cd9 is the broken
>> commit.
> 
> Strange... AFAICT you *were* CCed on it.  And so was everyone else in
> the original thread (+LKML)...

Hmm, never showed up here. Very odd!

-- 
Jens Axboe
