Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46356 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1ITWjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 18:39:40 -0400
Received: by qyk30 with SMTP id 30so4437634qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 15:39:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E790F13.4070609@openwrt.org>
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
 <loom.20110918T004437-426@post.gmane.org> <1316437459.5995.29.camel@jlt3.sipsolutions.net>
 <36569806.Rgjanm0GiI@alex-1> <1316521312.3953.27.camel@jlt3.sipsolutions.net>
 <CAB=NE6VDSTAKK0pmyBOz6hw1pbxo7U6dxbrvg_F-y6CDB0paKw@mail.gmail.com>
 <4E78D990.3090601@openwrt.org> <CAB=NE6VZeCViBZA9++NcgZ2JcDppbp3OuagRVK02ENjdb-MAQA@mail.gmail.com>
 <4E78DF6F.3060304@openwrt.org> <CAB=NE6XqT_ZUV7F+0ZvCs-WgxZnJn3onMiWNtBi=+eCkMZMgPA@mail.gmail.com>
 <4E78EA05.6000005@openwrt.org> <CAB=NE6WhaNpjpernCGY9skU+e+cUurPxi7r-FKaeH5iybeqGEg@mail.gmail.com>
 <4E78FFEB.1090301@openwrt.org> <CAB=NE6W76dg_KaN6jB-OQ2xf7Xx93a4ruqzQDwg5+rcwOcSfXg@mail.gmail.com>
 <CAB=NE6Wynn25oVHzrjusZ4OnrSyN-XwriVKFiPHMC+EvFqvTLg@mail.gmail.com> <4E790F13.4070609@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 20 Sep 2011 15:39:20 -0700
Message-ID: <CAB=NE6W7TihsjSGH63hv4zqUSQNxZTMrQaYDYv5KG9-xykWriw@mail.gmail.com> (sfid-20110921_003943_963687_E8104FBD)
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Javier Cardona <javier@cozybit.com>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 3:09 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-09-20 11:52 PM, Luis R. Rodriguez wrote:
>>
>> On Tue, Sep 20, 2011 at 2:26 PM, Luis R. Rodriguez<mcgrof@frijolero.org>
>>  wrote:
>>>
>>>  On Tue, Sep 20, 2011 at 2:04 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>>>
>>>>  This is not really an IBSS specific issue. It applies to WDS or monitor
>>>> mode
>>>>  as well.
>>>
>>>  Excellent point!
>>>
>>>>  If we want to properly enforce Annex J channel pairs, this needs to
>>>>  be moved to cfg80211.
>>>
>>>  This does not still address the issue of one peer finding out it
>>>  cannot deal with an HT40 pair and correcting the topology and
>>>  propagating this out. Not yet sure if for 802.11ac we'll need
>>>  something similar but its worth considering.
>>
>> Sorry I meant section 11.14.3.2 which deals with neighboring BSSes
>> from the scan list, the annex J stuff would still need to be done by
>> all the initial radiators too though for a primary.
>
> If we need to handle this properly in the initial patch, then this can
> probably only be done in a simple way by not supporting HT40 yet.

Right, sorry I should have clarified my concern was the scanning
aspect, not annex J. In this case I still do believe we can still
support HT40 but the scan stuff can go out to iw, or this may be a
good use case for stuffing some stuff into a shared library between iw
/ hostapd. The Mesh stuff will hopefully eventually be merged into
hostapd, but for adhoc it seems overkill. I was actually more
concerned about the mismatch on configuration rather than the
scanning, but I think Annex J helps with this, by fixating primaries
apart from each other.

> It should still support joining an IBSS with a different HT opmode though.

So long as the scan/check is done, sure.

  Luis
