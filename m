Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab2FUOzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:55:41 -0400
Message-ID: <1340290538.4489.32.camel@jlt3.sipsolutions.net> (sfid-20120621_165544_926084_CB580FCF)
Subject: Re: [RFCv2 06/13] cfg80211: track monitor interfaces count
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Jun 2012 16:55:38 +0200
In-Reply-To: <1340172859-18146-7-git-send-email-michal.kazior@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
	 <1340172859-18146-7-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
> Implements .set_monitor_enabled(wiphy, enabled).
> 
> Notifies driver upon change of interface layout.
> 
> If only monitor interfaces become present it is
> called with 2nd argument being true. If
> non-monitor interface appears then 2nd argument
> is false. Driver is notified only upon change.
> 
> This makes it more obvious about the fact that
> cfg80211 supports single monitor channel. Once we
> implement multi-channel we don't want to allow
> setting monitor channel while other interface
> types are running. Otherwise it would be ambiguous
> once we start considering num_different_channels.

This makes sense :)

> + * @set_monitor_enabled: Notify driver that there are only monitor
> + *	interfaces running.

Maybe rename to "set_monitor_only()"? But I don't really care much.

Ok totally makes sense, not sure why I thought yesterday I should take a
closer look.

Btw, I need to commend you on the quality of your code in general, I
like all the locking assertions etc. :-)

johannes

