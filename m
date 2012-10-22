Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2JVM4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 08:56:07 -0400
Message-ID: <1350910599.10166.4.camel@jlt4.sipsolutions.net> (sfid-20121022_145613_149942_64BBD495)
Subject: Re: [PATCH v4 6/6] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 22 Oct 2012 14:56:39 +0200
In-Reply-To: <50842563.4010201@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	  <1350226137-13704-7-git-send-email-victorg@ti.com>
	 <1350414472.10177.17.camel@jlt4.sipsolutions.net> <50842563.4010201@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-10-21 at 18:40 +0200, Victor Goldenshtein wrote:
> On 16/10/2012 21:07, Johannes Berg wrote:
> > On Sun, 2012-10-14 at 16:48 +0200, Victor Goldenshtein wrote:
> >> Add ieee80211_ap_process_chanswitch(), to handle a channel switch
> >> request for AP.
> >>
> >> Add ieee80211_ap_ch_switch_done() which updates oper_channel
> >> and notifies upper layers about channel switch complete event.
> >
> > Given channel contexts, how does this patch need to change?
> >
> 
> I guess most of the changes would be in the channel switch complete 
> area, we will need to update the correct vif channel 
> (ieee80211_assign_vif_chanctx) instead of the local->oper_channel.

Yes, maybe, not sure.

Also wrt. channel contexts, how will CAC/radar check work? The AP isn't
bound to a channel until start_ap(), so somehow you'll have to bind it
(and keep it on that channel!) while the DFS check is running? And also
prohibit using multiple channels at this time...?

johannes

