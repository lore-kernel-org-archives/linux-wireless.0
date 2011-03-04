Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab1CDLaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 06:30:11 -0500
Subject: Re: [PATCH 1/7] mac80211: Support RSN information element on mesh
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1299208307-9428-2-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
	 <1299208307-9428-2-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 12:30:05 +0100
Message-ID: <1299238205.4348.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:

> +++ b/include/net/cfg80211.h
> @@ -656,6 +656,8 @@ struct mesh_config {
>   * @path_metric: which metric to use
>   * @vendor_ie: vendor information elements (optional)
>   * @vendor_ie_len: length of vendor information elements
> + * @rsn_ie: robust secure network information elements (for SAE)
> + * @rsn_ie_len: length of rsn_ie

Is this really useful over just putting it into the vendor IE we already
have? We already have code to split IEs properly (see ieee80211_ie_split
etc in mac80211), so maybe there's no reason to add more API?

johannes

