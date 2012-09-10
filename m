Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2IJL1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 07:27:49 -0400
Message-ID: <1347276502.4272.22.camel@jlt4.sipsolutions.net> (sfid-20120910_132752_605482_A5A8F3AB)
Subject: Re: [RFC] cfg80211/nl80211: Notify connection request failure in AP
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 10 Sep 2012 13:28:22 +0200
In-Reply-To: <1347274408-11949-1-git-send-email-c_ppitch@qca.qualcomm.com>
References: <1347274408-11949-1-git-send-email-c_ppitch@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-10 at 16:23 +0530, Pandiyarajan Pitchaimuthu wrote:
> In AP mode, when a station requests connection to an AP and if the
> request is failed for particular reason, userspace is notified about the
> failure through NL80211_CMD_CONN_FAILED command. Reason for the failure
> is sent through the attribute NL80211_ATTR_CONN_FAILED_REASON.

Why would userspace care?

> +/* AP mode - sta's connection request failed reasons */
> +enum nl80211_connect_failed_reason {
> +	NL80211_CONN_FAIL_MAX_CLIENTS		= 1,
> +	NL80211_CONN_FAIL_BLOCKED_CLIENT	= 2,
> +};

Why number explicitly?

> + * Whenever a station tries to connect to an AP and if the station
> + * could not connect to the AP for some reason, this function is called.

It's not really "for some reason", it's "because the AP rejected it for
some reason"... You're not handling other cases anyway.

johannes

