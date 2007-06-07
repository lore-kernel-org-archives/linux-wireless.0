Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:57340 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932131AbXFGWTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 18:19:30 -0400
Date: Fri, 8 Jun 2007 00:19:24 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add module parameter for setting initial rate  in rc80211_simple
Message-ID: <20070608001924.1014b5cc@logostar.upir.cz>
In-Reply-To: <4668772C.1000107@lwfinger.net>
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
	<20070607221939.444e9d74@griffin.suse.cz>
	<4668772C.1000107@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 07 Jun 2007 16:22:52 -0500, Larry Finger wrote:
> I'm more than a little confused. First you tell me that setting the initial rate with a module 
> parameter is bad because it sets a value for all _MY_ devices, then you say that you will allow a 
> change that would affect _EVERYONE'S_ devices. Huh?

The first part was not specifically about the change, but about the
approach used for switching on the feature. Module parameters are not
intended for such things. Almost always (not counting debugging stuff) when
you use a module parameter you do something wrong (yes, that includes
ieee80211_regdom and ieee80211_japan_5ghz parameters in mac80211. And yes,
I'm aware there are some rare cases where module parameters are useful).

The actual change is another thing. I don't think that setting of the
initial rate matters much - if the algorithm is good enough, it will
quickly pick up the best rate independently of the initial rate.

> I wrote the code the way I did because I thought 
> it was much better to allow a local solution rather than a global one.

Use a specific rate control algorithm then.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
