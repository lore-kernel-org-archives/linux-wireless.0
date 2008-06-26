Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:34926 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYFZSeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:34:02 -0400
Received: by wf-out-1314.google.com with SMTP id 27so130213wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 11:34:01 -0700 (PDT)
Message-ID: <69e28c910806261134t4c6b324dj86460605e06a08c8@mail.gmail.com> (sfid-20080626_203408_807194_B0F94252)
Date: Thu, 26 Jun 2008 20:34:01 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [Q] ath5k : doesn't support AP mode?
Cc: "Pavel Roskin" <proski@gnu.org>, cs010101@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1214504454.3783.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <1214449044.18897.15.camel@dv>
	 <1214487200.20763.44.camel@johannes.berg>
	 <1214492236.30044.7.camel@dv>
	 <69e28c910806260846s3b02cdddlca3ac138acadd8bd@mail.gmail.com>
	 <1214496086.30722.14.camel@dv> <1214501242.3783.7.camel@johannes.berg>
	 <69e28c910806261109i28fe2c29t5218f32f5e65c378@mail.gmail.com>
	 <1214504454.3783.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2008 at 8:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > Oh and I never answered to this. I disagree. Requiring people to patch
>> > their kernel for AP mode support is a good way to discourage
>> > "contributors" who don't even know how to compile a kernel, trust me,
>> > I've seen a fair share of private mails from those (which I ignore: do
>> > not mail me in private about AP support).
>> >
>> > Hence, I don't want to do it for exactly this reason: a bunch of dumb
>> > users will enable it either way, and actually _working_ on AP mode
>> > _will_ require kernel patches, so this isn't one that matters.
>>
>> The problem is that the location of the patch is extremely
>> non-obvious.
>
> Umm. The paragraph you're quoting:
>
>> "AP support requires mac80211 and nl80211 enhancements. In addition
>> to this you need external wireless-test.git patches from johill and
>> hostapd patches" (from the TODO-list) suggests that more than just the
>> "Allow AP/VLAN modes" patch is required to get any AP support
>
> actually links to the patch so what is your point?

It liks to your series file, which is mostly unusable due to the NPUB
patches. (When I wrote the post, there was an additional problem with
the text that suggested that more than just that patch is needed.)
Essentially, one has to patch the patch first.

>
>> Also, someone who can't patch a kernel likely also won't be able to
>> compile and use a git build of hostapd. IMO this provides enough
>> foolproofing. If we need more, then maybe add a secret and
>> undocumented (but clearly deducible from the code, not obfuscated)
>> parameter to hostapd, without which it refuses to handle nl80211-based
>> interfaces. The location of the patch can in no way be deduced from
>> the code.
>>
>> And, by the way, should we also require a patch for all experimental
>> drivers? I don't think so.
>
> You're missing the point.
>
> We do NOT want people to use mac80211's AP support UNLESS they also work
> on improving it.
>
> The "improving it" part REQUIRES patching the kernel. Hence, requiring
> patching the kernel to get AP mode support in the first place cannot be
> considered a hindrance.
>
> johannes
>

Isn't it enough if we only put the patch in the wireless-testing
kernel, and don't commit it to the mainline? Or maybe making it depend
on BROKEN, like b43's NPHY support? What we are doing right now is
essentially the same as if Buesch changed his experimental open-source
b43 firmware to require editing the code and inserting a magic number
to make it compile. I consider that to be quite different from an &&
BROKEN in the dependency list - and && BROKEN can be removed by
someone who really wants to develop AP mode, while the current method
requires finding the patch (because the link leads to a broken SERIES
file.)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
