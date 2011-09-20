Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60649 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1ITVEs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 17:04:48 -0400
Message-ID: <4E78FFEB.1090301@openwrt.org> (sfid-20110920_230451_259593_90BA0D62)
Date: Tue, 20 Sep 2011 23:04:43 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Javier Cardona <javier@cozybit.com>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com> <loom.20110918T004437-426@post.gmane.org> <1316437459.5995.29.camel@jlt3.sipsolutions.net> <36569806.Rgjanm0GiI@alex-1> <1316521312.3953.27.camel@jlt3.sipsolutions.net> <CAB=NE6VDSTAKK0pmyBOz6hw1pbxo7U6dxbrvg_F-y6CDB0paKw@mail.gmail.com> <4E78D990.3090601@openwrt.org> <CAB=NE6VZeCViBZA9++NcgZ2JcDppbp3OuagRVK02ENjdb-MAQA@mail.gmail.com> <4E78DF6F.3060304@openwrt.org> <CAB=NE6XqT_ZUV7F+0ZvCs-WgxZnJn3onMiWNtBi=+eCkMZMgPA@mail.gmail.com> <4E78EA05.6000005@openwrt.org> <CAB=NE6WhaNpjpernCGY9skU+e+cUurPxi7r-FKaeH5iybeqGEg@mail.gmail.com>
In-Reply-To: <CAB=NE6WhaNpjpernCGY9skU+e+cUurPxi7r-FKaeH5iybeqGEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-20 10:18 PM, Luis R. Rodriguez wrote:
> On Tue, Sep 20, 2011 at 12:31 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  On 2011-09-20 9:05 PM, Luis R. Rodriguez wrote:
>>>
>>>  On Tue, Sep 20, 2011 at 11:46 AM, Felix Fietkau<nbd@openwrt.org>    wrote:
>>>>
>>>>    On 2011-09-20 8:38 PM, Luis R. Rodriguez wrote:
>>>>>
>>>>>    On Tue, Sep 20, 2011 at 11:21 AM, Felix Fietkau<nbd@openwrt.org>
>>>>>    wrote:
>>>>>>
>>>>>>     On 2011-09-20 8:12 PM, Luis R. Rodriguez wrote:
>>>>>>>
>>>>>>>     On Tue, Sep 20, 2011 at 5:21 AM, Johannes Berg
>>>>>>>     <johannes@sipsolutions.net>        wrote:
>>>>>>>>
>>>>>>>>      On Mon, 2011-09-19 at 17:46 +0200, Alexander Simon wrote:
>>>>>>>>      That seems pretty complex too ...
>>>>>>>>
>>>>>>>>      I don't really know. As I said, I think I'd be happy with an
>>>>>>>>      implementation that maybe doesn't fully implement everything as
>>>>>>>>  long
>>>>>>>>    as
>>>>>>>>      it considers the trade-offs.
>>>>>>>
>>>>>>>     The same questions come up with HT support and 802.11s, as per
>>>>>>>  Javier
>>>>>>>     this is not really well spelled out in the spec. My recommendation
>>>>>>>  is
>>>>>>>     to just support for now the most simple case and let us not entangle
>>>>>>>     ourselves with the complexities of handling trying to merge
>>>>>>>  different
>>>>>>>     setups. So only enable peering up for adhoc or mesh if and only if
>>>>>>>  the
>>>>>>>     observed IE matches our own supported HT caps or target
>>>>>>>  configuration.
>>>>>>>     If a legacy STA tries to peer up with an HT IBSS, this would simply
>>>>>>>  be
>>>>>>>     rejected. We can leave off handling the change in configuration
>>>>>>>  later
>>>>>>>     for userspace, but do not see this as being a requirement for
>>>>>>>     supporting HT for IBSS or Mesh. The simpler the better, so long as
>>>>>>>  we
>>>>>>>     simply respect the spec.
>>>>>>
>>>>>>     I disagree. That'll make it useless for real deployments, which are
>>>>>>    often a
>>>>>>     mix of HT and non-HT devices.
>>>>>
>>>>>    I'm not saying to not do it at all, I'm saying to start off with basic
>>>>>    support *first* and *later* worry about the mixing.
>>>>
>>>>    Simply sticking with the configured HT opmode is also simple, but it's a
>>>>  lot
>>>>    more practical.
>>>
>>>  Just need to deal with the complexity, the complexity question is
>>>  where do we handle this, verifying it respects the standard, and
>>>  actually getting the work done. With AP mode of operation hostapd
>>>  already does all this for us so if we want to support IBSS and Mesh
>>>  without hostapd we'd need to figure out where to stuff this code. In
>>>  the long run this would need to be resolved for both IBSS and Mesh. We
>>>  can wait for all this work to get done or get a simple taste of basic
>>>  HT support for both modes by sticking to the supported HT mode based
>>>  on the observed beacons.
>>
>>  HT capabilities are already handled properly, the main issue is handling the
>>  HT opmode. For that, the only important bit is whether we're using HT40+,
>>  HT40- or HT20. The code can easily just fall back to HT20 when the HT opmode
>>  of the peer is incompatible with the local HT opmode.
>
> How about verifying that HT40 primary, secondary channel pair is
> allowed per as IEEE 802.11n Annex J on each peer? In the AP case we do
> this centrally, but for IBSS and Mesh, does each peer have to go on
> and do the check? If each peer does the check, and change settings,
> how do we go about changing the configuration of the established HT
> configuration? Where will this code go? Currently this goes into
> hostapd for APs.
This is not really an IBSS specific issue. It applies to WDS or monitor 
mode as well. If we want to properly enforce Annex J channel pairs, this 
needs to be moved to cfg80211.

- Felix
