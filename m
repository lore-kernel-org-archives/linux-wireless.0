Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41662
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763118AbXFAUnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 16:43:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Olivier Cornu" <o.cornu@gmail.com>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Date: Fri, 1 Jun 2007 22:42:52 +0200
Cc: linux-wireless@vger.kernel.org
References: <200706011129.12432.mb@bu3sch.de> <7b4bf7ff0706010455t75b1e2bdq46585ac9d74bc0ae@mail.gmail.com>
In-Reply-To: <7b4bf7ff0706010455t75b1e2bdq46585ac9d74bc0ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706012242.52226.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 June 2007 13:55:31 Olivier Cornu wrote:
> 2007/6/1, Michael Buesch <mb@bu3sch.de>:
> > This updates stop_queue(s) kdoc as currently there's
> > a undocumented dependency.
> >
> > Stopping the queue from anywhere else than the ops->tx()
> > callback will result in a hard to debug deadlock and
> > system freeze (on UP).
> 
> Sorry but: why would one call ieee80211_stop_queue() from outside of
> the tx handler in the first place? Wouldn't that simply be a driver
> design problem?

No it wouldn't. A driver may want to stop (and probably flush) TX queues
when it resets itself due to an error. We don't want the stack to
try to call ops->tx() while we are restarting the hardware.
Other IMO valid cases might exist.

> Unless i missed something, stop_queue() isn't called outside of the tx
> handler in bcm43xx code...

You missed something.


-- 
Greetings Michael.
