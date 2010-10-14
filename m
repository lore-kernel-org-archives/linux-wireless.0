Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0JNHRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 03:17:47 -0400
Subject: Re: [PATCH 4/6] Add a bitrate threshold config hook in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20101013224851.D58252094C@glenhelen.mtv.corp.google.com>
References: <20101013224851.D58252094C@glenhelen.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 09:18:28 +0200
Message-ID: <1287040708.4641.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-13 at 15:17 -0700, Paul Stewart wrote:
> Add a hook in mac80211 to accept bitrate threshold configuration
> calls from nl80211.  This assigns a couple new variables in the
> bss and ifmgd structs.

> @@ -247,6 +249,7 @@ struct ieee80211_bss_conf {
>  	u16 ht_operation_mode;
>  	s32 cqm_rssi_thold;
>  	u32 cqm_rssi_hyst;
> +	u32 cqm_bitrate_thold;

Since there's no way for drivers to utilise this, don't add it in public
API.

johannes

