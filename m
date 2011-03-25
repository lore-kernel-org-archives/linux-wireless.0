Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51455 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab1CYRGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 13:06:41 -0400
Received: by pvg12 with SMTP id 12so175551pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2011 10:06:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D8C9BC7.3090204@googlemail.com>
References: <4D8C4764.7060107@googlemail.com>
	<20110325131957.GA2242@tuxdriver.com>
	<4D8C9BC7.3090204@googlemail.com>
Date: Fri, 25 Mar 2011 19:06:40 +0200
Message-ID: <AANLkTimSazKeRJ0d58ik6WsY+jERuutvaLONKzKgR=xg@mail.gmail.com>
Subject: Re: Disabling ACKs with ath5k
From: Nick Kossifidis <mickflemm@gmail.com>
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/25 Dennis Borgmann <dennis.borgmann@googlemail.com>:
> Hello John,
>
> the goal would be to have a transmission as fast as possible while
> ignoring, if a packet reached its destination or not. I'd like to test
> wireless performance regarding transmission time in a dedicated
> environment. As far as I can see, backoff might already push the
> transmission times up quite a lot and if I'd even add the time of -
> worst case - 10 retransmissions, the transmission time of one packet
> will grow even more.
>
> It would be second-rank, if the packet reaches its destination. Loss of
> some packets is not a problem in my testbed.
>
> So I'd like to disable usage of ACKs in order to be off with the only
> problem - backoff. Disabling this would of course be nice, but I fear,
> that's far more work that just disabling ACKs.
>
> Dennis
>

Check out these flags...

AR5K_TXDESC_NOACK (set it on each tx descriptor to disable ACKs for
each frames -we do this for beacons already, check out base.c)

AR5K_TXQ_FLAG_BACKOFF_DISABLE (set it when initializing queues, see
how we handle the rest _TXQ_ flags on base.c)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
