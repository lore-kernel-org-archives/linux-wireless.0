Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33180 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967592AbaLLMj1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:39:27 -0500
Message-ID: <1418387963.2470.32.camel@sipsolutions.net> (sfid-20141212_133929_614163_E7799C12)
Subject: Re: [PATCH v8 2/4] cfg80211: allow wiphy specific regdomain
 management
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Jonathan Doron <jond@wizery.com>
Date: Fri, 12 Dec 2014 13:39:23 +0100
In-Reply-To: <1417622897-30768-2-git-send-email-arik@wizery.com> (sfid-20141203_170818_099557_FFECF0CB)
References: <1417622897-30768-1-git-send-email-arik@wizery.com>
	 <1417622897-30768-2-git-send-email-arik@wizery.com>
	 (sfid-20141203_170818_099557_FFECF0CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-03 at 18:08 +0200, Arik Nemtsov wrote:

> +void nl80211_send_reg_change_event(struct regulatory_request *request)
> +{
> +	nl80211_common_reg_change_event(NL80211_CMD_REG_CHANGE, request);
> +}
> +
> +void nl80211_send_wiphy_reg_change_event(struct regulatory_request *request)
> +{
> +	nl80211_common_reg_change_event(NL80211_CMD_WIPHY_REG_CHANGE, request);
> +}

These are trivial wrappers, I'd make them inlines.

johannes

