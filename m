Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaAXJWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 04:22:03 -0500
Message-ID: <1390555312.4257.35.camel@jlt4.sipsolutions.net> (sfid-20140124_102212_842367_2F5AE8DA)
Subject: Re: [PATCH-v2] nl80211: Fix bug in match set count calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Raja Mani <rmani@qti.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luca Coelho <luca@coelho.fi>
Date: Fri, 24 Jan 2014 10:21:52 +0100
In-Reply-To: <1390476858-4833-1-git-send-email-rmani@qti.qualcomm.com>
References: <1390476858-4833-1-git-send-email-rmani@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 17:04 +0530, Raja Mani wrote:
> Match set count is calculated in nl80211_start_sched_scan() by counting
> each attr available in NL80211_ATTR_SCHED_SCAN_MATCH. Some cases, RSSI
> threshold limit NL80211_SCHED_SCAN_MATCH_ATTR_RSSI attr also can come
> from user space along with NL80211_SCHED_SCAN_MATCH_ATTR_SSID attr.
> In such cases, exiting code counts NL80211_SCHED_SCAN_MATCH_ATTR_RSSI
> attr also as one of SSID and leads extra memory allocation for match set
> array (request->match_sets).
> 
> Counting only NL80211_SCHED_SCAN_MATCH_ATTR_RSSI attr will help nl80211 to
> allocate exact memory needed for match set array and also driver can know
> the exact valid SSID available in match set array.

Much better now. I still think you should explain *why* this is a
problem. It's not obvious at first glance that the sched scan match
thing is actually completely stupid, allowing the RSSI attribute in the
nested thing but then only using a single one of it ... Luca, any ideas
about that part? Was something else intended?

johannes

