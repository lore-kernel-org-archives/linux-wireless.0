Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2JVMzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 08:55:11 -0400
Message-ID: <1350910543.10166.3.camel@jlt4.sipsolutions.net> (sfid-20121022_145516_666378_35617A31)
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 22 Oct 2012 14:55:43 +0200
In-Reply-To: <50842569.5000602@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	  <1350226137-13704-2-git-send-email-victorg@ti.com>
	 <1350414099.10177.13.camel@jlt4.sipsolutions.net> <50842569.5000602@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-10-21 at 18:40 +0200, Victor Goldenshtein wrote:

> >> +++ b/net/wireless/nl80211.c
> >> @@ -1411,6 +1411,7 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
> >>   			result = -EINVAL;
> >>   			break;
> >>   		}
> >> +		channel->cac_started = false;
> >
> > Why this? If the device supports channel contexts then maybe one vif
> > could set the channel and the other could be doing radar detection? But
> > anyway this only presets the channel, so nothing will happen until the
> > AP interface is started? So basically I don't understand this at all.
> 
> Here we just clearing the cac_started flag, this was previously done in 
> the ieee80211_do_stop() for the "sdata->wdev.preset_chan", but as we 
> didn't want to modify cfg80211 fields from mac I suggested to move it here.

We have an explicit AP stop operation in cfg80211 now, maybe you want
that?

> I"ll try to clarify things a bit, the channel availability check (CAC) 
> could be started during:
> 1. AP init phase - when AP is configured on DFS channel.
> 2. As a result of a channel switch - AP moved to a DFS channel.

But it'll be started explicitly by userspace.

> In both cases we set the cac_started flag from the 
> nl80211_start_radar_detection() 

right

> and clear it:
> 1. As a result of radar event.

makes sense

> 2. In __nl80211_set_channel() - to cover the case when the CAC was 
> initiated on a "preset_chan" (during AP init phase) and the IF was 
> removed before the AP was even started (local->oper_channel wasn't set yet).

Hmm, I'm not sure I get it. How is "local->oper_channel" (a mac80211
variable) related to this cfg80211 code?

start_ap() isn't expected to be able to succeed until CAC passed
successfully, but OTOH the channel isn't configured until then?

johannes

