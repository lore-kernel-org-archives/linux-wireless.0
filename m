Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1CHOOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 09:14:17 -0500
Subject: Re: [RFC 4/9] mac80211: don't remove/add interfaces when WoW is
 enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1299011804-13899-5-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
	 <1299011804-13899-5-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 15:14:14 +0100
Message-ID: <1299593654.4676.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-01 at 22:36 +0200, Eliad Peller wrote:
> When WoW triggers are enabled, we shouldn't remove the interfaces
> on suspend, as we need them in order to get the triggers.
> Consequently, we shouldn't add them back when resuming.
> 
> TODO:
> what settings should we configure when going to WoW (ps,
> rx_filtering, etc.)?
> whose responsibility is it - the mac80211 or the lower driver?
> (the lower driver may implement some features that are not known
> to the mac80211)
> should they be configurable by the user?

Yeah this goes with what I just said... but why do it in mac80211?

FWIW, iwlwifi will also require a pretty much complete reconfig when
going to suspend, and also when resuming, and will also drop aggregation
sessions while asleep (for example) so more tricks will be needed.

johannes

