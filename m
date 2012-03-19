Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60976 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab2CSUUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 16:20:05 -0400
Received: by wejx9 with SMTP id x9so6180754wej.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 13:20:04 -0700 (PDT)
References: <4F673690.40302@raritan.com>
In-Reply-To: <4F673690.40302@raritan.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <9D564AC6-306B-4E75-A235-AC3DDF54F7D3@gmail.com> (sfid-20120319_212010_761508_E33818A0)
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	RT2x00 Users <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] mac80211: when receiving DTIM disable power-save mode only if it was enabled
Date: Mon, 19 Mar 2012 21:20:02 +0100
To: Ronald Wahl <ronald.wahl@raritan.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 mrt. 2012, at 14:37, Ronald Wahl <ronald.wahl@raritan.com> wrote:

> When receiving DTIM we currently disable power save mode in the
> hardware unconditionally, i.e. also when the hardware was not sleeping.
> This causes trouble with at least one wireless chipset (Ralink RT3572).
> When the hardware is not sleeping and we send a wakeup command (e.g.
> this happens after a scan) then a significant decrease of the link
> quality or a disconnect may occur.
> Disabling power save mode only when it was enabled prevents this issue.
> 
> Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>

Reviewed-by: Gertjan van Wingerde <gwingerde@gmail.com>

Obviously rt2x00 is the only one that seems to need this, but simply replicating maintaining the PS state inside rt2x00 while mac80211 already does this doesn't seem right to me.

> ---
> Index: linux/net/mac80211/mlme.c
> ===================================================================
> --- linux/net/mac80211/mlme.c    (revision 213137)
> +++ linux/net/mac80211/mlme.c    (working copy)
> @@ -1922,9 +1922,11 @@
>    if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
>        if (directed_tim) {
>            if (local->hw.conf.dynamic_ps_timeout > 0) {
> -                local->hw.conf.flags &= ~IEEE80211_CONF_PS;
> -                ieee80211_hw_config(local,
> -                            IEEE80211_CONF_CHANGE_PS);
> +                if (local->hw.conf.flags & IEEE80211_CONF_PS) {
> +                    local->hw.conf.flags &= ~IEEE80211_CONF_PS;
> +                    ieee80211_hw_config(local,
> +                                IEEE80211_CONF_CHANGE_PS);
> +                }
>                ieee80211_send_nullfunc(local, sdata, 0);
>            } else {
>                local->pspolling = true;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
