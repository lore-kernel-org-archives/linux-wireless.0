Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:62471 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935026Ab3BTUZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 15:25:41 -0500
Received: by mail-ie0-f175.google.com with SMTP id c12so10295776ieb.20
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2013 12:25:41 -0800 (PST)
Date: Wed, 20 Feb 2013 15:25:24 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: devel@lists.open80211s.org, Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
Message-ID: <20130220202524.GC21725@localhost> (sfid-20130220_212547_885714_5138D4A2)
References: <alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
 <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
 <20771.50338.434076.484711@gargle.gargle.HOWL>
 <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com>
 <20771.51233.248133.141840@gargle.gargle.HOWL>
 <alpine.DEB.2.02.1302192258510.19584@icf.org.ru>
 <CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com>
 <alpine.DEB.2.02.1302200027120.19533@icf.org.ru>
 <20130220142401.GA21725@localhost>
 <alpine.DEB.2.02.1302202351280.2057@icf.org.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.02.1302202351280.2057@icf.org.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2013 at 11:55:14PM +0400, Georgiewskiy Yuriy wrote:
> i think yes, but i dont understand what exactly do this signal processing and why it needed,
> i find the source of this changes - http://www.spinics.net/lists/linux-wireless/msg35905.html, 
> but there is no explain too.

Yeah, me neither, but just going on the macros:

> +#define ATH_RSSI_IN(x)             (ATH_EP_MUL((x),
> ATH_RSSI_EP_MULTIPLIER))

That takes the value read from the card, and multiplies it by
ATH_RSSI_EP_MULTIPLIER, which is 1<<7.  So now it's in fixed-point
with a 6-bit fractional part.

> +#define ATH_LPF_RSSI(x, y, len) \
> +    ((x != ATH_RSSI_DUMMY_MARKER) ? (((x) * ((len) - 1) + (y)) / (len))
> : (y))

Low pass filter, aka moving average.  So rssi values are first moved into
fixed point range, some averaging is done on the samples, presumably to
reduce the variance, then the result is rounded back into non-fractional
units.

((x + m/2)/m is the fixed point version of int(x + 0.5) if 'm' is the
representation of 1.0 in fixed point.

-- 
Bob Copeland %% www.bobcopeland.com
