Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:41091 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbXHREAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 00:00:19 -0400
Date: Fri, 17 Aug 2007 20:59:09 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/20] mac80211: kill key_mgmt variable, use privacy_enabled
Message-ID: <20070818035909.GE1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net> <20070815145047.834125000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070815145047.834125000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2007 at 04:49:34PM +0200, Johannes Berg wrote:

> The key_mgmt variable for STA interfaces doesn't seem well-defined
> nor do we actually use the values other than "NONE", so change it to
> be named better.

Most drivers should not need key_mgmt configuration. The only exception
that I'm aware of is firmware designs that insist on generating WPA/RSN
IE internally. None of them are likely to be using mac80211, though.

> +			 * What are the semantics in wext supposed to be?
> +			 *
> +			 * Don't bother figuring that out... It's wext after
> +			 * all so figuring it out will most likely require a
> +			 * moderate amount of clairvoyance.

Isn't this a bit unnecessary?

> +			sdata->u.sta.privacy_enabled = !!data->value;

This looks a bit odd, though, taken into account that this is coming
from IW_AUTH_KEY_MGMT and not IW_AUTH_PRIVACY_INVOKED.. It would
probably be better to just remove all the crab from here can ignore the
IW_AUTH_KEY_MGMT value in mac80211. The only place that actually used it
in the client code (mixed cell configuration) had already been broken,
so this could all be just removed completely unless someone has plans on
fixing privacy mismatch detection.

-- 
Jouni Malinen                                            PGP id EFC895FA
