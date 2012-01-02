Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55781 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2ABOia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 09:38:30 -0500
Received: by iaeh11 with SMTP id h11so29372127iae.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jan 2012 06:38:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325501581.3643.8.camel@jlt3.sipsolutions.net>
References: <1325162501-7996-1-git-send-email-eliad@wizery.com>
	<1325162501-7996-4-git-send-email-eliad@wizery.com>
	<1325501581.3643.8.camel@jlt3.sipsolutions.net>
Date: Mon, 2 Jan 2012 16:38:30 +0200
Message-ID: <CAB3XZEfQ87gAPPAf4TO6LRbFtBh3YBRR5DO-oM=YB_BPczyCUA@mail.gmail.com> (sfid-20120102_153834_246221_4B1C3E17)
Subject: Re: [PATCH v2 3/3] mac80211: add sta_state callback
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 2, 2012 at 12:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-12-29 at 14:41 +0200, Eliad Peller wrote:
>
> [...]
>
>> +static inline void drv_sta_state(struct ieee80211_local *local,
>> +                              struct ieee80211_sub_if_data *sdata,
>> +                              struct ieee80211_sta *sta,
>> +                              enum ieee80211_sta_state state)
>> +{
>> +     might_sleep();
>> +
>> +     sdata = get_bss_sdata(sdata);
>> +     check_sdata_in_driver(sdata);
>> +
>> +     trace_drv_sta_state(local, sdata, sta, state);
>> +     if (local->ops->sta_state)
>> +             local->ops->sta_state(&local->hw, &sdata->vif, sta,
>> +                                   state);
>> +     trace_drv_return_void(local);
>> +}
>
> Might be worthwhile to pass "sta_info *sta" and add
> WARN_ON(!sta->uploaded)?
>
yeah, i planned sending a patch later on, that will add a new
check_uploaded_sta() function (similar to check_sdata_in_driver()),
and call it in the appropriate callbacks (drv_sta_remove, drv_set_key,
etc.)

>
> I have a more fundamental issue/thought though, but it's hard to put
> into words... let me start from what I thought we might want.
>
> I think with the auth/assoc rework I'm planning, we will want to add the
> station to the driver before auth, in NONE state. To implement that with
> the current state, that means changing all drivers that want the station
> in assoc state only.
>
> So to solve this more cleanly, I thought we could hijack the station
> state callback (this patchset) and call sta_state even when the station
> isn't uploaded yet.
>
does it really make sense to notify the driver about state transitions
of station it doesn't know?

> Basically my idea was that new drivers that use the station state
> callback can add/remove stations based on the state callback.
>
> The mac80211 backward compatibility implementation would take the state
> call and call sta_add() if the station goes into ASSOC state (this
> actually depends on the interface type, but that's easy to do.)
>
> This means we need better error handling for state transitions in a lot
> of cases, but I think that's doable.
>
i guess we should always delete the station on error? otherwise, the
station state becomes unclear.

if sta_state will be allowed to return an error, instead of adding a
new backward compatibility implementation to mac80211 we can just
change all the current drivers to register for sta_state(), and
operate on auth->assoc and assoc->auth transitions instead of
sta_add/sta_remove.

Eliad.
