Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23105.mail.ird.yahoo.com ([217.146.189.45]:22510 "HELO
	web23105.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966675AbZLHWS1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:18:27 -0500
Message-ID: <685962.23975.qm@web23105.mail.ird.yahoo.com>
Date: Tue, 8 Dec 2009 22:18:32 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT] rtl8187: Fix 'queuing ieee80211 work while going to suspend' warning
To: Michael Buesch <mb@bu3sch.de>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200912081341.20682.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 8/12/09, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:


> The problem here is not simple: we have leds code
> triggering work and mac80211 
> scheduling led tx work even after radio led stop on device
> shutdown:
> - On unregistering led device, even after mac80211 did the
> work to turn off the 
> led, the unregister code of led subsystem calls again
> led_brightness_set to 
> turn off the led, which causes the original warning without
> suspend/resume 
> hooks (also in leds_exit code we were scheduling work which
> triggered more 
> warnings).
> - When I was testing, sometimes mac80211 on device shutdown
> (modprobe -r) 
> wasn't calling led stop code in the right order, so
> sometimes after removing 
> module the led was kept turned on (scheduling led tx code
> after led radio off). 
> This happens because ieee80211_tx_status can call
> ieee80211_led_tx after 
> mac80211 calls ieee80211_led_radio to turn the led off, and
> as we are 
> "emulating" a radio led (we have only one real led to
> signal radio and tx/rx, 
> no differentiation on hardware) we are affected by this.
> 
> So besides registering the radio led, I had to add that
> radio_on variable 
> check on last patch, to handle these two problems. The
> patch worked, but Larry 
> reported a crash, I'll try to review it more and see what
> could cause a crash 
> on removal, may be some delayed_work related thing missing,
> unfortunately I'm 
> a bit busy here since then, but will try to get to it
> soon.

Sorry I haven't been paying too much attention due to other commitments... that sounds like race condition somewhere. Besides adding flag variables, would mutex help?


      
