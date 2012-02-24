Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39619 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2BXOYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 09:24:15 -0500
Received: by iazz13 with SMTP id z13so137853iaz.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 06:24:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330068877.3426.6.camel@jlt3.sipsolutions.net>
References: <20120224033729.9256A205A0@glenhelen.mtv.corp.google.com>
	<1330068877.3426.6.camel@jlt3.sipsolutions.net>
Date: Fri, 24 Feb 2012 06:24:14 -0800
Message-ID: <CAMcMvsi_v=gb9UF3tHSZ11fnh83iE9bK7nSiwL1GB-tDqW47jQ@mail.gmail.com> (sfid-20120224_152438_151050_1A1F0E12)
Subject: Re: [RFC] mac80211: Filter duplicate IE ids
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 23, 2012 at 11:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-02-23 at 17:59 -0800, Paul Stewart wrote:
>> mac80211 is lenient with respect to reception of corrupted beacons.
>> Even if the frame is corrupted as a whole, the available IE elements
>> are still passed back and accepted, sometimes replacing legitimate
>> data.  It is unknown to what extent this "feature" is made use of,
>> but it is clear that in some cases, this is detrimental.  One such
>> case is reported in http://crosbug.com/26832 where an AP corrupts
>> its beacons but not its probe responses.
>>
>> One approach would be to completely reject frames with invaid data
>> (for example, if the last tag extends beyond the end of the enclosing
>> PDU).  The enclosed approach is much more conservative: we simply
>> prevent later IEs from overwriting the state from previous ones.
>> This approach hopes that there might be some salient data in the
>> IE stream before the corruption, and seeks to at least prevent that
>> data from being overwritten.  This approach will fix the case above.
>>
>> Short of any statistics gathering in the various forms of AP breakage,
>> it's not possible to ascertain the side effects of more stringent
>> discarding of data.
>
> Hmmm. This seems reasonable, but in the given example (in the bug
> report) it will at least lose the WMM info (since it's corrupt) and the
> HT info, as well as WPS (which is probably not relevant.)

As you can see from the association request, the STA appears to hold
an amalgamation of the broken rate information in the beacon and the
correct HT/WMM information from the probe response.  In the
association request there's both HT and WMM info, as it was able to
get it from the probe response.

> I suppose better to accept such service degradation than not connect,
> but I wonder if we should log a warning when we actually try to use such
> an AP?

Let me know where you'd like it.

> johannes
>
>
