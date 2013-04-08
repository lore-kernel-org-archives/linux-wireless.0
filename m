Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:64263 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971Ab3DHSjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:39:22 -0400
Received: by mail-we0-f170.google.com with SMTP id z2so4992954wey.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 11:39:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365433751.96373.YahooMailNeo@web193505.mail.sg3.yahoo.com>
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
	<CAJ-Vmo=uvZbUtKE5Pk=saipVLRfmrU6jQeEvCg2kULP6F+d6cg@mail.gmail.com>
	<CAJ-VmomYF3ziqhykXMK5U+SJPYiNWmijdf0VhKDK33BVbSKNrQ@mail.gmail.com>
	<1365346495.79596.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<1365398445.32740.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmomGT4grPwA0dSGqPD=Zi=dZk6WwpqKEXXDvfLUqr08o0w@mail.gmail.com>
	<1365413949.24195.YahooMailNeo@web193502.mail.sg3.yahoo.com>
	<1365433751.96373.YahooMailNeo@web193505.mail.sg3.yahoo.com>
Date: Mon, 8 Apr 2013 11:39:20 -0700
Message-ID: <CAJ-Vmon4K_sFR3JP47YGP13HtepEg=mt3=Y8nQX8fV+cdFZ5rg@mail.gmail.com> (sfid-20130408_203926_536471_99A9C12B)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

yes, there's GPIO MUX modes for:

* RX clear (but I think this "Wlan active" pin is likely triggering on
RX_CLEAR, which I think gets asserted for both TX and RX busy. I'll
have to check.
* TX active

Check the GPIO MUX pin definitions to see.

But if I understand this right, if you have the correct btcoex setup
and GPIO pins working, then stomping traffic will stomp both TX and
RX..


Adrian
