Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2FTI1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:27:04 -0400
Message-ID: <1340180819.4655.27.camel@jlt3.sipsolutions.net> (sfid-20120620_102713_978774_EDA5E26F)
Subject: Re: [PATCH v3] nl80211: specify RSSI threshold in scheduled scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 10:26:59 +0200
In-Reply-To: <1340127208-3266-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1340127208-3266-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 10:33 -0700, Thomas Pedersen wrote:
> Support configuring an RSSI threshold in dBm (s32) when requesting
> scheduled scan, below which a BSS won't be reported by the cfg80211
> driver.

> @@ -4241,7 +4242,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
>  		nla_for_each_nested(attr,
>  				    info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
>  				    tmp) {
> -			struct nlattr *ssid;
> +			struct nlattr *ssid, *rssi;
>  
>  			nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
>  				  nla_data(attr), nla_len(attr),
> @@ -4257,6 +4258,9 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
>  				request->match_sets[i].ssid.ssid_len =
>  					nla_len(ssid);
>  			}
> +			rssi = tb[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI];
> +			if (rssi)
> +				request->rssi_thold = nla_get_u32(rssi);

I was going to apply this, but then I realized ... if userspace doesn't
set the value then the default is 0 which is a bit useless, better set
to a very small negative value or something, right?

johannes

