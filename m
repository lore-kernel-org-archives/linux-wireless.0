Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab3KYQf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:35:56 -0500
Message-ID: <1385397353.4443.51.camel@jlt4.sipsolutions.net> (sfid-20131125_173558_507274_A8CA3823)
Subject: Re: [PATCH 2/2] mac80211: Add support for QoS mapping
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 17:35:53 +0100
In-Reply-To: <20131120102922.GA26188@jouni.qca.qualcomm.com>
References: <20131120102922.GA26188@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-20 at 12:29 +0200, Jouni Malinen wrote:

> +++ b/net/mac80211/iface.c
> @@ -636,6 +636,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
>  		ieee80211_set_wmm_default(sdata, true);
>  	}
>  
> +	sdata->qos_map.valid = false;

This isn't really needed for the first ifup (everything will be zero)
and seems insufficient for any later changes since iftype can change and
we should probably clear this on disassoc etc.

Might be better to handle that in cfg80211 to make it consistent, but
then you don't really need to set valid to false at all (never mind the
fact that I think valid should just go away :) )

johannes

