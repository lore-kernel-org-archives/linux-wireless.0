Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56803 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933479Ab2BBWJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 17:09:11 -0500
Received: by vbjk17 with SMTP id k17so2129482vbj.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 14:09:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328112335-19265-2-git-send-email-rmanohar@qca.qualcomm.com>
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1328112335-19265-2-git-send-email-rmanohar@qca.qualcomm.com>
Date: Thu, 2 Feb 2012 14:09:10 -0800
Message-ID: <CAJ-Vmon56yyyvU46oXBJaFpUcFWa0008S5tyBm31qTY5y2CO+g@mail.gmail.com> (sfid-20120202_230918_845362_0098D8FB)
Subject: Re: [PATCH 2/2] ath9k_hw: improve ANI processing and rx desensitizing parameters
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>,
	Susinder Gulasekaran <susinder@qca.qualcomm.com>,
	Suresh Chandrasekaran <csuresh@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, questions below:

On 1 February 2012 08:05, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
>
> This patch improves ANI operations by switching among the immunity
> levels based on PHY errors and beacon rssi which will adjust receiver
> desensitizing parameters. The changes are

What environments are you seeing this bad behaviour in? I'd just like
to be sure that this won't mess up the behaviour of ANI for other
chips, other environments and other operating modes.

> * Irrespective of opmode, the Weak Signal Detection is with the current
>  immunity level value.

I didn't think that weak signal detection was a single bit in the PHY.
It looks like you've just deleted all the threshold settings and are
turning on/off using low self correlation.

Have a read of the (very early, AR5212 era?) ANI patent:

http://www.freepatentsonline.com/7349503.pdf

If this has changed (ie, if in Osprey it's done differently) then it
should likely be documented in the driver somewhere.

IF this all works then great, but I'd really like to try and better
understand/document the "why" aspects of it. ANI is .. fiddly, and
there aren't any tools available for ath9k (+freebsd) wireless
developers to really understand the impact of ANI.

Thanks,



Adrian
