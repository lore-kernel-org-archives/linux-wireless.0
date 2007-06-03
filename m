Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54498
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbXFCKqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2007 06:46:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Olivier Cornu" <o.cornu@gmail.com>
Subject: Re: [PATCH] mac80211: Add module parameter for setting initial rate in rc80211_simple
Date: Sun, 3 Jun 2007 12:45:31 +0200
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Jiri Benc" <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net> <7b4bf7ff0706030333j21152541hed9384e965cacaa9@mail.gmail.com>
In-Reply-To: <7b4bf7ff0706030333j21152541hed9384e965cacaa9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706031245.31774.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 03 June 2007 12:33:36 Olivier Cornu wrote:
> 2007/6/2, Larry Finger <Larry.Finger@lwfinger.net>:
> > The initial rate for STA's using rc80211_simple is set to the last
> > rate in the rate table. This is too fast for the bcm43xx-mac80211
> > driver. To correct this situation without affecting any other driver,
> > an initial_rate parameter is added to the rc80211_simple module.
> 
> What if two different mac80211 device drivers need two different initial rates?

I'm not sure if that's useful at all. The algorithm will migrate
away from the initial value very quickly anyway. What about simply
using 1MBit for B-PHYs and (what's the lowest OFDM rate?) 9M? for
G and A PHYs.

-- 
Greetings Michael.
