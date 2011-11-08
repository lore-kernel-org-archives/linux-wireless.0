Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48499 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1KHPNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 10:13:40 -0500
Received: by iage36 with SMTP id e36so621573iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 07:13:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320762970-6860-1-git-send-email-arik@wizery.com>
References: <1320762970-6860-1-git-send-email-arik@wizery.com>
Date: Tue, 8 Nov 2011 17:13:39 +0200
Message-ID: <CAB3XZEcm_4kppAkQbp+HrBAgPSY5W1jiJ5qst2V5E+4x5TMHoA@mail.gmail.com> (sfid-20111108_161343_243531_8926765C)
Subject: Re: [PATCH v3 1/2] wl12xx: configure probe-resp template according to notification
From: Eliad Peller <eliad@wizery.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 8, 2011 at 4:36 PM, Arik Nemtsov <arik@wizery.com> wrote:
> When operating in AP-mode, replace our probe-response template when a
> notification is recieved from mac80211. We preserve the "legacy" way of
> configuring a probe-response according to beacon for IBSS mode and for
> versions of hostapd that do not support this feature.
>
> Signed-off-by: Guy Eilam <guy@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
[...]
> +static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl, u32 rates)
> +{
> +       struct sk_buff *skb;
> +       int ret;
> +
> +       skb = ieee80211_proberesp_get(wl->hw, wl->vif);
> +       if (!skb)
> +               return -EINVAL;
> +
> +       ret = wl1271_cmd_template_set(wl,
> +                                     CMD_TEMPL_AP_PROBE_RESPONSE,
> +                                     skb->data,
> +                                     skb->len, 0,
> +                                     rates);
> +
> +       dev_kfree_skb(skb);
> +       return ret;
> +}

add a check for max template size?

Eliad.
