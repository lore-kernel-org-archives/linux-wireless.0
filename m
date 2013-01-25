Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:57072 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3AYVzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 16:55:43 -0500
Received: by mail-we0-f179.google.com with SMTP id x43so405761wey.38
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 13:55:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5102D0C7.50907@candelatech.com>
References: <5102CADE.2010900@candelatech.com>
	<CA+yqC4b2_q5Nn2t7C-5JdAfxR-QA8KtBgqE_sw91ZfNwt-k+LQ@mail.gmail.com>
	<5102D0C7.50907@candelatech.com>
Date: Fri, 25 Jan 2013 13:55:42 -0800
Message-ID: <CAJ-VmonmYNGK42DuCLStjvSswdvkzeHUAwH+fsZQL5BdxwGgjA@mail.gmail.com> (sfid-20130125_225547_522884_0116A82C)
Subject: Re: Increasing throughput on 3-radio system?
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Sam Leffler <sleffler@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Strong enough out of band RF is still going to bleed over and it may
saturate the receive amplifiers before it hits the chip and the
configurable analog band-pass filter.

Hence the suggestion to always TX at the same time. That way you don't
have the problem of TX from one radio being strong enough to
saturation. You can tune the PHY (via magic handwavy parameters that
strangely enough are partially described in the ANI code :-) to reduce
its sensitivity to blocker signals, but it doesn't help you if the
signal is close enough by to trigger the wideband / out of band
interference check. If you try and receive during that you're going to
have very poor behaviour.

Thanks,



Adrian
