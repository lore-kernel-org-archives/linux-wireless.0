Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41204 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750737AbcI3H3X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 03:29:23 -0400
Message-ID: <1475220560.17481.7.camel@sipsolutions.net> (sfid-20160930_092927_445991_DD9853EF)
Subject: Re: [PATCH 2/3] mac80211: multicast to unicast conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Sep 2016 09:29:20 +0200
In-Reply-To: <1474821596-12155-3-git-send-email-michael-dev@fami-braun.de> (sfid-20160925_184001_313936_5CD88310)
References: <1474821596-12155-1-git-send-email-michael-dev@fami-braun.de>
         <1474821596-12155-3-git-send-email-michael-dev@fami-braun.de>
         (sfid-20160925_184001_313936_5CD88310)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +static ssize_t ieee80211_if_fmt_unicast(
> +	const struct ieee80211_sub_if_data *sdata, char *buf, int
> buflen)

That's a very ... unusual way to break the lines here - please either
break after the first argument, or before the function name. You should
see lots of examples for both.

However, regardless of that, I don't think that debugfs is an
appropriate way to configure a production option like this.

> +	int unicast;

bool, quite obviously.

> +/* rewrite destination mac address */
> +static int ieee80211_tx_dnat(struct sk_buff *skb, struct sta_info
> *sta)

How is this DNAT?

johannes
