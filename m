Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46838 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYDUGm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 02:42:56 -0400
Subject: Re: [PATCH] libertas: Fix ethtool statistics
From: David Woodhouse <dwmw2@infradead.org>
To: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
In-Reply-To: <20080420191051.GA12136@Chamillionaire.breakpoint.cc>
References: <1208448814.9212.270.camel@pmac.infradead.org>
	 <200804181149.41838.hs4233@mail.mn-solutions.de>
	 <1208517302.9212.324.camel@pmac.infradead.org>
	 <200804181510.53412.hs4233@mail.mn-solutions.de>
	 <20080420084101.GB7685@Chamillionaire.breakpoint.cc>
	 <1208688992.9212.412.camel@pmac.infradead.org>
	 <20080420191051.GA12136@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 07:42:49 +0100
Message-Id: <1208760169.9212.442.camel@pmac.infradead.org> (sfid-20080421_074300_815067_D25282C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-04-20 at 21:10 +0200, Sebastian Siewior wrote:
> The comments were
> - everything what deals with mesh should take the mash lock
> - check for mesh support before calling lbs_ethtool_get_stats()
> 
> If your second patch deals with these than yes it should be fine.

It deals with the latter. I don't believe we need any more locking here;
we just submit our own request, wait for it to return and use the data
in the reply.

-- 
dwmw2

