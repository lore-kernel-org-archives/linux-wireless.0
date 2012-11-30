Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2K3LlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 06:41:06 -0500
Message-ID: <1354275686.10035.0.camel@jlt4.sipsolutions.net> (sfid-20121130_124110_778829_051037E4)
Subject: Re: [PATCH] mac80211: add debugfs file for mic failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Nov 2012 12:41:26 +0100
In-Reply-To: <50B86A28.9090509@posedge.com>
References: <50B86A28.9090509@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-30 at 13:41 +0530, Saravana wrote:
> Add a debugfs file showing the number of dropped
> rx packet due to mic failures. currently the
> number of rx packet dropped is counted in general and
> not with respect to a specific reason. This patch
> counts the number of packet drop due to mic failure.

It would make more sense to count them per *key*, not per station, and
counting them per station like this can crash anyway if sta is NULL.

johannes

