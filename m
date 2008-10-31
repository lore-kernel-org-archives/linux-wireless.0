Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:57090 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYJaVXE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 17:23:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [RFC PATCH 1/2] orinoco: Use PM notifier to cache firmware for use during resume
Date: Fri, 31 Oct 2008 22:27:38 +0100
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
	David Kilroy <kilroyd@googlemail.com>,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <1225415743-28209-1-git-send-email-kilroyd@googlemail.com> <1225415743-28209-2-git-send-email-kilroyd@googlemail.com> <200810312037.00936.arvidjaar@mail.ru>
In-Reply-To: <200810312037.00936.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810312227.39057.rjw@sisk.pl> (sfid-20081031_222313_873887_C3FF1A1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, 31 of October 2008, Andrey Borzenkov wrote:
> On Friday 31 October 2008, David Kilroy wrote:
> > When preparing for either suspend or hibernation, load the necessary
> > firmware from userspace.
> > 
> > Upon error or resume, release the firmware.
> > 
> > Works for both Agere and Symbol firmware.
> > 
> > Signed-off by: David Kilroy <kilroyd@gmail.com>
> 
> This is on top of my old patch; was it ever accepted anywhere? I guess
> it should be rediffed against clean tree.
> 
> > @@ -621,7 +620,7 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
> >  	ret = hermes_init(hw);
> >  
> >  	/* hermes_reset() should return 0 with the secondary firmware */
> > -	if (secondary && ret != 0)
> > +	if (secondary && (ret != 0))
> 
> Extra parenthesis are redundant, are not they?
> 
> >  /********************************************************************/
> > +/* Power management                                                 */
> > +/********************************************************************/
> > +
> > +static int orinoco_pm_notifier(struct notifier_block *notifier,
> > +			       unsigned long pm_event,
> > +			       void *unused)
> 
> It probably should be conditional on CONFIG_PM somehow? 

CONFIG_PM_SLEEP, actually.

Thanks,
Rafael
