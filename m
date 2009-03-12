Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58675 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934AbZCLWpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:45:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: remove ieee80211_num_regular_queues
Date: Thu, 12 Mar 2009 23:44:03 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1236852956.4175.19.camel@johannes.local>
In-Reply-To: <1236852956.4175.19.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903122344.04238.mb@bu3sch.de> (sfid-20090312_234533_983816_00A6E6E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 March 2009 11:15:56 Johannes Berg wrote:
>  	/* receiver and we are QoS enabled, use a QoS type frame */
> -	if (sta_flags & WLAN_STA_WME &&
> -	    ieee80211_num_regular_queues(&local->hw) >= 4) {
> +	if (sta_flags & WLAN_STA_WME && local->hw.queues >= 4) {

Could we add a few parenthesis while we're at it?
The code is correct, but it took me some time to realize that. ;)

-- 
Greetings, Michael.
