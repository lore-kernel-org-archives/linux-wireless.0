Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:51199 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdIPSxO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Sep 2017 14:53:14 -0400
Received: by mail-pg0-f54.google.com with SMTP id p5so3125281pgn.7
        for <linux-wireless@vger.kernel.org>; Sat, 16 Sep 2017 11:53:14 -0700 (PDT)
Subject: Re: iwlwifi firmware load broken in current -git
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Luca Coelho <luca@coelho.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <CABe79T7WObM+LOGdPFfYC7hf0dKrhm5NwMgQ3DpcWst3eP6kNg@mail.gmail.com>
 <8de8d1e2-1673-e1ff-d0ac-6d3bb03e9e99@kernel.dk>
 <93bfbc9b-8829-66fa-f4d6-6d47124e460c@kernel.dk>
 <CABe79T79WhBh66iQB-5LLCQO0d37evg5tsKUGkj7+z8vNGTHcA@mail.gmail.com>
 <a5fd0c11-916f-1404-c979-2fd566ed72ec@kernel.dk>
 <ee04c95d-167b-0782-1860-253a2271d66c@kernel.dk>
 <CA+55aFzjz2c=q4Uatso1Lp6HAUOAyGdbZLWorFW56MiapoF5Sg@mail.gmail.com>
 <fe610637-ecfd-8096-8c44-4f78b4a5811a@kernel.dk>
 <1505505062.32032.1.camel@coelho.fi>
 <79b26165-7baf-c6ee-7552-1ccccb3b7192@kernel.dk>
 <20170916030311.GB16731@bhelgaas-glaptop.roam.corp.google.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <913e8f70-699c-8f87-a86c-7030fddd19b7@kernel.dk> (sfid-20170916_205331_442439_F3B6DE64)
Date: Sat, 16 Sep 2017 12:53:10 -0600
MIME-Version: 1.0
In-Reply-To: <20170916030311.GB16731@bhelgaas-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2017 09:03 PM, Bjorn Helgaas wrote:
> On Fri, Sep 15, 2017 at 01:55:57PM -0600, Jens Axboe wrote:
>> On 09/15/2017 01:51 PM, Luca Coelho wrote:
>>> On Fri, 2017-09-15 at 13:48 -0600, Jens Axboe wrote:
>>>> On 09/15/2017 01:38 PM, Linus Torvalds wrote:
>>>>> On Fri, Sep 15, 2017 at 12:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>> In any case, your patch introduces a regression on systems. Please get
>>>>>>> it reverted now, and then you can come up with a new approach to fix the
>>>>>>> double enable of the upstream bridge.
>>>>>>
>>>>>> Who's sending in the revert? I can certainly do it if no one else does,
>>>>>> but it needs to be done.
>>>>>>
>>>>>> I'm not seeing any patches coming out of Srinath to fix up the
>>>>>> situation, so we should revert the broken patch until a better solution
>>>>>> exists.
>>>>>
>>>>> Hmm. I don't have the history here (apparently it never made lkml, for
>>>>> example), so I don't even know which commit you're talking about.
>>>>>
>>>>> From some of the context it looks like commit 40f11adc7cd9 ("PCI:
>>>>> Avoid race while enabling upstream bridges"), is that correct?
>>>>
>>>> Yes, Luca says that Bjorn already sent in the revert request, I just
>>>> didn't see it since I wasn't CC'ed on it. So looks like we're all
>>>> good, provided that makes it into -rc1. 40f11adc7cd9 is the broken
>>>> commit.
>>>
>>> Strange... AFAICT you *were* CCed on it.  And so was everyone else in
>>> the original thread (+LKML)...
>>
>> Hmm, never showed up here. Very odd!
> 
> Sorry, I think this is probably because I'm an idiot and sent it from
> an @google.com account and it got rejected because the DMARC check
> failed.

Ah, good to know why it didn't show up. Thanks.

-- 
Jens Axboe
