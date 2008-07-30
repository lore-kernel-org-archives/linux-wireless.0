Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:33800 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYG3QHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 12:07:51 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC/RFT] rtl8187: Protect the config callback from mac80211 with a mutex
Date: Wed, 30 Jul 2008 13:08:01 -0300
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48900654.7030100@lwfinger.net> <200807301153.13947.herton@mandriva.com.br> <200807301702.31281.mb@bu3sch.de>
In-Reply-To: <200807301702.31281.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807301308.01631.herton@mandriva.com.br> (sfid-20080730_180753_830801_2AB7FA7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Wednesday 30 July 2008 12:02:30 Michael Buesch escreveu:
> On Wednesday 30 July 2008 16:53:13 Herton Ronaldo Krzesinski wrote:
> > Em Wednesday 30 July 2008 10:27:26 Michael Buesch escreveu:
> > > On Wednesday 30 July 2008 15:24:40 Michael Buesch wrote:
<snip>
> > > and the mutex name, of course.
> > >
> > > 	/* Mutex to protect the device configuration data,
> > > 	 * which is foobar and bizzbaz */
> > > 	struct mutex conf_mutex;
> >
> > Yes, it's better this way. About the lock, the problem here is you can't
> > set the channel while transmitting data on 8187 (the card stops working
> > util reset like the comment on the code), so we must enable tx loopback
> > while setting channels, but you can't run rtl8187_config concurrently
> > because one instance may be disabling tx loopback while other is still
> > setting channel, or like the code is today there is a possibility that
> > you set tx loopback forever. The lock could be only in that section.
> >
> > The comment could be:
> > /* Mutex to protect the device configuration data,
> >  * we can't set channels concurrently */
>
> I think you probably want to protect the tx-loopback (enabled or disabled)
> state. That's what you're actually doing implicitely. The problem is not
> any channel concurrency or something like that, but that the
> tx-loopback-enable/disable is not recursive is the real thing we want to
> lock here, probably.

No, the issue is that I must enter in tx-loopback mode to set the channels 
inside rtl8187_config, to avoid transmission of packets, so the hardware 
doesn't halt. So that's why the lock, it must cover the entire section 
of "enable loopback"->"set_chan"->"disable loopback", not only the state of 
TX_CONF register.

>
> Note that I didn't read the code.
> But in general you get the idea. Don't lock code, but lock state data.
> (like the loopback-state data).

--
[]'s
Herton
