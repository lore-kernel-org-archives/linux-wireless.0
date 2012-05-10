Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43835 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2EJSHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 14:07:10 -0400
Received: by yhmm54 with SMTP id m54so1741673yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 11:07:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336554945.4323.12.camel@jlt3.sipsolutions.net>
References: <1335479316-2933-1-git-send-email-thomas@cozybit.com> <1336554945.4323.12.camel@jlt3.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 10 May 2012 11:06:48 -0700
Message-ID: <CAG6hwVPrbJ1ZQP=UqFd+oqFL8zm+qcRpbAUhrG+6gRe01rejSA@mail.gmail.com> (sfid-20120510_200715_687837_346CC10B)
Subject: Re: [RFC] nl80211: don't require netdev UP for wdev
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for reviewing.

On Wed, May 9, 2012 at 2:15 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2012-04-26 at 15:28 -0700, Thomas Pedersen wrote:
>> It seems as long as we have a netdev, a wdev is available as well.
>> Remove the restriction that netdev must be up before a wdev can be
>> obtained in nl80211, or changing channels in cfg80211.
>>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>>
>> ---
>> Hi list,
>>
>> This was encountered while implementing an interface for setting
>> BSSBasicRateSet in mesh. The wdev->channel is needed in nl80211.c for
>> rate verification, but prior to this patch not available.  This doesn't
>> seem right since the following sequence of commands would fail:
>>
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
>
> Overall, I don't think setting the channel & doing mesh setup separately
> is really a good API.
>
> From mac80211's (and other drivers if they existed) POV the channel
> should be given with the mesh_join command, like for IBSS.
>
> Now, obviously, requiring userspace to do that would be an API change.
> We probably don't want that, so I would suggest to change cfg80211 to
> track the channel and then pass it to join_mesh as one of the mesh
> parameters. This could be made work even when somebody attempts to set
> the channel before the interface is up, but we'd have to be careful
> about interface type changes.

Unfortunately, when __nl80211_set_channel() is called we may or may
not have a wdev, so there is nowhere to store the interface-specific
channel and type.
We could shove these into a cfg80211_registered_device, but now just
"last channel for this wiphy" is tracked, and that doesn't seem to
help your multi-channel operation.

If the above is correct, how about we leave the existing API as-is and
simply extend join_mesh to take a channel attribute?

Also, with IBSS the desired channel is pushed to the driver along with
the setup parameters. What do you think about calling
__nl80211_set_channel() directly instead of relying on the cfg80211
driver to handle this?

> We should do the same for AP mode as well, since the channel really
> becomes relevant only upon start_ap(), before that there's no real
> concept of a channel since you don't use it yet anyway.

Thanks,
Thomas
