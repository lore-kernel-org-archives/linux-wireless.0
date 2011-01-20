Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1ATUwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 15:52:16 -0500
Subject: Re: [PATCH 1/3] nl80211: allow passing SSID in nl80211_set_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1295555306-20005-1-git-send-email-arik@wizery.com>
References: <1295555306-20005-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 21:52:14 +0100
Message-ID: <1295556734.3693.53.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-20 at 22:28 +0200, Arik Nemtsov wrote:
> wl12xx cards require knowledge of the real SSID when operating as AP
> with SSID hidden in beacon data. Allow passing the real SSID from
> usermode apart from beacon data.

As I also just commented on the corresponding hostapd patch, I'm not
sure this is sufficient. If this is necessary for probe response
offloading, I'm tempted to say that we should be honest about it and let
userspace determine the entire probe response (which will contain the
correct SSID) since it can be different from the beacon which presumably
you're now using to generate probe responses.

johannes

