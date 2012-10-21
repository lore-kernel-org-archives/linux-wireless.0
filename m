Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48886 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2JUIxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 04:53:48 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so1611445oag.19
        for <linux-wireless@vger.kernel.org>; Sun, 21 Oct 2012 01:53:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1350654441-6761-1-git-send-email-johannes@sipsolutions.net>
References: <1350654441-6761-1-git-send-email-johannes@sipsolutions.net>
Date: Sun, 21 Oct 2012 10:53:48 +0200
Message-ID: <CAB3XZEc0PbzcCFfkabEg9UfwnCizKGvKEhZ_iYfMA6QC=xcxFw@mail.gmail.com> (sfid-20121021_105358_263936_6DCC6F62)
Subject: Re: [RFC] mac80211: add explicit AP/GO driver operations
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ilan.peer@intel.com,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 19, 2012 at 3:47 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Depending on the driver, a lot of setup may be
> necessary to start operating as an AP, some of
> which may fail. To make it easier to handle,
> add explicit AP start/stop operations.
>
> ...
>
> This would make the code in iwlwifi a lot simpler
> as having bss_info_change do everything depending
> on whether the beacon was enabled/disabled etc.
> is tricky to get right, the explicit operations
> make it easier.
>
is it really different from acting upon BSS_CHANGED_BEACON_ENABLED
(when vif == ap)?

>         ieee80211_bss_info_change_notify(sdata, changed);
>
> +       err = drv_start_ap(sdata->local, sdata);
> +       if (err) {
> +               old = rtnl_dereference(sdata->u.ap.beacon);
> +               if (old)
> +                       kfree_rcu(old, rcu_head);
> +               RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
> +               return err;

they'll probably be mutually exclusive, but i think you should still
notify BSS_CHANGED_BEACON_ENABLED after removing the beacon (or more
easily, call ieee80211_bss_info_change_notify only after this block).

>
> +DEFINE_EVENT(local_sdata_evt, drv_start_ap,
> +       TP_PROTO(struct ieee80211_local *local,
> +                struct ieee80211_sub_if_data *sdata),
> +       TP_ARGS(local, sdata)
> +);

adding traces for ssid and beacon_int might be nice :)


what about other direct notification of BSS_CHANGED_BEACON_ENABLED
(like in offchannel and ieee80211_do_stop)? should we call
start_ap/stop_ap there as well?

Eliad.
