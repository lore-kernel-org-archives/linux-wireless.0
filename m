Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:1244 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbYKNTdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 14:33:21 -0500
Received: by yx-out-2324.google.com with SMTP id 8so693786yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 11:33:20 -0800 (PST)
Message-ID: <449c10960811141133o6d34c53fke3894a32cc1e5b8b@mail.gmail.com> (sfid-20081114_203327_101334_6FA47B9A)
Date: Fri, 14 Nov 2008 13:33:19 -0600
From: "Dan McGee" <dpmcgee@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: Sujith <m.sujith@gmail.com>, "Bob Copeland" <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <43e72e890811141037j5328f71fx7badb6f2b0e0831d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	 <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <43e72e890811140937h4dc03cf8g50df7f74efcd28b2@mail.gmail.com>
	 <b6c5339f0811140949m462e3eecx49f114f729b33e7c@mail.gmail.com>
	 <43e72e890811141006x1c396c78ube87a526f1435676@mail.gmail.com>
	 <18717.49111.572993.44410@localhost.localdomain>
	 <43e72e890811141029q24ad722fi6a7ae1e7dcd463bd@mail.gmail.com>
	 <18717.50308.330801.765686@localhost.localdomain>
	 <43e72e890811141037j5328f71fx7badb6f2b0e0831d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 12:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Nov 14, 2008 at 10:33 AM, Sujith <m.sujith@gmail.com> wrote:
>> Luis R. Rodriguez wrote:
>>> > From the original log:
>>> > ath5k_pci 0000:01:00.0: registered as ''
>>>
>>> That comes from
>>>
>>> dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
>>>
>>> which means that may be buggy too as wiphy_name() gets
>>>
>>> return wiphy->dev.bus_id;
>>>
>>> and we only have set at that point wiphy->dev.parent IIRC.
>>>
>>
>> Nope, parent is set after that call in SET_IEEE80211_DEV()
>> phy[x] gets assigned in alloc_hw().
>>
>> So why is it NULL even if alloc_hw() succeeds ?
>
> Parent is wiphy->dev.parent not wiphy->dev though

So I'm at work for another 4 or 5 hours, but I should have a chance to
hack at anything tonight you guys want me to. Let me know if the
earlier suggestions in this thread still apply.

-Dan
