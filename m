Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58520 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbYJNRFW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 13:05:22 -0400
Subject: Re: [PATCH v2] ipw2200: change default policy for auto-associate
From: Dan Williams <dcbw@redhat.com>
To: Tim Gardner <timg@tpi.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224003139.1799.12.camel@localhost.localdomain>
References: <20081014163803.AD89B5A1D8@sepang.rtg.net>
	 <1224003139.1799.12.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 13:04:18 -0400
Message-Id: <1224003858.1799.14.camel@localhost.localdomain> (sfid-20081014_190527_016222_D338F726)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 12:52 -0400, Dan Williams wrote:
> On Tue, 2008-10-14 at 10:38 -0600, Tim Gardner wrote:
> > From 6f6a49200c74553acac806b6987d5c661346ca00 Mon Sep 17 00:00:00 2001
> > From: Tim Gardner <tim.gardner@canonical.com>
> > Date: Tue, 14 Oct 2008 10:30:33 -0600
> > Subject: [PATCH v2] ipw2200: change default policy for auto-associate
> > 
> > Do not attempt association until directed to do so by a user space
> > application. In particular, this avoids race conditions with
> > NetworkManager association state.
> > 
> > Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> 
> Though for completeness, maybe associate = 0; ?

Or not, just thought that since the rest two lines below do it, but
actually pointless.

Dan

> 
> Acked-by: Dan Williams <dcbw@redhat.com>
> 
> Cards shouldn't be associating automatically with anything until told to
> do so to a specific SSID or specific BSSID/SSID combination, otherwise
> it's a security risk.  The 3 people out in the middle of nowhere with
> one unencryped access point who may want this functionality should be
> turning it on manually because they are clearly more technically able
> than most.
> 
> > ---
> >  Documentation/networking/README.ipw2200 |    2 +-
> >  drivers/net/wireless/ipw2200.c          |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/networking/README.ipw2200 b/Documentation/networking/README.ipw2200
> > index 4f2a40f..80c7285 100644
> > --- a/Documentation/networking/README.ipw2200
> > +++ b/Documentation/networking/README.ipw2200
> > @@ -147,7 +147,7 @@ Where the supported parameter are:
> >  	driver.  If disabled, the driver will not attempt to scan 
> >  	for and associate to a network until it has been configured with 
> >  	one or more properties for the target network, for example configuring 
> > -	the network SSID.  Default is 1 (auto-associate)
> > +	the network SSID.  Default is 0 (do not auto-associate)
> >  	
> >  	Example: % modprobe ipw2200 associate=0
> >  
> > diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
> > index dcce354..eb1230e 100644
> > --- a/drivers/net/wireless/ipw2200.c
> > +++ b/drivers/net/wireless/ipw2200.c
> > @@ -87,7 +87,7 @@ static int channel = 0;
> >  static int mode = 0;
> >  
> >  static u32 ipw_debug_level;
> > -static int associate = 1;
> > +static int associate;
> >  static int auto_create = 1;
> >  static int led = 0;
> >  static int disable = 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

