Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:61559 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934804Ab3DJXUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 19:20:23 -0400
Received: by mail-we0-f171.google.com with SMTP id d46so793475wer.30
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 16:20:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5165E1C2.4020407@net.t-labs.tu-berlin.de>
References: <5165E1C2.4020407@net.t-labs.tu-berlin.de>
Date: Wed, 10 Apr 2013 16:20:21 -0700
Message-ID: <CAJ-Vmo=boxae6Cs+yDerTCGOa=rq-dZeNLeTjGjroBMxwsfU4A@mail.gmail.com> (sfid-20130411_012030_769772_88625B63)
Subject: Re: [RFC] ath9k: Respect current txpower setting
From: Adrian Chadd <adrian@freebsd.org>
To: Tobias Steinicke <tobias.steinicke@net.t-labs.tu-berlin.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 April 2013 15:03, Tobias Steinicke
<tobias.steinicke@net.t-labs.tu-berlin.de> wrote:
> In routine ath_tx_fill_desc(), the txpower is only set to
> MAX_RATE_POWER. Now it respects the txpower from bss_conf and set it if it
> is (txpower * 2) < MAX_RATE_POWER else set to MAX_RATE_POWER.

This doesn't do anything unless TPC is enabled.

And if TPC is enabled, you have to jump through hoops to set the
correct target TX power, as it's not always 1:1 between dBm value
programmed in and dBm value transmitted.



Adrian
