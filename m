Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32945 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbbBWPhb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 10:37:31 -0500
Message-ID: <1424705846.3075.3.camel@sipsolutions.net> (sfid-20150223_163834_266857_D41884D0)
Subject: Re: [PATCH 1/2] cfg80211: Allow NL80211_ATTR_IFINDEX to be added to
 vendor events
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Ahmad Kholaif <akholaif@qca.qualcomm.com>
Date: Mon, 23 Feb 2015 16:37:26 +0100
In-Reply-To: <1424442925-10778-1-git-send-email-jouni@qca.qualcomm.com>
References: <1424442925-10778-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In addition to what Arend said,


> @@ -4263,7 +4263,8 @@ struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
>  					   enum nl80211_commands cmd,
>  					   enum nl80211_attrs attr,
>  					   int vendor_event_idx,
> -					   int approxlen, gfp_t gfp);
> +					   int approxlen, gfp_t gfp,
> +					   struct wireless_dev *wdev);

This is really strange. IMHO the wdev should be the second argument -
certainly usually gfp is the last one so it shouldn't be after that.

> +/**
> + * cfg80211_vendor_event_alloc_ext - allocate vendor-specific event skb
> + * @wiphy: the wiphy
> + * @event_idx: index of the vendor event in the wiphy's vendor_events
> + * @approxlen: an upper bound of the length of the data that will
> + *	be put into the skb
> + * @gfp: allocation flags
> + * @wdev: the wireless device
> + *
> + * This function allocates and pre-fills an skb for an event on the
> + * vendor-specific multicast group. This is otherwise identical to
> + * cfg80211_vendor_event_alloc(), but ifindex of the specified wireless device
> + * is added to the event message before the vendor data attribute.
> + *
> + * When done filling the skb, call cfg80211_vendor_event() with the
> + * skb to send the event.
> + *
> + * Return: An allocated and pre-filled skb. %NULL if any errors happen.
> + */
> +static inline struct sk_buff *
> +cfg80211_vendor_event_alloc_ext(struct wiphy *wiphy, int approxlen,
> +				int event_idx, gfp_t gfp,
> +				struct wireless_dev *wdev)
> +{
> +	return __cfg80211_alloc_event_skb(wiphy, NL80211_CMD_VENDOR,
> +					  NL80211_ATTR_VENDOR_DATA,
> +					  event_idx, approxlen, gfp, wdev);
>  }

This doesn't seem necessary, why not just update the original function
to add and document the new optional argument?

[however, in the unlikely even that you can convince me otherwise we may
have to add this to the documentation?]

johannes

