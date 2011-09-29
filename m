Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41749 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1I2Kdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 06:33:43 -0400
Received: by gyg10 with SMTP id 10so380487gyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 03:33:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn3ZwUJsFRLyjKenO6Pm3+jr9gfmAMRDQPStEcC1hN_mkw@mail.gmail.com>
References: <CAD2nsn2Bbxxy9ZYpBe_QEqCkGYYROHE+j7qASRq3OkKmWD5PMg@mail.gmail.com>
	<CAD2nsn1+5QWtzeG-3RHEJi8+oDthAfXYunHnDTLie84oJPOQuw@mail.gmail.com>
	<CAD2nsn1roVNB5+H1CYHVnerLN3pjGB5KmEX1mJZ4yJhHqFGOVA@mail.gmail.com>
	<20110830064137.GA4719@ecki>
	<CAD2nsn2Reu+T=g6HwdQT5cdkD0C-06y7GJ_B2q-UzpRnshxAWw@mail.gmail.com>
	<14be9f3b-4c91-481d-9e52-f3119659fd59@email.android.com>
	<CAD2nsn1+WVaLR_TR37Z6YRCFnQH1hJkSOri=nxc8Ff3pa9N8dw@mail.gmail.com>
	<20110927214245.GA1416@ecki>
	<CAD2nsn3ZwUJsFRLyjKenO6Pm3+jr9gfmAMRDQPStEcC1hN_mkw@mail.gmail.com>
Date: Thu, 29 Sep 2011 18:33:42 +0800
Message-ID: <CAJ-Vmok8FvrYtT2QwXY0NowLSogfkZYNbGLFbVR8Uzv507FrdA@mail.gmail.com> (sfid-20110929_123356_162506_D20DF93F)
Subject: Re: ath9k: irq storm after suspend/resume
From: Adrian Chadd <adrian@freebsd.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Clemens Buchacher <drizzd@aon.at>, linux-wireless@vger.kernel.org,
	beta992@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hm,

Has someone figured out which ISR bits are being triggered?

If not, I can likely whip up a patch which adds some relevant
printk's. I think it's worth establishing:

* is it a sync/async interrupt;
* is it a fatal interrupt (eg something like a PCI bus error or
transaction timeout) or is it a normal ISR bit that keeps firing;
* .. and which one is firing.


Adrian
