Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44209 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbbJPMGk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 08:06:40 -0400
Message-ID: <1444997197.2370.22.camel@sipsolutions.net> (sfid-20151016_140643_692134_D9BE9EDA)
Subject: Re: [RFC PATCH 1/2] cfg80211: Add support for ITS-G5 band (5.9 GHz)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
Cc: sojkam1@fel.cvut.cz, linux-wireless@vger.kernel.org,
	bernd.lehmann@volkswagen.de, jan-niklas.meier@volkswagen.de,
	s.sander@nordsys.de
Date: Fri, 16 Oct 2015 14:06:37 +0200
In-Reply-To: <1444994885-21825-1-git-send-email-kaisrja1@fel.cvut.cz> (sfid-20151016_132820_779190_3F5069D0)
References: <1444994885-21825-1-git-send-email-kaisrja1@fel.cvut.cz>
	 (sfid-20151016_132820_779190_3F5069D0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-10-16 at 13:28 +0200, Jan Kaisrlik wrote:
> The patch adds support for Intelligent Transportation System (ITS-G5)
> band as defined by ETSI EN 302 663 standard. This band is enabled by
> a new configuration option CFG80211_REG_ITSG5_BAND, which depends on
> CFG80211_CERTIFICATION_ONUS.

That Kconfig option seems unnecessary - after all, the regulatory
database still has a say in this?

Even the NL80211_RRF_ITSG5 flag seems somewhat unnecessary - if the
regulatory database did in fact provide information on these channels,
then we can assume they're usable, no?

IOW - I don't really see the point of this patch - can't we treat these
channels just like regular ones, and rely on the regulatory information
to prevent their use in all but special scenarios (where the integrator
is providing a proper database)?

johannes
