Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45745 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764179AbZD3WqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 18:46:04 -0400
Date: Thu, 30 Apr 2009 18:30:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix PS vs. scan race
Message-ID: <20090430223025.GF9323@tuxdriver.com>
References: <1240434171.30082.21.camel@johannes.local> <1241126864.12388.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241126864.12388.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 30, 2009 at 11:27:44PM +0200, Johannes Berg wrote:
> On Wed, 2009-04-22 at 23:02 +0200, Johannes Berg wrote:
> > When somebody changes the PS parameters while scanning
> > is in progress, we enable PS -- during the scan. This
> > is clearly not desirable, and we can just abort enabling
> > PS when scanning since when the scan finishes it will
> > be taken care of.
> 
> John, did this fall through the cracks? I see you included a patch from
> today but not this :)

Looks like this one (on wireless-testing#master)?

commit da6cbb045d04706157d3117153b275ed9126bd1d
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Apr 22 23:02:51 2009 +0200

    mac80211: fix PS vs. scan race
    
    When somebody changes the PS parameters while scanning
    is in progress, we enable PS -- during the scan. This
    is clearly not desirable, and we can just abort enabling
    PS when scanning since when the scan finishes it will
    be taken care of.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Reviewed-by: Kalle Valo <kalle.valo@iki.fi>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
