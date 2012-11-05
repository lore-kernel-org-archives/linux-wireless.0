Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab2KEPWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 10:22:38 -0500
Message-ID: <1352128994.9466.19.camel@jlt4.sipsolutions.net> (sfid-20121105_163339_489721_509338E6)
Subject: Re: [PATCH v4 6/6] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 05 Nov 2012 16:23:14 +0100
In-Reply-To: <50922AA9.4030509@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	   <1350226137-13704-7-git-send-email-victorg@ti.com>
	  <1350414472.10177.17.camel@jlt4.sipsolutions.net>
	 <50842563.4010201@ti.com> <1350910599.10166.4.camel@jlt4.sipsolutions.net>
	 <50922AA9.4030509@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-01 at 09:54 +0200, Victor Goldenshtein wrote:

> > Also wrt. channel contexts, how will CAC/radar check work? The AP isn't
> > bound to a channel until start_ap(), so somehow you'll have to bind it
> 
> As I mentioned in my previous email we do it with __nl80211_set_channel().

Yeah but that probably should change anyway, for channel contexts?

> > (and keep it on that channel!) while the DFS check is running? And also
> > prohibit using multiple channels at this time...?
> 
> Why we need to prohibit multiple channels during CAC?

Because you can't do CAC properly while you're channel-hopping?

> I don't see any problems to start CAC on different channels (once we"ll 
> add this support)

I do see issues with that, but let's not worry about it for now.

> also lets not forget that CAC is relevant only for 
> the AP role. Today for the MR single channel scenarios we have this 
> check in the nl80211_start_radar_detection():

MR?

> +» if·(chan->cac_started)
> +» » return·-EBUSY;
> 
> which should block concurrent CAC executions on the same channel.

Yes.

> Anyway, the "DFS channel contexts" are not part of this patch series, 
> and can be added later.

No ... channel contexts are in the kernel now, so you do have to think
about it now.

johannes

