Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaA2MIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 07:08:42 -0500
Message-ID: <1390997315.4143.4.camel@jlt4.sipsolutions.net> (sfid-20140129_130845_142778_7A11DB0C)
Subject: Re: [PATCH] mac80211: Fix IBSS join
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 29 Jan 2014 13:08:35 +0100
In-Reply-To: <1390874095-28008-1-git-send-email-sujith@msujith.org>
References: <1390874095-28008-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-28 at 07:24 +0530, Sujith Manoharan wrote:


> -	ieee80211_ibss_disconnect(sdata);
> +	ieee80211_ibss_disconnect(sdata, false);

I'm not sure why you'd want to have 'false' here? If the network is
switching channel, then the old BSS entry is useless, no?

johannes

