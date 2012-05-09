Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:52124 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759027Ab2EIJlk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 05:41:40 -0400
Message-ID: <4FAA3BD2.9070203@tieto.com> (sfid-20120509_114143_130940_EC60ADB2)
Date: Wed, 9 May 2012 11:41:38 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Thomas Pedersen <thomas@cozybit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [RFC] nl80211: don't require netdev UP for wdev
References: <1335479316-2933-1-git-send-email-thomas@cozybit.com>  (sfid-20120427_002914_313709_1CC9F96D) <1336554945.4323.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336554945.4323.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-04-26 at 15:28 -0700, Thomas Pedersen wrote:
>> iw wlan0 set type mp
>> iw wlan0 set channel n
>> ip link set wlan0 up
>> iw wlan0 mesh join meshid basic-rate 1,2
>>
>> Also, 'iw set channel' is met with an -EBUSY if doing this after the
>> link is up for fixed channel modes (mesh) anyway.
>>
>> Comments? Any idea why this was required initially?
>
>
> I don't think this patch is correct -- mac80211 will get updated even if
> the device isn't even started which will likely cause trouble. Even if
> not though, this all doesn't match any kind of multi-channel concept. We
> treat the channel as part of the temporary setup, e.g. part of the
> association. AP and mesh are the only ones that are different today I
> think.

What about monitor mode?


> Overall, I don't think setting the channel&  doing mesh setup separately
> is really a good API.
>
>  From mac80211's (and other drivers if they existed) POV the channel
> should be given with the mesh_join command, like for IBSS.
>
> Now, obviously, requiring userspace to do that would be an API change.
> We probably don't want that, so I would suggest to change cfg80211 to
> track the channel and then pass it to join_mesh as one of the mesh
> parameters. This could be made work even when somebody attempts to set
> the channel before the interface is up, but we'd have to be careful
> about interface type changes.
>
> We should do the same for AP mode as well, since the channel really
> becomes relevant only upon start_ap(), before that there's no real
> concept of a channel since you don't use it yet anyway.

Maybe we should do the same with monitor interface type, i.e. introduce 
start_monitor() and have it pass the channel.

But then I'm thinking we shouldn't really be changing interface types 
explicitly, since they would be set implicitly by start_ap() and such. 
We could then use the NL80211_IFTYPE_UNSPECIFIED when we're not associated.


-- 
Pozdrawiam / Best regards, Michal Kazior.
