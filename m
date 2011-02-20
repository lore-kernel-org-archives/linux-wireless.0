Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37144 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1BTAhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 19:37:03 -0500
Received: by bwz15 with SMTP id 15so150702bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 16:37:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298064074-8108-1-git-send-email-linville@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
	<1298064074-8108-1-git-send-email-linville@tuxdriver.com>
Date: Sat, 19 Feb 2011 16:37:00 -0800
Message-ID: <AANLkTinTcdbjSYvt7Z_yOe_8kGZnyp2MBXZYYJ9zGB_D@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight bufferbloat
From: Nathaniel Smith <njs@pobox.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	johannes@sipsolutions.net, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually, a few more comments just occurred to me...

On Fri, Feb 18, 2011 at 1:21 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Johannes' comment about tx status reporting being unreliable (and what
> he was really saying) finally sunk-in.  So, this version uses
> skb->destructor to track in-flight fragments.  That should handle
> fragments that get silently dropped in the driver for whatever reason
> without leaking queue capacity.  Correct me if I'm wrong!

Should we be somehow filtering out and ignoring the packets that get
dropped, when we're calculating the average packet transmission rate?
Presumably they're getting dropped almost instantly, so they don't
really take up queue space and they have abnormally fast transmission
times, which will tend to cause us to overestimate max_enqueued? They
should be rare, though, at least. (And presumably we *should* include
packets that get dropped because their retry timer ran out, since they
were sitting in the queue for that long.) Possibly we should just
ignore any packet that was handled in less than, oh, say, a few
microseconds?

Alternatively, if we aren't worried about those packets, then is there
any reason this patch should be mac80211 specific?

> +static void ieee80211_tx_skb_free(struct sk_buff *skb)
> +{
> +       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
> +       struct ieee80211_local *local = sdata->local;
> +       int q = skb_get_queue_mapping(skb);
> +
> +       /* decrement enqueued count */
> +       atomic_dec(&sdata->qdata[q].enqueued);
> +
> +       /* if queue stopped, wake it */
> +       if (ieee80211_queue_stopped(&local->hw, q))
> +               ieee80211_wake_queue(&local->hw, q);
> +}

I think you need to check that .enqueued is < max_enqueued here,
instead of waking the queue unconditionally.

Suppose the data rate drops while there's a steady flow -- our
max_enqueued value will drop below the current queue size, but because
we wake the queue unconditionally after each packet goes out, and then
only stop it again after we've queued at least one new packet, we
might get 'stuck' with an over-large queue.

-- Nathaniel
