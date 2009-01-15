Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47877 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbZAOHwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 02:52:36 -0500
Received: by bwz14 with SMTP id 14so2975698bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 23:52:33 -0800 (PST)
Message-ID: <31436f4a0901142352u2b60f9e6n5940835f13658b37@mail.gmail.com> (sfid-20090115_085240_945614_B3BC8283)
Date: Thu, 15 Jan 2009 09:52:33 +0200
From: "David Shwatrz" <dshwatrz@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Userspace tools: Roadmap?
Cc: "Dan E" <trg_info@mailhaven.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1228723993.22164.65.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 <1228723993.22164.65.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I tried to understand the following but could not:

>>   For instance, how do I command a
>> channel change from userspace?  iw doesn't have that.  >Should it?

>Yes, it should, and nl80211 even supports it, but iw itself >doesn't yet.
>That's fairly easy to fix, too, but then iw won't support actually
>telling mac80211 to scan and associate etc.

Can you please explain why addition of channel changing in iw will
cause iw to not be able to support scanning and association ?
(wireless-tools has all this options).

Regards,
DavidS



On Mon, Dec 8, 2008 at 10:13 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-12-07 at 18:29 -0500, Dan E wrote:
>> Looking at some of the Linux Wireless website pages it appears as though
>> "iw" is meant to be the successor to the older pre-mac80211 userspace
>> tools.  In that category we have ifconfig, iproute2, iwconfig and
>> iwpriv.  For an AP there's also hostapd and wpa_supplicant.  Probably
>> some others I've missed, not to mention Network Manager.  I can see how
>> configuration and setup wouldn't necessarily be limited to "iw" using
>> nl/cfg80211, but in the short term is that the tool of choice for
>> migrating the functionality of the old tools to the new mac80211
>> infrastructure?
>
> Not really, in the short term, you still are using iwconfig (wireless
> extensions) with anything but hostapd.
>
>> Here's my situation: [snip]
>
> nice
>
>> Userspace tools.  I want to proceed as if Wireless Extensions never
>> existed.  Is that even possible?
>
> No, it's not.
>
>>   For instance, how do I command a
>> channel change from userspace?  iw doesn't have that.  Should it?
>
> Yes, it should, and nl80211 even supports it, but iw itself doesn't yet.
> That's fairly easy to fix, too, but then iw won't support actually
> telling mac80211 to scan and associate etc.
>
>> Or do
>> I need to drop back to iwconfig?
>
> For now.
>
>> Is iw the preferred command-line way
>> to do everything the old tools did, but using nl/cfg80211 instead of
>> ioctls?
>
> Not _yet_.
>
>>   When we get to AP mode, will hostapd be re-written to speak
>> nl/cfg80211, or is a new config tool needed?  The same questions apply
>> to wpa_supplicant.
>
> That's already been done. The plan is to keep wext compatibility around
> though, obviously, so iwconfig will work in the foreseeable future.
>
>> In general, what's the way forward for new userspace tools?  nl80211 and
>> cfg80211 are a given, I understand that, but what's the recommended
>> approach from the perspective of a developer looking to make a clean
>> break from Wireless Extensions with a new cleanroom driver written from
>> scratch with no pre-existing baggage to worry about?  Start making
>> additions to iw's capabilities?  Adapt some other existing tool to use
>> nl/cfg80211, or write something completely new?
>
> If you're writing a mac80211-based driver, there's no point where you
> could possibly get in touch with the userspace API. You're writing the
> driver completely to mac80211's internal driver API, and mac80211
> completely shields you from the userspace API. You'll never interact
> with either wireless extensions or nl80211.
>
>> If somone could answer only 1 question (okay, it's a two-parter) the one
>> I would most like answered is this:  How does one, from userspace, ask
>> the driver to switch to a specific channel, and what callback(s) from
>> mac80211 should my driver expect to receive as a result?
>
> iwconfig wlan0 channel 7
>
> then mac80211 calls your _ops->config() with the channel flag. Have you
> looked at the mac80211 book and the other documentation on
> http://wireless.kernel.org/?
>
> johannes
>
