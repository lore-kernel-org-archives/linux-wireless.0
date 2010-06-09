Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab0FIHcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 03:32:42 -0400
Subject: Re: [PATCHv3] mac80211: Fix circular locking dependency in ARP
 filter handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	reinette.chatre@intel.com
In-Reply-To: <1276066224-17880-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1276066224-17880-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 09:32:34 +0200
Message-ID: <1276068754.3727.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-09 at 09:50 +0300, Juuso Oikarinen wrote:

> v3: - queue reconfig filter work to kernel default wq instead of mac80211 wq

I think it would make more sense to use a different lock instead, like
the iflist mutex?

johannes

