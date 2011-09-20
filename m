Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33427 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1ITLak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 07:30:40 -0400
Received: by yib18 with SMTP id 18so168563yib.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 04:30:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFtRNNxxRY4FvrrbDnuXd0PYPxfJpt6Q4rSdOw3WdofYQvJeYw@mail.gmail.com>
References: <20110919160124.GA3218@makis.lan>
	<CAD2nsn0+hMHBLW_5mtJwxfu37_f3aw-8a7Y2tCkh-btVpcfYPQ@mail.gmail.com>
	<CAFtRNNxxRY4FvrrbDnuXd0PYPxfJpt6Q4rSdOw3WdofYQvJeYw@mail.gmail.com>
Date: Tue, 20 Sep 2011 19:30:39 +0800
Message-ID: <CAJ-Vmo=1EGdz6VG1pDcpH2wsHGraGiWNz1QbLZyfpryc5fn7eg@mail.gmail.com> (sfid-20110920_133043_922364_8EBE45B2)
Subject: Re: [RFT][PATCH] ath5k: Add rfkill_disable module parameter
From: Adrian Chadd <adrian@freebsd.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I haven't read the ath5k code, but I do know the HAL code has stuff to
glue the GPIO pin in question to the baseband so it becomes a "hard"
kill.

Also, as I said privately, I think interrupt may be broken on some
NICs. Have you guys thought about doing polling to see if the GPIO pin
is actually measurably going up/down, and just not sendng an
interrupt?

(Going by conjecture/reading here; I've not tinkered with rfkill yet.)



Adrian
