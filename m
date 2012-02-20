Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36089 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab2BTIxZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 03:53:25 -0500
Received: by obcva7 with SMTP id va7so6899886obc.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2012 00:53:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329712532-1928-2-git-send-email-mohammed@qca.qualcomm.com>
References: <1329712532-1928-1-git-send-email-mohammed@qca.qualcomm.com>
	<1329712532-1928-2-git-send-email-mohammed@qca.qualcomm.com>
Date: Mon, 20 Feb 2012 10:53:24 +0200
Message-ID: <CAB3XZEe2yqf1Frui3DvpHBG_VopkHydoJSXr2xqkBuUfpx8ZjQ@mail.gmail.com> (sfid-20120220_095328_789269_6DDB99A7)
Subject: Re: [PATCH 2/2] mac80211: Fix a warning on changing to monitor mode
 from STA
From: Eliad Peller <eliad@wizery.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 20, 2012 at 6:35 AM, Mohammed Shafi Shajakhan
<mohammed@qca.qualcomm.com> wrote:
>
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> nothing needs to be done for monitor mode on calling
> ieee80211_bss_info_change_notify -> drv_bss_info_changed with the change
> flag 'BSS_CHANGED_IDLE'. 'wl1271' seems to use BSS_CHANGED_IDLE only for
> STA and IBSS mode. further the non-idle state of the monitor mode is
> taken care by the 'count' variable which counts non-idle interfaces.
> ieee80211_idle_off(local, "in use") will be called.
> this fixes the following WARNING when we have initially STA mode
> (network manager running) and not associated, and change it to monitor
> mode with network manager disabled and bringing up the monitor mode.
> this changes the idle state from 'true' (STA unassociated) to 'false'
> (MONITOR mode)
> exposed by the commit 405385f8ce7a2ed8f82e216d88b5282142e1288b
> "mac80211: set bss_conf.idle when vif is connected"
>
>        WARNING: net/mac80211/main.c:212
>        ieee80211_bss_info_change_notify+0x1cf/0x330 [mac80211]()
>        Hardware name: 64756D6
>        Pid: 3835, comm: ifconfig Tainted: G           O
>        3.3.0-rc3-wl #9
>        Call Trace:
>          [<c0133b02>] warn_slowpath_common+0x72/0xa0
>          [<fc8e8c3f>] ?
>          ieee80211_bss_info_change_notify+0x1cf/0x330 [mac80211]
>          [<fc8e8c3f>] ?
>          ieee80211_bss_info_change_notify+0x1cf/0x330 [mac80211]
>          [<c0133b52>] warn_slowpath_null+0x22/0x30
>          [<fc8e8c3f>]
>          ieee80211_bss_info_change_notify+0x1cf/0x330 [mac80211]
>          [<fc8f9de3>] __ieee80211_recalc_idle+0x113/0x430
>          [mac80211]
>          [<fc8fabc6>] ieee80211_do_open+0x156/0x7e0 [mac80211]
>          [<fc8f8a25>] ?
>          ieee80211_check_concurrent_iface+0x25/0x180 [mac80211]
>          [<c015dd9f>] ? raw_notifier_call_chain+0x1f/0x30
>          [<fc8fb290>] ieee80211_open+0x40/0x80 [mac80211]
>          [<c05894f6>] __dev_open+0x96/0xe0
>          [<c068fba5>] ? _raw_spin_unlock_bh+0x35/0x40
>          [<c05881d9>] __dev_change_flags+0x109/0x170
>          [<c0589423>] dev_change_flags+0x23/0x60
>          [<c05f3770>] devinet_ioctl+0x6a0/0x770
>
>  ieee80211 phy0: device no longer idle - in use
>
> Cc: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>  net/mac80211/iface.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 6b3cd65..6b2221b 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -1342,6 +1342,8 @@ u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
>                hw_roc = true;
>
>        list_for_each_entry(sdata, &local->interfaces, list) {
> +               if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
> +                       continue;
>                if (sdata->old_idle == sdata->vif.bss_conf.idle)
>                        continue;
>                if (!ieee80211_sdata_running(sdata))
> --

thanks, i missed it.
i think we should skip NL80211_IFTYPE_AP_VLAN as well?

Eliad.
