Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:19146 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbXJVSNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 14:13:12 -0400
Received: by py-out-1112.google.com with SMTP id u77so2622042pyb
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2007 11:13:01 -0700 (PDT)
Message-ID: <40f31dec0710221113h79301530pad834f1825989656@mail.gmail.com> (sfid-20071022_191352_809464_C91FD634)
Date: Mon, 22 Oct 2007 18:13:01 +0000
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [ath5k] Help needed for Trust Speedshare Turbo Pro (PCMCIA)
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200710221925.37758.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200710211316.06772.elendil@planet.nl>
	 <200710221848.27985.elendil@planet.nl>
	 <43e72e890710221011p2b2f66d8w3f341bec068e49f1@mail.gmail.com>
	 <200710221925.37758.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/22, Frans Pop <elendil@planet.nl>:
> On Monday 22 October 2007, Luis R. Rodriguez wrote:
> > >  -==Device Information==-
> > > MAC Version:  5212 (0x50)
> > > MAC Revision: 5213A(0x59)
> > > PHY Revision: 5110 (0x0)
> > > PHY Revision: 5110 (0x0)
> >
> > This is the problem. ath5k currently assumes only AR5210s (which are
> > 802.11a only capable) have an RF5110. This is also an 802.11bg card.
> > Essentially support for this is on the TODO list. For now we'll have
> > to just detect this and inform users the card is not supported yet.
>
> OK. Thanks for the info.
> I'd gotten the impression that the driver was a bit further along. No
> problem though. I'll just stay alert for announcements.
>
> Cheers,
> FJP
> -

Your card is a 5213 and doesn't have 5110 PHY (it's a bug in ath_info
i'm working on it -it reports phy version id = 0 sometimes and that
matches 5110's version id, ath5k doesn't hve that bug), problem is
that it is a b/g only card and we didn't have such cards to test. I'll
send some patches soon that might fix b/g only PHYs but i can't
guarantee anything ;-(


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
