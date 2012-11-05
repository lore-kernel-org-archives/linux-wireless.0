Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab2KEPUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 10:20:54 -0500
Message-ID: <1352128887.9466.17.camel@jlt4.sipsolutions.net> (sfid-20121105_162112_932844_61D308CE)
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 05 Nov 2012 16:21:27 +0100
In-Reply-To: <50922A9D.2060409@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	   <1350226137-13704-2-git-send-email-victorg@ti.com>
	  <1350414099.10177.13.camel@jlt4.sipsolutions.net>
	 <50842569.5000602@ti.com> <1350910543.10166.3.camel@jlt4.sipsolutions.net>
	 <50922A9D.2060409@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-01 at 09:54 +0200, Victor Goldenshtein wrote:
> On 22/10/2012 14:55, Johannes Berg wrote:
> >> 2. In __nl80211_set_channel() - to cover the case when the CAC was
> >> initiated on a "preset_chan" (during AP init phase) and the IF was
> >> removed before the AP was even started (local->oper_channel wasn't set yet).
> >
> > Hmm, I'm not sure I get it. How is "local->oper_channel" (a mac80211
> > variable) related to this cfg80211 code?
> 
> It's not, just saying that its not set at this point.
> 
> > start_ap() isn't expected to be able to succeed until CAC passed
> > successfully, but OTOH the channel isn't configured until then?
> 
> right, the initial CAC performed before start_ap(), only by setting the 
> channel with __nl80211_set_channel() + radar detection command.

Hmm. Maybe then the channel should be passed to the radar detection
command instead? That way, it can be passed through, you can allocate a
channel context, etc. Much easier?

johannes

