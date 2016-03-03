Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56557 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbcCCP00 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:26:26 -0500
Message-ID: <1457018779.2044.22.camel@sipsolutions.net> (sfid-20160303_162633_992949_3F95E37C)
Subject: Re: [PATCH 1/2] rhashtable: accept GFP flags in rhashtable_walk_init
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
	netdev@vger.kernel.org
Date: Thu, 03 Mar 2016 16:26:19 +0100
In-Reply-To: <1456931360-2846-1-git-send-email-me@bobcopeland.com> (sfid-20160302_160933_050886_E6CBBDD5)
References: <1456931360-2846-1-git-send-email-me@bobcopeland.com>
	 (sfid-20160302_160933_050886_E6CBBDD5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-02 at 10:09 -0500, Bob Copeland wrote:
> In certain cases, the 802.11 mesh pathtable code wants to
> iterate over all of the entries in the forwarding table from
> the receive path, which is inside an RCU read-side critical
> section.  Enable walks inside atomic sections by allowing
> GFP_ATOMIC allocations for the walker state.
> 
> Change all existing callsites to pass in GFP_KERNEL.

Applied both. You missed 3 callsites, I've fixed those. I hope I got
them all :)

johannes
