Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46821 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab0AES3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 13:29:05 -0500
Received: by ewy19 with SMTP id 19so8745152ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 10:29:03 -0800 (PST)
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: infinite transmit buffering issue in 2.6.32 mac80211
References: <20100105083803.GP1735@mail.wantstofly.org>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 20:29:00 +0200
In-Reply-To: <20100105083803.GP1735@mail.wantstofly.org> (Lennert Buytenhek's message of "Tue\, 5 Jan 2010 09\:38\:03 +0100")
Message-ID: <87eim4v21f.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lennert Buytenhek <buytenh@wantstofly.org> writes:

> Hi!

Hello,

> Since "mac80211: remove master netdev", mac80211 no longer propagates
> TX queue full status (ieee80211_stop_queue et al) up.  While the
> underlying hardware's TX queue is stopped, mac80211 buffers frames
> internally (in ieee80211_tx), but there's no upper limit on the number
> of frames it will buffer, leading to badness when there is heavy TX
> traffic on the wireless interface:

We have noticed very strange throughput degration both with wl1251 and
wl1271. With 2.6.28 both drivers were able to achieve 10 Mbit/s
throughput over TCP, but with 2.6.32 (and almost the same drivers) we
get less than 4 Mbit/s. Because we see it both with wl1251 and wl1271,
we are starting to suspect that it's a problem in mac80211.

We haven't started analysing this yet, but I'm hoping someone from our
team to start it soon. I have no idea if our problem is related to the
problem Lennert reports or not, but we will definitely try Johannes'
patch and see if it helps.

-- 
Kalle Valo
