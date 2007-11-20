Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:62776 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758900AbXKTQTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 11:19:12 -0500
Received: by rn-out-0102.google.com with SMTP id s46so2928709rnb
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2007 08:19:11 -0800 (PST)
Message-ID: <40f31dec0711200819p3ef7d5a1p30437f39974d22b8@mail.gmail.com> (sfid-20071120_161916_425055_099DF189)
Date: Tue, 20 Nov 2007 18:19:11 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Francesco Gringoli" <francesco.gringoli@ing.unibs.it>
Subject: Re: ath5k driver on MIPS and low level control over the hw
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <E7E9AC02-E136-48B7-8E39-3419B36B6575@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <E7E9AC02-E136-48B7-8E39-3419B36B6575@ing.unibs.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I would like also to report that I did a very simple test connecting
> a couple of Atheros card with a coaxial cable (impedances adapted and
> both systems are connected to the same ground). The two PCs involved
> are running x86 Linux 2.6.24-rc2 when using ath5k and Linux 2.6.23
> when using standard Madwifi code. I see that independently of the
> channel rate (from 1Mb/s to 54Mb/s) I always get better performances
> with standard Madwifi code. Could this depend on how queues are
> handled on the ath5k code?
>
> Regards,
> FG
>

Not only queues but mostly tx power setting imho, we don't initialize
phy properly if we don't set tx power the right way. Madwifi/binary
hal knows how to propertly initialize phy so it has better performace
over ath5k. This is mostly seen in OFDM operation (a/g).


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
