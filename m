Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:33648 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbYG3SLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 14:11:05 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC/RFT] rtl8187: Protect the config callback from mac80211 with a mutex
Date: Wed, 30 Jul 2008 15:11:11 -0300
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48900654.7030100@lwfinger.net> <200807301413.53059.herton@mandriva.com.br> <200807301946.41182.mb@bu3sch.de>
In-Reply-To: <200807301946.41182.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807301511.12267.herton@mandriva.com.br> (sfid-20080730_201111_110254_5E826663)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Wednesday 30 July 2008 14:46:40 Michael Buesch escreveu:
> On Wednesday 30 July 2008 19:13:52 Herton Ronaldo Krzesinski wrote:
> > > Yeah, I said exactly that.
> > > You protect the loopback stuff. Not any config callback or anything else.
> > 
> > Ah ok, only protect the section, like this?
> 
> Yeah, well. In theory, yes. In practice: Aren't there other races possible, too?
> I mean even races with other parts of the driver.
> b43 needs to take the global driver mutex in the conf callback to make
> sure nothing changes (device init state probably is the most important one.
> Device going down while configuring would be a fatal crash).

In practice I don't get other problems, but better to stick to the patch posted
by Larry, like he said to avoid config data from one call mixed to the other.
rtl8187 is more simpler, besides this issue with configuration it all depends
on how mac80211 calls another functions, I have yet to see but doesn't look like
a general lock is needed.

> 
> So in b43 we have a global mutex which protects everything (all data
> and all device state), except the data and state that's accessed in the IRQ paths.
> (We have more locks for shared device memory and so on... But these are nested
> inside of the mutex or the IRQ state lock)
> 

-- 
[]'s
Herton
