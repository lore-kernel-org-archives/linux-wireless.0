Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42889 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162202Ab3DERhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 13:37:04 -0400
Received: by mail-wg0-f50.google.com with SMTP id k13so3982126wgh.17
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 10:37:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomFi1fq6GY2dCpJCGN-sfmaH+FEu0V1nCjc7MymT6f3Rg@mail.gmail.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com>
	<1365131280.68622.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-VmokqjXqkJEN1cwgsOcJ7p8cvCsRxUG8Qc9gE8fWXaq+E0g@mail.gmail.com>
	<1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-VmonhbW06GU30S9oKYTEvbum2WbY63Y07tvS=ZQJcB6o+Dg@mail.gmail.com>
	<1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<20830.46610.23754.783231@gargle.gargle.HOWL>
	<1365175482.75704.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-VmomFi1fq6GY2dCpJCGN-sfmaH+FEu0V1nCjc7MymT6f3Rg@mail.gmail.com>
Date: Fri, 5 Apr 2013 10:37:02 -0700
Message-ID: <CAJ-Vmo=uvZbUtKE5Pk=saipVLRfmrU6jQeEvCg2kULP6F+d6cg@mail.gmail.com> (sfid-20130405_193709_423559_CFEC3032)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, so what I've discovered:

The weight registers in pre-ar9300 chips are pairs of 2 bit registers
that map to some internal state inside the MAC.

Ie, if state is "X", then weight is "Y".

The MAC then compares the WLAN and BT weights; if WLAN >= BT, WLAN wins.

I'll see if I can polish this up and dump some register description
online for these coexistence registers. There's only like, 3 major
ones for AR9285/AR9287 (and then various ancillaries) that are
involved in basic BT coexistence.

AR9380 and later have larger weight tables because (a) their weight
values are bigger than 2 bits I Think? and (b) there's more internal
states to take into account. But 2-wire and 3-wire coexistence is
essentially the same. MCI (with lots of message passing around) is
where that changed.

Thanks,



Adrian
