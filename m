Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:6034 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbYFZSJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:09:47 -0400
Received: by wf-out-1314.google.com with SMTP id 27so122189wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 11:09:47 -0700 (PDT)
Message-ID: <69e28c910806261109i28fe2c29t5218f32f5e65c378@mail.gmail.com> (sfid-20080626_200950_842498_ED86B0C0)
Date: Thu, 26 Jun 2008 20:09:47 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [Q] ath5k : doesn't support AP mode?
Cc: "Pavel Roskin" <proski@gnu.org>, cs010101@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1214501242.3783.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <1214449044.18897.15.camel@dv>
	 <1214487200.20763.44.camel@johannes.berg>
	 <1214492236.30044.7.camel@dv>
	 <69e28c910806260846s3b02cdddlca3ac138acadd8bd@mail.gmail.com>
	 <1214496086.30722.14.camel@dv> <1214501242.3783.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2008 at 7:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-06-26 at 12:01 -0400, Pavel Roskin wrote:
>> On Thu, 2008-06-26 at 17:46 +0200, Stefanik G=E1bor wrote:
>>
>> > Maybe we had more people working on/debugging AP mode if we didn't
>> > intentionally disable the existing limited support for it... Possi=
bly
>> > print a big warning that "THIS IS NOT STANDARDS_COMPLIANT YET!", b=
ut
>> > outright disabling it and requiring an external patch is IMHO stup=
id.
>> > Perhaps a Kconfig option with EXPERIMENTAL and default=3Dn would b=
e
>> > better.
>>
>> I agree.  More people would be looking into AP support for individua=
l
>> drivers if mac80211 didn't need a patch.
>
> Oh and I never answered to this. I disagree. Requiring people to patc=
h
> their kernel for AP mode support is a good way to discourage
> "contributors" who don't even know how to compile a kernel, trust me,
> I've seen a fair share of private mails from those (which I ignore: d=
o
> not mail me in private about AP support).
>
> Hence, I don't want to do it for exactly this reason: a bunch of dumb
> users will enable it either way, and actually _working_ on AP mode
> _will_ require kernel patches, so this isn't one that matters.

The problem is that the location of the patch is extremely
non-obvious. Essentially one must know the location of either your or
Michael Buesch's patchset before doing anything with AP mode. Also, to
me "AP support requires mac80211 and nl80211 enhancements. In addition
to this you need external wireless-test.git patches from johill and
hostapd patches" (from the TODO-list) suggests that more than just the
"Allow AP/VLAN modes" patch is required to get any AP support - in
fact, it might feel like it's easier to just write a monitor-mode
injection app that can do all AP work in userspace (=E1 la airbase-ng,
just with better system integration and feature set centered around
normal operation, rather than penetration testing).

Also, someone who can't patch a kernel likely also won't be able to
compile and use a git build of hostapd. IMO this provides enough
foolproofing. If we need more, then maybe add a secret and
undocumented (but clearly deducible from the code, not obfuscated)
parameter to hostapd, without which it refuses to handle nl80211-based
interfaces. The location of the patch can in no way be deduced from
the code.

And, by the way, should we also require a patch for all experimental
drivers? I don't think so.

>
> johannes
>



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
