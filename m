Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53591 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab1ITWJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 18:09:27 -0400
Message-ID: <4E790F13.4070609@openwrt.org> (sfid-20110921_000935_297622_C7EB87A4)
Date: Wed, 21 Sep 2011 00:09:23 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Javier Cardona <javier@cozybit.com>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com> <loom.20110918T004437-426@post.gmane.org> <1316437459.5995.29.camel@jlt3.sipsolutions.net> <36569806.Rgjanm0GiI@alex-1> <1316521312.3953.27.camel@jlt3.sipsolutions.net> <CAB=NE6VDSTAKK0pmyBOz6hw1pbxo7U6dxbrvg_F-y6CDB0paKw@mail.gmail.com> <4E78D990.3090601@openwrt.org> <CAB=NE6VZeCViBZA9++NcgZ2JcDppbp3OuagRVK02ENjdb-MAQA@mail.gmail.com> <4E78DF6F.3060304@openwrt.org> <CAB=NE6XqT_ZUV7F+0ZvCs-WgxZnJn3onMiWNtBi=+eCkMZMgPA@mail.gmail.com> <4E78EA05.6000005@openwrt.org> <CAB=NE6WhaNpjpernCGY9skU+e+cUurPxi7r-FKaeH5iybeqGEg@mail.gmail.com> <4E78FFEB.1090301@openwrt.org> <CAB=NE6W76dg_KaN6jB-OQ2xf7Xx93a4ruqzQDwg5+rcwOcSfXg@mail.gmail.com> <CAB=NE6Wynn25oVHzrjusZ4OnrSyN-XwriVKFiPHMC+EvFqvTLg@mail.gmail.com>
In-Reply-To: <CAB=NE6Wynn25oVHzrjusZ4OnrSyN-XwriVKFiPHMC+EvFqvTLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-20 11:52 PM, Luis R. Rodriguez wrote:
> On Tue, Sep 20, 2011 at 2:26 PM, Luis R. Rodriguez<mcgrof@frijolero.org>  wrote:
>>  On Tue, Sep 20, 2011 at 2:04 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>>  This is not really an IBSS specific issue. It applies to WDS or monitor mode
>>>  as well.
>>
>>  Excellent point!
>>
>>>  If we want to properly enforce Annex J channel pairs, this needs to
>>>  be moved to cfg80211.
>>
>>  This does not still address the issue of one peer finding out it
>>  cannot deal with an HT40 pair and correcting the topology and
>>  propagating this out. Not yet sure if for 802.11ac we'll need
>>  something similar but its worth considering.
>
> Sorry I meant section 11.14.3.2 which deals with neighboring BSSes
> from the scan list, the annex J stuff would still need to be done by
> all the initial radiators too though for a primary.
If we need to handle this properly in the initial patch, then this can 
probably only be done in a simple way by not supporting HT40 yet. It 
should still support joining an IBSS with a different HT opmode though.

- Felix
