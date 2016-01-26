Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38525 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965057AbcAZKf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 05:35:28 -0500
Message-ID: <1453804525.2759.12.camel@sipsolutions.net> (sfid-20160126_113538_371597_145241F5)
Subject: Re: [PATCH] mac80211: Requeue work after scan complete for all VIF
 types.
From: Johannes Berg <johannes@sipsolutions.net>
To: Sachin Kulkarni <Sachin.Kulkarni@imgtec.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 26 Jan 2016 11:35:25 +0100
In-Reply-To: <1452589219-29164-1-git-send-email-Sachin.Kulkarni@imgtec.com>
References: <1452589219-29164-1-git-send-email-Sachin.Kulkarni@imgtec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-12 at 14:30 +0530, Sachin Kulkarni wrote:
> From: Sachin Kulkarni <Sachin.Kulkarni@imgtec.com>
> 
> During a sw scan ieee80211_iface_work ignores work items for all
> vifs. 
> However after the scan complete work is requeued only for STA, ADHOC 
> and MESH iftypes.
> 
> This occasionally results in event processing getting delayed/not 
> processed for iftype AP when it coexists with a STA. This can result 
> in data halt and eventually disconnection on the AP interface.
> 
Applied.

I added a Cc stable tag - I don't think the commit message (hw vs. sw
scan) matters that much.

johannes
