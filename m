Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39016 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357Ab2ECTkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:40:11 -0400
Message-ID: <1336074010.5167.19.camel@jlt3.sipsolutions.net> (sfid-20120503_214015_074097_4CD79259)
Subject: Re: [PATCH v2 3/4] mac80211: Allow nonHT/HT peering in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Date: Thu, 03 May 2012 21:40:10 +0200
In-Reply-To: <1335820832-18887-3-git-send-email-ashok@cozybit.com> (sfid-20120430_232129_619325_DD1BD59B)
References: <1335820832-18887-1-git-send-email-ashok@cozybit.com>
	 <1335820832-18887-3-git-send-email-ashok@cozybit.com>
	 (sfid-20120430_232129_619325_DD1BD59B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-30 at 14:20 -0700, Ashok Nagarajan wrote:

> -	    (local->_oper_channel_type !=
> -	     ieee80211_ht_oper_to_channel_type(ie->ht_operation)))
> +	    local->_oper_channel_type > NL80211_CHAN_HT20 &&
> +	    sta_channel_type > NL80211_CHAN_HT20 &&
> +	    local->_oper_channel_type != sta_channel_type)

I don't think you should use > operators since we may later have to add
other channel types like 5 and 10 MHz.

johannes

