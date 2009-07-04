Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:48054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZGDVhp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 17:37:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 4/5] ath5k: do not release irq across suspend/resume
Date: Sat, 4 Jul 2009 23:37:58 +0200
Cc: Bob Copeland <me@bobcopeland.com>, linville@tuxdriver.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
References: <1246726795-3934-1-git-send-email-me@bobcopeland.com> <1246726795-3934-5-git-send-email-me@bobcopeland.com> <4A4FC889.9000401@gmail.com>
In-Reply-To: <4A4FC889.9000401@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907042337.59470.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 04 July 2009, Jiri Slaby wrote:
> On 07/04/2009 06:59 PM, Bob Copeland wrote:
> > Paraphrasing Rafael J. Wysocki: "drivers should not release PCI IRQs
> > in suspend."  Doing so causes a warning during suspend/resume on some
> > platforms.
> 
> Hmm, I added it because I was told an irq can change over suspend (or at
> least it could in the past). I think it's not true anymore, since we
> would have serious problems with the code all over the tree.
> 
> I can't find where Rafael uttered those words above, do you have a link?

Someone recently asked on a mailing list (unfortunately I can't recall
which one) if drivers should release irqs over suspend.

The answer was more-or-less that drivers are not expected to do that and it
really is not recommended.  In fact, we do the whole suspend_device_irqs()
thing, because the drivers are expected not to do that.

Best,
Rafael
