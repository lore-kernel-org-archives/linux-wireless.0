Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:35894 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751379AbYAWVk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 16:40:27 -0500
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] rfkill: add the WiMAX radio type
Date: Wed, 23 Jan 2008 13:38:53 -0800
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
References: <200801231324.39483.inaky@linux.intel.com> <200801232230.39590.IvDoorn@gmail.com>
In-Reply-To: <200801232230.39590.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801231338.53501.inaky@linux.intel.com> (sfid-20080123_214030_446294_862415E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Ouch, I forgot to CC Dimitry :( My apologies

On Wednesday 23 January 2008, Ivo van Doorn wrote:
> On Wednesday 23 January 2008, Inaky Perez-Gonzalez wrote:
> > rfkill: add the WiMAX radio type
> > 
> > Teach rfkill about wimax radios.
> > 
> > Had to define a KEY_WIMAX as a 'key for disabling only wimax radios',
> > as other radio technologies have. This makes sense as hardware has
> > specific keys for disabling specific radios.
> > 
> > The RFKILL enabling part is, otherwise, a copy and paste of any other
> > radio technology. 
> > 
> > Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
> 
> For the rfkill part of the patch:
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Dimitry, are you ok with the include/linux/input.h part \
of the patch below (chopped); full version at 

http://marc.info/?l=linux-wireless&m=120112423923171&w=2

> 
> > ---
> > 
> > diff -r a52d5e9e9c91 include/linux/input.h
> > --- a/include/linux/input.h	Mon Jan 14 16:13:06 2008 -0800
> > +++ b/include/linux/input.h	Mon Jan 14 16:23:40 2008 -0800
> > @@ -362,6 +362,8 @@ struct input_absinfo {
> >  #define KEY_BRIGHTNESS_CYCLE	243	/* brightness up, after max is min */
> >  #define KEY_BRIGHTNESS_ZERO	244	/* brightness off, use ambient */
> >  #define KEY_DISPLAY_OFF		245	/* display device to off state */
> > +
> > +#define KEY_WIMAX		246
> >  
> >  #define BTN_MISC		0x100
> >  #define BTN_0			0x100
> > diff -r a52d5e9e9c91 include/linux/rfkill.h

