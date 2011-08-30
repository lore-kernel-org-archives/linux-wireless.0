Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52734 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1H3Jlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:41:42 -0400
Received: by wwe5 with SMTP id 5so3212829wwe.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 02:41:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn2Reu+T=g6HwdQT5cdkD0C-06y7GJ_B2q-UzpRnshxAWw@mail.gmail.com>
References: <CAD2nsn2Bbxxy9ZYpBe_QEqCkGYYROHE+j7qASRq3OkKmWD5PMg@mail.gmail.com>
	<CAD2nsn1+5QWtzeG-3RHEJi8+oDthAfXYunHnDTLie84oJPOQuw@mail.gmail.com>
	<CAD2nsn1roVNB5+H1CYHVnerLN3pjGB5KmEX1mJZ4yJhHqFGOVA@mail.gmail.com>
	<20110830064137.GA4719@ecki>
	<CAD2nsn2Reu+T=g6HwdQT5cdkD0C-06y7GJ_B2q-UzpRnshxAWw@mail.gmail.com>
Date: Tue, 30 Aug 2011 15:11:40 +0530
Message-ID: <CAD2nsn3nzEOY6Mxbd7CPLGR96x1KmVCdnizN-3ypCJ3G5suxcA@mail.gmail.com> (sfid-20110830_114145_426972_99387A07)
Subject: Re: ath9k: irq storm after suspend/resume
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Clemens Buchacher <drizzd@aon.at>
Cc: linux-wireless@vger.kernel.org, beta992@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> yes it is, though not a good idea, just thinking of we could get some
> thing by not setting SC_OP_INVALID flag in ath_pci_probe(it was added
> to fix a panic, but it did not cause panic for me now).

sorry please don't try it, not setting the SC_OP_INVALID flag in
ath_pci_probe, the system did panic.

>
>>
>>        if (sc->sc_flags & SC_OP_INVALID)
>>                return IRQ_NONE;
>>
