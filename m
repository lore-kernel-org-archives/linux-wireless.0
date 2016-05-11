Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59800 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbcEKHVl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 03:21:41 -0400
Message-ID: <1462951291.2869.4.camel@sipsolutions.net> (sfid-20160511_092203_811817_8BF502F3)
Subject: Re: [PATCH] cfg80211/nl80211: add wifi tx power mode switching
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Wei-Ning Huang <wnhuang@chromium.org>,
	Linux-Wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Sameer Nanda <snanda@chromium.org>,
	Todd Broch <tbroch@chromium.org>, davem@davemloft.net,
	netdev@vger.kernel.org
Date: Wed, 11 May 2016 09:21:31 +0200
In-Reply-To: <1462430663-9448-1-git-send-email-wnhuang@chromium.org> (sfid-20160505_084446_369647_C7B8DEBC)
References: <1462430663-9448-1-git-send-email-wnhuang@chromium.org>
	 (sfid-20160505_084446_369647_C7B8DEBC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-05-05 at 14:44 +0800, Wei-Ning Huang wrote:
> Recent new hardware has the ability to switch between tablet mode and
> clamshell mode. To optimize WiFi performance, we want to be able to
> use different power table between modes. This patch adds a new
> netlink message type and cfg80211_ops function to allow userspace to
> trigger a power mode switch for a given wireless interface.

I'm not a fan of this at all. Too much magic.

FWIW, we implemented something similar, currently with vendor commands,
that simply allows to set the TX power in a more controlled fashion,
i.e. allows setting TX power per band/channel range. For our device
it's only 2.4 GHz vs. 5.2 GHz, but I can imagine that you might want to
split it a bit further, so perhaps we need to advertise those ranges
somehow.

johannes
