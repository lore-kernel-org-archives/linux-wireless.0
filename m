Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50757 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617Ab2C2UJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 16:09:12 -0400
Received: by obbeh20 with SMTP id eh20so3278941obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2012 13:09:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120328091811.108837459@sipsolutions.net>
References: <20120328091346.442543219@sipsolutions.net>
	<20120328091811.108837459@sipsolutions.net>
Date: Thu, 29 Mar 2012 22:09:11 +0200
Message-ID: <CAB3XZEdx6=58pyiEFWAiLGvtJ9eSTacyKD3Y-jKaR-7iDrF3zg@mail.gmail.com> (sfid-20120329_220917_058578_E9FBE1C9)
Subject: Re: [RFC 1/2] mac80211: add explicit monitor interface if needed
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 28, 2012 at 11:13 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The queue mapping redesign that I'm planning to do
> will break pure injection unless we handle monitor
> interfaces explicitly. One possible option would
> be to have the driver tell mac80211 about monitor
> mode queues etc., but that would duplicate the API
> since we already need to have queue assignments
> handled per virtual interface.
>
> So in order to solve this, have a virtual monitor
> interface that is added whenever all active vifs
> are monitors. We could also use the state of one
> of the monitor interfaces, but managing that would
> be complicated, so allocate separate state.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> +static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
> +{
> +       struct ieee80211_sub_if_data *sdata;
> +
> +       if (!(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))
> +               return;
> +
> +       sdata = rtnl_dereference(local->monitor_sdata);
> +
> +       if (WARN_ON(!sdata))
> +               return;
> +
...

> @@ -280,6 +339,8 @@ static int ieee80211_do_open(struct net_
>                break;
>        default:
>                if (coming_up) {
> +                       ieee80211_del_virtual_monitor(local);
> +

i think this will always trigger the warning?

> @@ -98,8 +98,7 @@ static inline int drv_add_interface(stru
>
>        might_sleep();
>
> -       if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
> -                   sdata->vif.type == NL80211_IFTYPE_MONITOR))
> +       if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
>                return -EINVAL;
>
maybe check for IEEE80211_HW_WANT_MONITOR_VIF instead?

Eliad.
