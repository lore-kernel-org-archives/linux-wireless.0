Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:50181 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYG2D3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 23:29:19 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Date: Tue, 29 Jul 2008 00:29:08 -0300
Cc: "Hin-Tak Leung" <hintak.leung@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net> <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com> <488E8B68.6000004@lwfinger.net>
In-Reply-To: <488E8B68.6000004@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807290029.09114.herton@mandriva.com.br> (sfid-20080729_052922_248342_96CC2827)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Tuesday 29 July 2008 00:15:52 Larry Finger escreveu:
> Hin-Tak Leung wrote:
> > Hi Larry, please tidy the tx seq no patch up and submit to
> > wireless-testing.. I think it is more appropriate to copy the actual
> > comments in rt2000 from Johannes?
> > instead of or in addtion to: "XXX: This sequence is an attempt to
> > match what happens in r2x00"
> >
> > ... and feel free to add ack-by/tested-by me.
> >
> > I am wondering about Herton's problem with power saving (which I had
> > reproduced).
> > I think one way to move forward is to enable MAC80211_PS_DEBUG(?) and
> > see what happens
> > to the tx queues, now that we have a reliable way of reproducing the
> > problem.
> >
> > I also wonder how Herton encountered the problem :-). Older
> > wireless-testing simply
> > say "unimplemented" or something if one tries to set power-saving.
> > Maybe Herton has
> > a few devices which he routinely tries out every part of iwconfig?
>
> I sent that patch on July 24, or at least I thought I did. I was quite
> surprised to not find it in the wireless archives. In any case, I have sent
> it again tonight.
>
> I tried Herton's sequence of steps for cennecting and it failed no matter
> what I did. In my case, only NetworkManager can get a connection.
>
> I'm not sure how to proceed; however, if you can produce the problem
> reliably, then you have an edge.

You mean that you couldn't reproduce the bug, ie. with the steps I gave you 
still could connect and scan for wireless networks? I ask because the failure 
is the actual bug, for example if you place let's say a sleep for 5 seconds 
between '... essid any' and '... power on' it doesn't fail.

The bug is that with that sequence, any attemps to associate or scan fail, 
where it shouldn't, at least it's what is expected.

>
> Larry

-- 
[]'s
Herton
