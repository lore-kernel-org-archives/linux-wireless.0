Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2FDGRb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 02:17:31 -0400
Message-ID: <1338790650.4512.4.camel@jlt3.sipsolutions.net> (sfid-20120604_081734_307935_E64DF6F3)
Subject: Re: [PATCH] mac80211: fix non RCU-safe sta_list manipulation
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 04 Jun 2012 08:17:30 +0200
In-Reply-To: <1338755552-13349-1-git-send-email-arik@wizery.com> (sfid-20120603_223307_775262_32FB5334)
References: <1338755552-13349-1-git-send-email-arik@wizery.com>
	 (sfid-20120603_223307_775262_32FB5334)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-06-03 at 23:32 +0300, Arik Nemtsov wrote:
> sta_info_cleanup locks the sta_list using rcu_read_lock however
> the delete operation isn't rcu safe. A race between sta_info_cleanup
> timer being called and a STA being removed can occur which leads
> to a panic while traversing sta_list. Fix this by switching to the
> RCU-safe versions.

Good catch!

johannes


