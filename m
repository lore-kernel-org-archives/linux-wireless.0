Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54935 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYG3RrP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 13:47:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [RFC/RFT] rtl8187: Protect the config callback from mac80211 with a mutex
Date: Wed, 30 Jul 2008 19:46:40 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48900654.7030100@lwfinger.net> <200807301816.37570.mb@bu3sch.de> <200807301413.53059.herton@mandriva.com.br>
In-Reply-To: <200807301413.53059.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807301946.41182.mb@bu3sch.de> (sfid-20080730_194719_360816_58996A6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 July 2008 19:13:52 Herton Ronaldo Krzesinski wrote:
> > Yeah, I said exactly that.
> > You protect the loopback stuff. Not any config callback or anything else.
> 
> Ah ok, only protect the section, like this?

Yeah, well. In theory, yes. In practice: Aren't there other races possible, too?
I mean even races with other parts of the driver.
b43 needs to take the global driver mutex in the conf callback to make
sure nothing changes (device init state probably is the most important one.
Device going down while configuring would be a fatal crash).

So in b43 we have a global mutex which protects everything (all data
and all device state), except the data and state that's accessed in the IRQ paths.
(We have more locks for shared device memory and so on... But these are nested
inside of the mutex or the IRQ state lock)

-- 
Greetings Michael.
