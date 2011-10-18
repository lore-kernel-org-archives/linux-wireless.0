Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65362 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab1JRHFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 03:05:38 -0400
Received: by yxp4 with SMTP id 4so284521yxp.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 00:05:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111018064459.GA1442@ecki>
References: <CAJ-VmokcM4KmzV7Rn9PA68iEiTJiPw=ffYgNFLDAHShxD0HNAg@mail.gmail.com>
	<20111003084823.GA1521@ecki.lan>
	<CAJ-Vmo=sE4KeOp1CKAR5v+Rzm1bm0R=ZvtMvJaE_8Sjn1dOdsw@mail.gmail.com>
	<20111004181534.GA1502@ecki>
	<CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
	<20111005062528.GA1403@ecki>
	<CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
	<CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
	<20111015093902.GA23520@ecki>
	<CAJ-VmokQBcXyDByWgMfGRFvW_z_9YU4oPUrXJpfPY9J4riEuBQ@mail.gmail.com>
	<20111018064459.GA1442@ecki>
Date: Tue, 18 Oct 2011 15:05:38 +0800
Message-ID: <CAJ-Vmo=Qt3rGDbM0yOvFuz6Pksdx9bdm8HEBnhfjP6=zjGOgTA@mail.gmail.com> (sfid-20111018_090542_161778_9960684C)
Subject: Re: ath9k: irq storm after suspend/resume
From: Adrian Chadd <adrian@freebsd.org>
To: Clemens Buchacher <drizzd@aon.at>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hm, which version of the AR9285 is it, exactly?
Would you just do a quick check (or code hack) and see if it matches
the AR_SREV_9285SE_20 (or similar) macro?

(I see a WAR in the reference code for that particular model AR9285,
that isn't in ath9k.)

I'm honestly still not convinced that it's (soley) the AR9285. You
_could_ do something naughty like disabling all interrupts and then
powering off the NIC (but not detaching it from the bus glue, like
unloading the module does.)

Good luck,


Adrian
