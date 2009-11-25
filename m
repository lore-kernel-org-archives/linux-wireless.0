Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:43266 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935074AbZKYVoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 16:44:21 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: RTL8187 warnings on suspend
Date: Wed, 25 Nov 2009 19:44:25 -0200
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200911251626.15959.mb@bu3sch.de> <200911251755.00596.herton@mandriva.com.br> <200911252157.41899.mb@bu3sch.de>
In-Reply-To: <200911252157.41899.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911251944.25381.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Qua 25 Nov 2009, às 18:57:40, Michael Buesch escreveu:
> On Wednesday 25 November 2009 20:55:00 Herton Ronaldo Krzesinski wrote:
> > Em Qua 25 Nov 2009, às 17:29:21, Michael Buesch escreveu:
> > > On Wednesday 25 November 2009 19:25:39 Herton Ronaldo Krzesinski wrote:
> > > > of the led inside rtl8187_leds_exit, like the patch below, could you try it?
> > > 
> > > Does not completely fix it
> > 
> > Indeed, ieee80211_queue_delayed_work run also in rtl8187_led_brightness_set...
> > my patch didn't fix anything... I think the only way is starting and stopping
> > leds in start and stop, the following patch should do it:
> 
> That completely crashes the machine on suspend. I can take a picture of the crash,
> but I guess you can easily reproduce it...

Hmm strange, reviewing it now I only see a missing #ifdef CONFIG_RTL8187_LEDS
around rtl8187_leds_start inside rtl8187_start. Despite it, the patch worked
here, may be something I'm not seeing...

--
[]'s
Herton
