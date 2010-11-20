Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:57459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab0KTTdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 14:33:53 -0500
Received: from kpbe15.cbf.corp.google.com (kpbe15.cbf.corp.google.com [172.25.105.79])
	by smtp-out.google.com with ESMTP id oAKJXpJl019373
	for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 11:33:52 -0800
Received: from iwn5 (iwn5.prod.google.com [10.241.68.69])
	by kpbe15.cbf.corp.google.com with ESMTP id oAKJXoxJ023664
	for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 11:33:50 -0800
Received: by iwn5 with SMTP id 5so1425068iwn.32
        for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 11:33:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290218069-85434-1-git-send-email-nbd@openwrt.org>
References: <1290218069-85434-1-git-send-email-nbd@openwrt.org>
Date: Sat, 20 Nov 2010 11:33:49 -0800
Message-ID: <AANLkTi=3dgOAgYy7W42pU+sGwYswx0kJVD-Wbcyy_Tom@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mac80211: use nullfunc instead of probe request
 for connection monitoring
From: Paul Stewart <pstew@google.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A couple of issues here, I think.

On Fri, Nov 19, 2010 at 5:54 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
[...]
> +void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
> +                            struct ieee80211_hdr *hdr)
> +{
> +       if (!ieee80211_is_data(hdr->frame_control) &&
> +           !ieee80211_is_nullfunc(hdr->frame_control))
> +           return;
> +
> +       ieee80211_sta_reset_conn_monitor(sdata);
> +
> +       if (ieee80211_is_nullfunc(hdr->frame_control)) {

Could you also add a "&& sdata->u.mgd.probe_send_count = 0" condition
here, or the BEACON/CONNECTION poll test to reduce the number of times
we queue work here?  Or should this work be done on every ACKed
nullfunc?

> +               sdata->u.mgd.probe_send_count = 0;
> +               ieee80211_queue_work(&sdata->local->hw, &sdata->work);
> +       }
> +}
> +
>  static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
>  {
>        struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> @@ -1882,6 +1916,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
>            ifmgd->associated) {
>                u8 bssid[ETH_ALEN];
>
> +               /* ACK received for nullfunc probing frame */
> +               if (!ifmgd->probe_send_count)
> +                       ieee80211_reset_ap_probe(sdata);
> +

Yeah, but then it looks like we'd end up falling through to the
"ifmgd->probe_send_count < IEEE80211_MAX_PROBE_TRIES" case later in
this block, and send another probe!  Not good.

>                memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
>                if (time_is_after_jiffies(ifmgd->probe_timeout))
>                        run_again(ifmgd, ifmgd->probe_timeout);

--
Paul
