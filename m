Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32911 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966072AbaLLLfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 06:35:34 -0500
Message-ID: <1418384131.2470.19.camel@sipsolutions.net> (sfid-20141212_123538_141547_A1944443)
Subject: Re: [PATCH] mac80211: update the channel context after channel
 switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Dec 2014 12:35:31 +0100
In-Reply-To: <1417360646-5262-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1417360646-5262-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-11-30 at 17:17 +0200, Emmanuel Grumbach wrote:
> When the channel switch has been made, a vif is now using
> the channel context which was reserved. When that happens,
> we need to update the channel context since its parameters
> may change.
> 
> I hit a case in which I switched to a 40Mhz channel but the
> reserved channel context was still on 20Mhz. The rate control
> would try to send 40Mhz packets on a 20Mhz channel context and
> that made iwlwifi's firmware unhappy.

Applied.

johannes

