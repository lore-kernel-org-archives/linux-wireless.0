Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161052Ab2KNLTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 06:19:15 -0500
Message-ID: <1352891985.9510.22.camel@jlt4.sipsolutions.net> (sfid-20121114_121918_909503_4C48E26B)
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 14 Nov 2012 12:19:45 +0100
In-Reply-To: <50A26163.10300@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	    <1350226137-13704-2-git-send-email-victorg@ti.com>
	   <1350414099.10177.13.camel@jlt4.sipsolutions.net>
	  <50842569.5000602@ti.com> <1350910543.10166.3.camel@jlt4.sipsolutions.net>
	  <50922A9D.2060409@ti.com> <1352128887.9466.17.camel@jlt4.sipsolutions.net>
	 <50A26163.10300@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-13 at 17:04 +0200, Victor Goldenshtein wrote:

> > Hmm. Maybe then the channel should be passed to the radar detection
> > command instead? That way, it can be passed through, you can allocate a
> > channel context, etc. Much easier?
> 
> We already pass the frequency in the radar detection command, the set 
> channel operation comes during hostapd init flow regardless DFS 
> implementation.

Ok, but it doesn't seem to be passed through to the driver, nor
considered as a channel that's currently in use. cfg80211 is now
tracking which channels are used for multi-channel purposes, and this
needs to be integrated here.

johannes

