Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49371 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbYG3SmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 14:42:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [RFC/RFT] rtl8187: Protect the config callback from mac80211 with a mutex
Date: Wed, 30 Jul 2008 20:41:41 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48900654.7030100@lwfinger.net> <200807301946.41182.mb@bu3sch.de> <200807301511.12267.herton@mandriva.com.br>
In-Reply-To: <200807301511.12267.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807302041.41327.mb@bu3sch.de> (sfid-20080730_204217_886501_3B835D0F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 July 2008 20:11:11 Herton Ronaldo Krzesinski wrote:
> Em Wednesday 30 July 2008 14:46:40 Michael Buesch escreveu:
> > On Wednesday 30 July 2008 19:13:52 Herton Ronaldo Krzesinski wrote:
> > > > Yeah, I said exactly that.
> > > > You protect the loopback stuff. Not any config callback or anything else.
> > > 
> > > Ah ok, only protect the section, like this?
> > 
> > Yeah, well. In theory, yes. In practice: Aren't there other races possible, too?
> > I mean even races with other parts of the driver.
> > b43 needs to take the global driver mutex in the conf callback to make
> > sure nothing changes (device init state probably is the most important one.
> > Device going down while configuring would be a fatal crash).
> 
> In practice I don't get other problems, but better to stick to the patch posted
> by Larry,

Yeah, OK. I'm fine with that. I was just pointing out possible future problems.

> like he said to avoid config data from one call mixed to the other. 

Nah, we're not locking calls ;P

-- 
Greetings Michael.
