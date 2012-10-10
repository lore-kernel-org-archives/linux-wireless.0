Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63692 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab2JJThi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 15:37:38 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so728912lbo.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2012 12:37:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349859938.4683.45.camel@jlt4.sipsolutions.net>
References: <1349814468-6512-1-git-send-email-ashok@cozybit.com>
 <1349814468-6512-2-git-send-email-ashok@cozybit.com> <1349859938.4683.45.camel@jlt4.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Wed, 10 Oct 2012 12:37:15 -0700
Message-ID: <CACcxo+o4PxF_M--SHUN1nV4MVfaRFeDmpy9TNZtJ=aQ2osxzEg@mail.gmail.com> (sfid-20121010_213743_296275_D95B43D7)
Subject: Re: [PATCH 2/2] [nl,cfg,mac]80211: Add nl80211 command to get mesh
 network statistics
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

Thanks for your comments.

On Wed, Oct 10, 2012 at 2:05 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-10-09 at 13:27 -0700, Ashok Nagarajan wrote:
>> The command NL80211_CMD_GET_MESH_STATS gets the statistical information about
>> the mesh network. Currently, the following statistics are provided:
>>
>> 1. Mesh forwarded multicast frames
>> 2. Mesh forwarded unicast frames
>> 3. Mesh total forwarded frames
>> 4. Dropped frames due to mesh_ttl == 0
>> 5. Dropped frames due to no route found
>> 6. Dropped frames due to congestion
>>
>> The attibute NL80211_ATTR_MESH_PARAMS enumerates the various mesh statistical
>> parameters. A new call back get_mesh_stats() is added. mesh_stats struct is
>> moved from mac80211/ieee80211_i.h to net/cfg80211.h.
>
> I'll need to think about this a bit. What I'm thinking:
>
>  * is a new nl80211 command really the same API?
>  * should ethtools stats be provided maybe (in addition?)
>
We didn't consider ethtools when implementing this. It seems to be a
good approach. I will send a patch to address the same.

Thanks,
Ashok

> I think this is probably fine though.
>
>
> Some additional comments on the patch itself:
>
>> +struct mesh_stats {
>
> That should probably get a cfg80211_ prefix?
>
>> +     u32 fwded_mcast;
>
> Should we change those to u64 while at it, since it's now part of the
> userspace API in nl80211?
>
>> +static int ieee80211_get_mesh_stats(struct wiphy *wiphy,
>> +                                 struct net_device *dev,
>> +                                 struct mesh_stats *stats)
>> +{
>> +     struct ieee80211_sub_if_data *sdata;
>> +     sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +
>> +     memcpy(stats, &sdata->u.mesh.mshstats, sizeof(*stats));
>
> should this provide a way to say "I only have these stats" in case other
> people later implement it? OTOH, they can do that when they implement it
> and don't have all the stats.
>
> johannes
>
