Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab2EaLmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 07:42:50 -0400
Message-ID: <1338464568.9102.2.camel@jlt3.sipsolutions.net> (sfid-20120531_134253_379587_D782AEA6)
Subject: Re: [PATCH v2] mac80211: add command to get current rssi
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 31 May 2012 13:42:48 +0200
In-Reply-To: <1338463991-7741-1-git-send-email-victorg@ti.com>
References: <1338463991-7741-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-31 at 14:33 +0300, Victor Goldenshtein wrote:

> -		sinfo->signal = (s8)sta->last_signal;
> +		if (!local->ops->get_rssi ||
> +			drv_get_rssi(local, sdata, &sta->sta, &sinfo->signal))
> +			sinfo->signal = (s8)sta->last_signal;

Please fix the indentation here

johannes

