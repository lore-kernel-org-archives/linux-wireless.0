Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:13891 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbXJVRLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 13:11:11 -0400
Received: by py-out-1112.google.com with SMTP id u77so2584206pyb
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2007 10:11:10 -0700 (PDT)
Message-ID: <43e72e890710221011p2b2f66d8w3f341bec068e49f1@mail.gmail.com> (sfid-20071022_181119_132527_A250B414)
Date: Mon, 22 Oct 2007 13:11:10 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [ath5k] Help needed for Trust Speedshare Turbo Pro (PCMCIA)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710221848.27985.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200710211316.06772.elendil@planet.nl>
	 <43e72e890710220827k2aa7a8d9m3653ec51ff461b32@mail.gmail.com>
	 <200710221848.27985.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/07, Frans Pop <elendil@planet.nl> wrote:
> On Monday 22 October 2007, Luis R. Rodriguez wrote:
> > Get this line again from lspci, and for example if its 30000000 again
> > run from madwifi:
> >
> > ./tools/ath_info 0x30000000
>
> That results in:
>
>  -==Device Information==-
> MAC Version:  5212 (0x50)
> MAC Revision: 5213A(0x59)
> PHY Revision: 5110 (0x0)
> PHY Revision: 5110 (0x0)

This is the problem. ath5k currently assumes only AR5210s (which are
802.11a only capable) have an RF5110. This is also an 802.11bg card.
Essentially support for this is on the TODO list. For now we'll have
to just detect this and inform users the card is not supported yet.

  Luis
