Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:43329 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZLAV0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 16:26:49 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: RTL8187 warnings on suspend
Date: Tue, 1 Dec 2009 19:26:52 -0200
Cc: htl10@users.sourceforge.net, Michael Buesch <mb@bu3sch.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <665313.63774.qm@web23102.mail.ird.yahoo.com> <200912011149.49427.herton@mandriva.com.br> <4B15785C.30603@lwfinger.net>
In-Reply-To: <4B15785C.30603@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200912011926.52595.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Ter 01 Dez 2009, às 18:11:08, Larry Finger escreveu:
> On 12/01/2009 07:49 AM, Herton Ronaldo Krzesinski wrote:
> > Michael Buesch reports that his rtl8187 gives warnings on suspend
> > ("queueing ieee80211 work while going to suspend" warnings), as rtl8187
> > can call ieee80211_queue_delayed_work after mac80211 is suspended.
> > 
> > This change enhances rtl8187 led code so we can avoid queuing work after
> > mac80211 is suspended: now we register a radio led and make additional
> > checks to ensure led is off/on properly as mac80211 wants.
> > 
> > Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > ---
> 
> NACK. After a few minutes of a rmmod/insmod infinite loop, I go a kernel
> oops. I did not capture any of the details.

I can't reproduce here, can you get the oops? Currently I can't guess which is
missing, I reviewed patch again and can't found anything which could cause the
issue. Also how is your rmmod/insmod (with ifconfig up involved etc.)?

> 
> Larry
> 

-- 
[]'s
Herton
