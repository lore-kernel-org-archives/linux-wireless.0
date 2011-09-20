Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55450 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab1ITWyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 18:54:15 -0400
Message-ID: <4E791992.2090406@openwrt.org> (sfid-20110921_005418_920337_2CDB56E1)
Date: Wed, 21 Sep 2011 00:54:10 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Javier Cardona <javier@cozybit.com>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com> <loom.20110918T004437-426@post.gmane.org> <1316437459.5995.29.camel@jlt3.sipsolutions.net> <36569806.Rgjanm0GiI@alex-1> <1316521312.3953.27.camel@jlt3.sipsolutions.net> <CAB=NE6VDSTAKK0pmyBOz6hw1pbxo7U6dxbrvg_F-y6CDB0paKw@mail.gmail.com> <4E78D990.3090601@openwrt.org> <CAB=NE6VZeCViBZA9++NcgZ2JcDppbp3OuagRVK02ENjdb-MAQA@mail.gmail.com> <4E78DF6F.3060304@openwrt.org> <CAB=NE6XqT_ZUV7F+0ZvCs-WgxZnJn3onMiWNtBi=+eCkMZMgPA@mail.gmail.com> <4E78EA05.6000005@openwrt.org> <CAB=NE6WhaNpjpernCGY9skU+e+cUurPxi7r-FKaeH5iybeqGEg@mail.gmail.com> <4E78FFEB.1090301@openwrt.org> <CAB=NE6W76dg_KaN6jB-OQ2xf7Xx93a4ruqzQDwg5+rcwOcSfXg@mail.gmail.com> <4E790B3B.9090004@openwrt.org> <CAB=NE6UYY5sbpmkTHPx1LVFh6SC0QebqhKcpYCawZryvttOS=A@mail.gmail.com>
In-Reply-To: <CAB=NE6UYY5sbpmkTHPx1LVFh6SC0QebqhKcpYCawZryvttOS=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-21 12:37 AM, Luis R. Rodriguez wrote:
> On Tue, Sep 20, 2011 at 2:52 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  On 2011-09-20 11:26 PM, Luis R. Rodriguez wrote:
>>>
>>>  On Tue, Sep 20, 2011 at 2:04 PM, Felix Fietkau<nbd@openwrt.org>    wrote:
>>>>
>>>>    If we want to properly enforce Annex J channel pairs, this needs to
>>>>    be moved to cfg80211.
>>>
>>>  This does not still address the issue of one peer finding out it
>>>  cannot deal with an HT40 pair and correcting the topology and
>>>  propagating this out. Not yet sure if for 802.11ac we'll need
>>>  something similar but its worth considering.
>>
>>  Don't think of it as a topology. Each node makes its own decisions about
>>  HT40+/HT40-/HT20.
>
> OK lets go with an example.
>
> Node A: HT40+
>     Primary: 5785 (157)
>     Extension: 5805 (161)
>
> Node B: HT20 as it finds a legacy AP with on 5805.
>    Channel: 5785 (157)
>
> Node C: HT40-
>    Primary:  5785 (157)
>    Extension: 5765 (153)
>
> So we want to support this setup?
>
> What if the network changes and we cannot use the original HT40 pair
> now but we can later? This applies even to today's hostapd AP setup
> and more rhetorical.
Whenever a node is not alone in an IBSS, it must keep the primary 
channel the same to be able to talk to its neighbors. If it cannot use 
its HT40 opmode because of overlap checks then it should just gracefully 
fall back to HT20. Refusal to join or randomly changing the primary 
channel would create big problems for bigger deployments, IBSS merging 
should always be considered potentially unreliable.

Most big ad-hoc mesh deployments use fixed channel and fixed cell-id for 
that reason.

- Felix
