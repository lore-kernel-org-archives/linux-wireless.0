Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:61057 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYKNUlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 15:41:07 -0500
Received: by gxk4 with SMTP id 4so836002gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 12:41:05 -0800 (PST)
Message-ID: <43e72e890811141241k7ae83fc3qe90e2e42d61b8df6@mail.gmail.com> (sfid-20081114_214111_162938_D677F72D)
Date: Fri, 14 Nov 2008 12:41:05 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Dan McGee" <dpmcgee@gmail.com>, Sujith <m.sujith@gmail.com>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <b6c5339f0811141233g38086cc0ybb69eebdbab7ae60@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811140937h4dc03cf8g50df7f74efcd28b2@mail.gmail.com>
	 <b6c5339f0811140949m462e3eecx49f114f729b33e7c@mail.gmail.com>
	 <43e72e890811141006x1c396c78ube87a526f1435676@mail.gmail.com>
	 <18717.49111.572993.44410@localhost.localdomain>
	 <43e72e890811141029q24ad722fi6a7ae1e7dcd463bd@mail.gmail.com>
	 <18717.50308.330801.765686@localhost.localdomain>
	 <43e72e890811141037j5328f71fx7badb6f2b0e0831d@mail.gmail.com>
	 <449c10960811141133o6d34c53fke3894a32cc1e5b8b@mail.gmail.com>
	 <b6c5339f0811141233g38086cc0ybb69eebdbab7ae60@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 12:33 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Nov 14, 2008 at 2:33 PM, Dan McGee <dpmcgee@gmail.com> wrote:
>> On Fri, Nov 14, 2008 at 12:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Fri, Nov 14, 2008 at 10:33 AM, Sujith <m.sujith@gmail.com> wrote:
>>>> Luis R. Rodriguez wrote:
>>>>> > From the original log:
>>>>> > ath5k_pci 0000:01:00.0: registered as ''
>>>>>
>>>>> That comes from
>>>>>
>>>>> dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
>>>>>
>>>>> which means that may be buggy too as wiphy_name() gets
>>>>>
>>>>> return wiphy->dev.bus_id;
>>>>>
>>>>> and we only have set at that point wiphy->dev.parent IIRC.
>>>>>
>>>>
>>>> Nope, parent is set after that call in SET_IEEE80211_DEV()
>>>> phy[x] gets assigned in alloc_hw().
>>>>
>>>> So why is it NULL even if alloc_hw() succeeds ?
>>>
>>> Parent is wiphy->dev.parent not wiphy->dev though
>
> Sujith is right, wiphy->dev.bus_id should be set by the time that's printed,
> since wiphy_new in alloc_hw fills it in.

Ah, I see, yes, oh man. Well this is good :)

> Curiouser and curiouser.  I look
> forward to this being an obvious and embarrassing bug :)

I sure hope so.

>> So I'm at work for another 4 or 5 hours, but I should have a chance to
>> hack at anything tonight you guys want me to. Let me know if the
>> earlier suggestions in this thread still apply.
>
> I think the printks will still be useful, if only to verify we're on
> the right track.  Which compat-wireless version are you using?
>
> BTW from kerneloops, several people are having this with other drivers than
> ath5k.

Yeah I ran into it with iwlagn a few days ago but never found the root
cause, it was sporadic.

  Luis
