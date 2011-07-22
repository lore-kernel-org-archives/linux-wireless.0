Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:50787 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932096Ab1GVUiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 16:38:00 -0400
Subject: Re: [PATCH] cfg80211: hold reg_mutex when updating regulatory
From: Sven Neumann <s.neumann@raumfeld.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: libertas-dev@lists.infradead.org, daniel@zonque.org,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com
Date: Fri, 22 Jul 2011 22:37:55 +0200
In-Reply-To: <20110715173240.GD2566@tuxdriver.com>
References: <1310456639-16468-1-git-send-email-s.neumann@raumfeld.com>
	 <1310457159-16698-2-git-send-email-s.neumann@raumfeld.com>
	 <20110715173240.GD2566@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1311367076.27468.4.camel@bender> (sfid-20110722_223804_694232_D303033B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 2011-07-15 at 13:32 -0400, John W. Linville wrote:
> Luis, any comment on this?
> 
> On Tue, Jul 12, 2011 at 09:52:39AM +0200, Sven Neumann wrote:
> > The function wiphy_update_regulatory() uses the static variable
> > last_request and thus needs to be called with reg_mutex held.
> > This is the case for all users in reg.c, but the function was
> > exported for use by wiphy_register(), from where it is called
> > without the lock being held.
> > 
> > Fix this by making wiphy_update_regulatory() private and introducing
> > regulatory_update() as a wrapper that acquires and holds the lock.
> > 
> > Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>

I'd appreciate if someone would review this patch. But probably this is
not really an issue except that it's somewhat ugly to export a function
that should be called with a lock held and that lock is actually
private. But in this particular case it is not a problem, as far as I
can see, since the only user of wiphy_update_regulatory() outside
net/wireless/reg.c is initialization code. So there is not likely going
to be a race condition here.


Sven


