Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab0KJPvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 10:51:53 -0500
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 07:52:47 -0800
Message-ID: <1289404367.3748.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-10 at 12:50 +0900, Bruno Randolf wrote:

> 802.11n devices should enable or disable chains, based on which antennas are
> present (If all antennas belonging to a particular chain are disabled, the
> entire chain should be disabled). HT capabilities (like STBC, TX Beamforming,
> Antenna selection) should be calculated based on the available chains after
> applying the antenna masks. Should a 802.11n device have diversity antennas
> attached to one of their chains, diversity can be enabled or disabled based on
> the antenna information.

I'm not entirely convinced that this is a good idea. Nor that, even if
11n devices were to implement it, they should all implementing their own
code to update the HT capabilities. However, I suppose that nothing
forces them to implement it, and when somebody does I can still complain
when they put everything into the driver.

johannes

