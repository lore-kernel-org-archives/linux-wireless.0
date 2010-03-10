Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:23060 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0CJFuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:50:21 -0500
Subject: Re: [PATCH 20/22] wl1271: Clean up TX security sequence number
 handling
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Kalle Valo <kalle.valo@iki.fi>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <878wa1dy0u.fsf@purkki.valot.fi>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1266820722-20202-21-git-send-email-juuso.oikarinen@nokia.com>
	 <878wa1dy0u.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 07:47:29 +0200
Message-ID: <1268200049.10120.455.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-09 at 21:45 +0100, ext Kalle Valo wrote:
> Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:
> 
> > Instead of managing the TX security sequence number as two variables, use
> > one 64 bit variable. This greatly simplifies the handling of the number.
> 
> [...]
> 
> > -	u16 tx_security_seq_16;
> > -	u32 tx_security_seq_32;
> > +	s64 tx_security_seq;
> 
> I'm curious, why s64 and not u64? I'm sure there's a good reason, I
> just wasn't able figure it out.
> 

Hi, good question. I don't remember the reasoning either.

Good news is that we only need the first 48 bits, so it shouldn't matter
so much.

-Juuso

