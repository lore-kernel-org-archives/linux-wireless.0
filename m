Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49254 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622Ab2FUO5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:57:45 -0400
Message-ID: <1340290665.4489.33.camel@jlt3.sipsolutions.net> (sfid-20120621_165748_639938_8B7B8084)
Subject: Re: [RFCv2 10/13] cfg80211: set initial monitor channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Jun 2012 16:57:45 +0200
In-Reply-To: <1340172859-18146-11-git-send-email-michal.kazior@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
	 <1340172859-18146-11-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
> Implements behaviour seen in mac80211. A running
> monitor always has a channel - even before
> .set_channel. This way we won't break current
> behaviour.

I'm a little doubtful about this. Currently, mac80211 will keep the
channel if you set it on say wlan0, your monitor iface gets the same
channel. Then if you remove wlan0, you still have the same channel, but
it seems here this is different now? I'm not sure it matters much, but
it's worth thinking about? Or am I totally misunderstanding this now?

johannes

