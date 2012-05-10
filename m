Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab2EJH36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 03:29:58 -0400
Message-ID: <1336634995.4334.7.camel@jlt3.sipsolutions.net> (sfid-20120510_093001_410873_9EB26F12)
Subject: Re: [PATCH 5/7] cfg80211: extend get_channel to take wdev argument
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 10 May 2012 09:29:55 +0200
In-Reply-To: <1336632282-2278-6-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
	 <1336632282-2278-6-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy,
> -					       enum nl80211_channel_type *type);
> +						 struct wireless_dev *wdev,
> +						 enum nl80211_channel_type *type);

Hmm. This is mostly used for monitor mode, and there we would have to
return NULL anyway while using multiple channels at the same time. Is it
really worth the complexity?

johannes

