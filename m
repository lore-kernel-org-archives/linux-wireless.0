Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaCGO2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 09:28:00 -0500
Message-ID: <1394202477.4653.4.camel@jlt4.sipsolutions.net> (sfid-20140307_152804_511407_477C951D)
Subject: Re: [RFC PATCH 2/8] nl80211: Add attributes describing channel
 bandwidth
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, Michal Sojka <sojkam1@fel.cvut.cz>,
	s.sander@nordsys.de, jan-niklas.meier@volkswagen.de
Date: Fri, 07 Mar 2014 15:27:57 +0100
In-Reply-To: <1394199475-5208-3-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143806_016638_D28BD455)
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1394199475-5208-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140307_143806_016638_D28BD455)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 14:37 +0100, Rostislav Lisovy wrote:
> These attributes are used to report back to userspace
> the information about the bandwidth allowed in
> a particular channel

> +	NL80211_FREQUENCY_ATTR_NO_20MHZ,
> +	NL80211_FREQUENCY_ATTR_NO_10MHZ,

This makes some sense, but I think such channels should be excluded by
default from the channel list in nl80211.c because they will break old
tools - you should include them only in the 'split wiphy info' case.

johannes

