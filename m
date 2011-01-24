Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1AXLed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 06:34:33 -0500
Subject: Re: [PATCH v2 2/6] nl80211: Pass probe response data to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1295816579-28925-3-git-send-email-arik@wizery.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
	 <1295816579-28925-3-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 12:35:24 +0100
Message-ID: <1295868924.3639.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-23 at 23:02 +0200, Arik Nemtsov wrote:
> Allow usermode to pass probe-response data. This data can be used as a
> template probe-response offloading.

Why use a separate command for this, and not do it like the SSID? I also
was under the impression you wanted both (which is somewhat redundant
since you can parse the SSID out of the probe response), so shouldn't
they both be required (or none, for compatibility)?

Also, should cfg80211 pretend it knows the SSID/probe response when
userspace didn't set it (from the beacon) so that mac80211 or the
low-level drivers don't need to worry?

johannes


