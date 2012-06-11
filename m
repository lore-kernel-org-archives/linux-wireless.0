Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2FKHch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 03:32:37 -0400
Message-ID: <1339399952.4520.13.camel@jlt3.sipsolutions.net> (sfid-20120611_093240_807352_9C330F1F)
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, me@bobcopeland.com,
	mickflemm@gmail.com, kvalo@qca.qualcomm.com
Date: Mon, 11 Jun 2012 09:32:32 +0200
In-Reply-To: <4FD3A936.8070600@broadcom.com>
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1339228530.4539.0.camel@jlt3.sipsolutions.net>
	 <4FD3A936.8070600@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-09 at 21:51 +0200, Arend van Spriel wrote:
> On 06/09/2012 09:55 AM, Johannes Berg wrote:
> > On Fri, 2012-06-08 at 17:51 -0700, Luis R. Rodriguez wrote:
> >> From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
> >>
> >> Turns out that standard Linux distributions leave CONFIG_EXPERT
> >> enabled. This makes this option useless for wireless testing / research
> >> purposes as we don't want certain features enabled on all kernel
> >> builds. This adds a new CONFIG_CFG80211_EXPERT and makes a few
> >> features depend on them.
> > 
> > I'm not sure I see the point in CFG80211_EXPERT. All the features you're
> > putting in there have nothing to do with cfg80211 at all anyway.
> 
> My understanding of this is that CFG80211_EXPERT was chosen because
> cfg80211 provides the kernel side of the regulatory framework.

It just happens though that the two options are related to regulatory --
maybe then this should have a different name? I still don't see the
need. What would you put under it in brcm[sf]mac? I certainly wouldn't
see any reason to put anything under it in our driver since it's much
simpler to .

Also, the argument about distros doesn't really work that way, if there
are users interested in something then the distros will certainly enable
this (CFG80211_EXPERT) option to get something hidden behind it.

johannes

