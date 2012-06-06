Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2FFJNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:13:38 -0400
Message-ID: <1338974016.4513.45.camel@jlt3.sipsolutions.net> (sfid-20120606_111340_866134_FAE0F7F1)
Subject: Re: [RFC 10/14] cfg80211: track monitor channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 11:13:36 +0200
In-Reply-To: <1338203942-5667-11-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-11-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> Make it even more obvious we support single
> monitor channel. This will allow us to remove
> .get_channel.

This has an interesting corner case -- where do we take the channel from
if it was never set, but monitors are created? It looks like it should
be initialised somehow, but then ...

Maybe we also need to explicitly set the monitor channel whenever we
call set_monitor_enabled()?

johannes

