Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab2EIGLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 02:11:10 -0400
Message-ID: <1336543867.4323.1.camel@jlt3.sipsolutions.net> (sfid-20120509_081123_778502_B32C3E1F)
Subject: Re: [PATCH 2/2] mac80211: allow low-level drivers to set netdev
 feature bits
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 May 2012 08:11:07 +0200
In-Reply-To: <1336506821-23709-2-git-send-email-arik@wizery.com> (sfid-20120508_215421_663017_FEC8F401)
References: <1336506821-23709-1-git-send-email-arik@wizery.com>
	 <1336506821-23709-2-git-send-email-arik@wizery.com>
	 (sfid-20120508_215421_663017_FEC8F401)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-08 at 22:53 +0300, Arik Nemtsov wrote:
> Allow low-level drivers to change the feature bit for a vif's underlying
> net_device struct.

What are you planning to use this for? I'm not really sure I see the
need for an exported function? Is it not going to just be set the same
for all interfaces?

Out of the many netdev feature bits, we can handle maybe a handful in
mac80211, so I'm worried this API will suggest to people they can look
at netdev_features.h...

johannes


