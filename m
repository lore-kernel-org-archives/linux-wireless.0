Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:37899 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYGVWkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 18:40:02 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: [RFC/RFT] rtl8187: Improve wireless statistics for RTL8187B
Date: Tue, 22 Jul 2008 19:40:18 -0300
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net> <200807221613.34434.herton@mandriva.com.br> <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
In-Reply-To: <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807221940.20009.herton@mandriva.com.br> (sfid-20080723_004007_519668_E2F93831)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Tuesday 22 July 2008 19:25:20 Hin-Tak Leung escreveu:
> On Tue, Jul 22, 2008 at 8:13 PM, Herton Ronaldo Krzesinski
> <herton@mandriva.com.br> wrote:
> <snipped>
>
> > I got some time to take at a look at it again, I did the bisect and found
> > commit 8f87dd7e540d455f8e7f11478133b85edc969c67 ("mac80211: power
> > management wext hooks") to cause the issue here (non working interface).
> > But with it, making "iwconfig wlan* power off" and making interface go up
> > again, it starts to work. May be something related to the power
> > management needs to be implemented in driver now? or keep it disabled
> > with rtl8187...
>
> Disabling power management doesn't improve the situation with latest
> wireless testing
> for me. I had a look at the change and it seems simple enough.

Yes, I also looked at the commit, it's simple and I can't see how it's 
affecting transmission in my case. It's bizarre and I must be doing something 
wrong.

>
> The latest vendor driver has a lot of suspend/resume code in it. I
> have had a go at
> trying to get it running against a current kernel. modprobe works but
> ifconfig up results in a lot
>
> rtl8187: EE:cannot submit RX command. URB_STATUS 0
>
> Hin-Tak

-- 
[]'s
Herton
