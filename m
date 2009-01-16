Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47293 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbZAPQkd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:40:33 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:40:33 -0800
Date: Fri, 16 Jan 2009 08:40:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 02/13] cfg80211: add option for wiphys to disregard
	country IEs
Message-ID: <20090116164004.GH29609@tesla> (sfid-20090116_174038_259295_F72DAB2A)
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com> <1232064746-17134-2-git-send-email-lrodriguez@atheros.com> <1232064746-17134-3-git-send-email-lrodriguez@atheros.com> <1232097432.3854.15.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232097432.3854.15.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 01:17:12AM -0800, Johannes Berg wrote:
> On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> > Country IEs can be disregarded based on regulatory policy by
> > a driver. This is only possible, of course, if the driver already
> > has its own regulatory domain.
> 
> Can you say why? This doesn't seem useful to me.

Its based on our internal regulatory policy for our hardware. If you have
a alpha2 map you should disregard the country IE. If you have a world regdom
you can follow the IE (but not enable more). Technically I think that without
this things may work now to respect the original driver stuff though with the
new orig_* changes, will need to test.

  Luis
