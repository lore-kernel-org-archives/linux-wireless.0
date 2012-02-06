Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2BFVCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 16:02:15 -0500
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on
 op-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
In-Reply-To: <CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	 <1327581484-22047-4-git-send-email-victorg@ti.com>
	 <4F277F85.1090901@sipsolutions.net>
	 <CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 22:01:30 +0100
Message-ID: <1328562090.3466.1.camel@jlt3.sipsolutions.net> (sfid-20120206_220219_295003_0CF99BB0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-02 at 18:06 +0200, Goldenshtein, Victor wrote:

> > So do we think that no safeguards here at all are acceptable? Not even
> > checking that radar detection was enabled, CAC time expired, etc.?
> 
> We can add a check whether dfs is supported by the driver
> (rdev->wiphy.features & NL80211_FEATURE_DFS).
> 
> The nl/cfg/mac doesn't have the info whether the radar detection is
> enabled and definitely doesn't heard about CAC time, on other hand the
> driver which starts/handles radar detection know whether it started or
> not. 

I'm just trying to make sure that you're OK with a simple two-line iw
patch being sufficient to start transmitting on radar channels ...

> I think the driver should perform this simple "sanity" checks,
> otherwise we"ll need to save different DFS states in the mac, not sure
> that this is what we want.

I disagree -- adding this in each driver, which will surely end up with
slightly different semantics, seems like a recipe for disaster.

johannes

