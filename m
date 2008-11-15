Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:60702 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYKOCFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 21:05:11 -0500
Received: by yw-out-2324.google.com with SMTP id 9so743108ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 18:05:10 -0800 (PST)
Message-ID: <449c10960811141805w428df33ak2f98651abb7403e6@mail.gmail.com> (sfid-20081115_030526_162937_996429BF)
Date: Fri, 14 Nov 2008 20:05:09 -0600
From: "Dan McGee" <dpmcgee@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Bob Copeland" <me@bobcopeland.com>, Sujith <m.sujith@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20081115003608.GK27642@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890811141006x1c396c78ube87a526f1435676@mail.gmail.com>
	 <43e72e890811141029q24ad722fi6a7ae1e7dcd463bd@mail.gmail.com>
	 <18717.50308.330801.765686@localhost.localdomain>
	 <43e72e890811141037j5328f71fx7badb6f2b0e0831d@mail.gmail.com>
	 <449c10960811141133o6d34c53fke3894a32cc1e5b8b@mail.gmail.com>
	 <b6c5339f0811141233g38086cc0ybb69eebdbab7ae60@mail.gmail.com>
	 <43e72e890811141241k7ae83fc3qe90e2e42d61b8df6@mail.gmail.com>
	 <43e72e890811141313t33b6a3edo86488bea9a7b3371@mail.gmail.com>
	 <449c10960811141625o171d1e31v974d2f921f5a825@mail.gmail.com>
	 <20081115003608.GK27642@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 6:36 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Nov 14, 2008 at 04:25:53PM -0800, Dan McGee wrote:
>> On Fri, Nov 14, 2008 at 3:13 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> > On Fri, Nov 14, 2008 at 12:41 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> >> On Fri, Nov 14, 2008 at 12:33 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> >>> On Fri, Nov 14, 2008 at 2:33 PM, Dan McGee <dpmcgee@gmail.com> wrote:
>> >>>> On Fri, Nov 14, 2008 at 12:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> >>>>> On Fri, Nov 14, 2008 at 10:33 AM, Sujith <m.sujith@gmail.com> wrote:
>> >>>>>> Luis R. Rodriguez wrote:
>> >>>>>>> > From the original log:
>> >>>>>>> > ath5k_pci 0000:01:00.0: registered as ''
>> >>>>>>>
>> >>>>>>> That comes from
>> >>>>>>>
>> >>>>>>> dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
>> >>>>>>>
>> >>>>>>> which means that may be buggy too as wiphy_name() gets
>> >>>>>>>
>> >>>>>>> return wiphy->dev.bus_id;
>> >>>>>>>
>> >>>>>>> and we only have set at that point wiphy->dev.parent IIRC.
>> >>>>>>>
>> >>>>>>
>> >>>>>> Nope, parent is set after that call in SET_IEEE80211_DEV()
>> >>>>>> phy[x] gets assigned in alloc_hw().
>> >>>>>>
>> >>>>>> So why is it NULL even if alloc_hw() succeeds ?
>> >>>>>
>> >>>>> Parent is wiphy->dev.parent not wiphy->dev though
>> >>>
>> >>> Sujith is right, wiphy->dev.bus_id should be set by the time that's printed,
>> >>> since wiphy_new in alloc_hw fills it in.
>> >>
>> >> Ah, I see, yes, oh man. Well this is good :)
>> >
>> > OK then try the patch in the other thread. If that doesn't fix it then
>> > it has to be another issue.
>>
>> Can someone point me to the "other thread"? I don't think I was CCed
>> on it since I came late to the party.
>>
>> Someone also inquired about versions. I'm using stable kernel 2.6.27.6
>> and compat-wireless-2008-11-13 (10-28 was doing the same thing
>> however).
>
> Bounced you a copy. Please give it a try.

I gave it a shot. It worked (with some conditions attached). At first
I built with just the patch, not enabling kernel debugging or
anything, and I got a different NPE in some sysfs registration code
deeper down in what I think was still the register_hw method. I can't
fully remember, because it wasn't an easily savable stack trace and I
immediately decided I would just rebuild everything with debug
symbols.

Of course, now that I have a kernel with full debug symbols, I can't
get it to oops. Figures. I'll keep you updated if I see this error
again.

-Dan
