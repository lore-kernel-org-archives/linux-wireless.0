Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55990 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350AbYGWTJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 15:09:16 -0400
Date: Wed, 23 Jul 2008 16:09:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [GIT PATCH] RFC: next batch of rfkill changes
Message-ID: <20080723190912.GF11009@khazad-dum.debian.net> (sfid-20080723_210920_452006_F5B5FD1B)
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <200807232008.59241.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807232008.59241.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 23 Jul 2008, Ivo van Doorn wrote:
> On Wednesday 23 July 2008, Henrique de Moraes Holschuh wrote:
> > This is my next batch of rfkill changes.  They add features and address
> > some shortcomings of rfkill-input, mostly.
> > 
> > Please comment.  One thing that is bothering me in the last patch is
> > what happens during suspend/resume to pending delayed rfkill state
> > changes.  Are pending scheduled jobs executed, cancelled, or frozen to
> > fire up when the system resumes itself?
> 
> When using the kernel workqueue, I *think* they are frozen until the system
> resumes. When using a private workqueue you should use the freezable
> workqueue allocation.
> 
> But in this case you are using the kernel workqueue, so I assume it is
> scheduled untill after resume.

I will look into handling that in the next version, then.  Or as a separate
patch.

I wonder if we should switch to a private workqueue?  We are not being
exactly lightweight users of schedule_foo in rfkill-input, and I'd really
hate to hang the main workqueue if something in rfkill/rfkill-input decides
to deadlock.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
