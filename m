Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:30291 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYCABaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 20:30:05 -0500
Received: by wf-out-1314.google.com with SMTP id 28so4512331wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 29 Feb 2008 17:30:04 -0800 (PST)
Subject: Re: [PATCH 01/13 v2] o11s: (nl80211/cfg80211) support for mesh
	interfaces and mesh paths
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1203955392.13162.111.camel@johannes.berg>
References: <47be7703.20f8720a.1044.6474@mx.google.com>
	 (sfid-20080222_071730_424685_4330467A)  <1203695866.7082.49.camel@johannes.berg>
	 (sfid-20080222_155831_933711_8528D283)  <1203955392.13162.111.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 17:31:49 -0800
Message-Id: <1204335110.7735.30.camel@localhost> (sfid-20080301_013020_806223_0BAACFBD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-02-25 at 17:03 +0100, Johannes Berg wrote:
> Can you do that in both nl80211 and mac80211 for both STAs and paths?
> Look at net/netlink/genetlink.c ctrl_dumpfamily() for an example.

I'm not sure I completely get what changes are necessary.

What I understand is that I should acquire (if idx == 0) and release
(just before returning -ENOENT) the rtnl_lock() from within (mac80211 or
equivalent) dump_station function instead of from nl80211_dump_station.
Is this the whole idea?

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


