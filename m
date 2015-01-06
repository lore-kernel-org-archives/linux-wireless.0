Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58713 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266AbbAFKzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:55:01 -0500
Message-ID: <1420541693.1966.17.camel@sipsolutions.net> (sfid-20150106_115517_768698_98A98091)
Subject: Re: [PATCH 1/2] cfg80211: introduce sync regdom set API for
 self-managed
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 06 Jan 2015 11:54:53 +0100
In-Reply-To: <1420112563-3981-1-git-send-email-arik@wizery.com> (sfid-20150101_124249_166524_7BBD3A2A)
References: <1420112563-3981-1-git-send-email-arik@wizery.com>
	 (sfid-20150101_124249_166524_7BBD3A2A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-01-01 at 13:42 +0200, Arik Nemtsov wrote:
> A self-managed device will sometimes need to set its regdomain synchronously.
> Notably it should be set before usermode has a chance to query it. Expose
> a new API to accomplish this which requires the RTNL.

> +	ret = regulatory_set_wiphy_regd(wiphy, rd);
> +	if (ret)
> +		return ret;

It seems to me you should refactor that and avoid scheduling the work
struct when you're going to run the necessary work below by hand.

johannes

