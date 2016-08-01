Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34160 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbcHAMXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 08:23:31 -0400
Message-ID: <1470054183.17912.7.camel@sipsolutions.net> (sfid-20160801_142338_905480_3D3E6B84)
Subject: Re: [PATCH 3/3 v6] mac80211: Refactor ieee80211_iface_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Briskin <br.shurik@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 01 Aug 2016 14:23:03 +0200
In-Reply-To: <1468693140-19483-3-git-send-email-br.shurik@gmail.com> (sfid-20160716_201952_280978_D61E5413)
References: <1468693140-19483-1-git-send-email-br.shurik@gmail.com>
	 <1468693140-19483-3-git-send-email-br.shurik@gmail.com>
	 (sfid-20160716_201952_280978_D61E5413)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +		if (ieee80211_iface_work_handle_pkt_type(skb, sdata) &&
> +		    ieee80211_iface_work_handle_frame_control(skb, sdata)) {
> +			ieee80211_iface_work_handle_vif_type(skb, sdata);
>  		}
> 
This ends up being pretty strange IMHO, using boolean short-circuit
evaluation to avoid doing the next thing...

Not sure how to better do this though.

(You also don't need braces here for a single-statement if branch
contents)

johannes
