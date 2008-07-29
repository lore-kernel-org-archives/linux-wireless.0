Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:45156 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYG2DV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 23:21:56 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Date: Tue, 29 Jul 2008 00:21:45 -0300
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net> <48874F09.7060400@lwfinger.net> <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
In-Reply-To: <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807290021.45400.herton@mandriva.com.br> (sfid-20080729_052159_314718_536A1FFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Monday 28 July 2008 23:39:26 Hin-Tak Leung escreveu:
> Hi Larry, please tidy the tx seq no patch up and submit to
> wireless-testing.. I think it is more appropriate to copy the actual
> comments in rt2000 from Johannes?
> instead of or in addtion to: "XXX: This sequence is an attempt to
> match what happens in r2x00"
>
> ... and feel free to add ack-by/tested-by me.
>
> I am wondering about Herton's problem with power saving (which I had
> reproduced).
> I think one way to move forward is to enable MAC80211_PS_DEBUG(?) and
> see what happens
> to the tx queues, now that we have a reliable way of reproducing the
> problem.

I enabled here CONFIG_MAC80211_VERBOSE_PS_DEBUG but didn't got anything 
useful. I looked at the code for some time and until now no idea on what is 
happening.

>
> I also wonder how Herton encountered the problem :-). Older
> wireless-testing simply
> say "unimplemented" or something if one tries to set power-saving.
> Maybe Herton has
> a few devices which he routinely tries out every part of iwconfig?

The original sequence of commands:
[1] /sbin/ip link set dev wlan0 down
[2] /sbin/ip link set dev wlan0 up
[3] /sbin/iwconfig wlan0 power on
[4] /sbin/iwconfig wlan0 essid any
[5] /sbin/iwconfig wlan0 power on
[6] /sbin/iwconfig wlan0 essid <my AP>
[7] /sbin/iwconfig wlan0 key open <my key>
That show the issue on rtl8187b I have to test just is near on what Mandriva 
2008.0 ifup-wireless script does, so that's what first made me catch the bug. 
the '... power on' after '... essid any' is what causes later the association 
or any scan attempt to fail, if I place a sleep between [4] and [5] I don't 
get the problem too. The problem is, I couldn't see yet how a power on after 
essid any could cause this.

>
> Hin-Tak
>

-- 
[]'s
Herton
