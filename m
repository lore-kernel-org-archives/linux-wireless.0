Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0JAIwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 04:52:41 -0400
Subject: Re: [PATCH v2] mac80211: Add WME information element for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101001084842.13117.16614.stgit@tt-desk>
References: <20101001084842.13117.16614.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 10:52:38 +0200
Message-ID: <1285923158.3739.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 17:48 +0900, Bruno Randolf wrote:
> -			rcu_read_unlock();
> -			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
> -					       supp_rates, GFP_KERNEL);
> +			sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
> +					mgmt->sa, supp_rates, GFP_KERNEL);

Guess you were a bit too quick -- GFP_ATOMIC, but with that change you
get

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

