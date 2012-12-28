Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51250 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2L1DLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 22:11:14 -0500
Received: by mail-wi0-f172.google.com with SMTP id o1so7979801wic.17
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2012 19:11:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121218134611.GA7053@pandem0nium>
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<20121213140753.GA26868@pandem0nium>
	<50D04EC9.2040805@neratec.com>
	<20121218134611.GA7053@pandem0nium>
Date: Thu, 27 Dec 2012 19:11:12 -0800
Message-ID: <CAJ-Vmo=MzOVgk45fcSKeA5Kj-8x9zMUE=Ld-u4D1qLQSjMGBoA@mail.gmail.com> (sfid-20121228_041118_205510_F136D0E3)
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>, nbd@openwrt.org,
	jonbither@gmail.com, kgiori@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 December 2012 05:46, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:

>> As for the incorrect data, there are 4 cases to consider:
>> 1) data length is correct => take the 56 bins as is
>> 2) data length is 1 less => duplicate the first bin
>> 3) data length is 2 more => remove bins 30 and 32
>> 4) data length is 1 more => combine 2) + 3)
>
> ... didn't see THAT coming. But that explains it very well how to
> handle these varying data lengths. Although I wonder how this can happen.
> I guess there are some chip-internal reasons ...

It's a known problem. It's fixed in later silicon.

But yes, that's quite a bit of analysis by Zefir to classify and
repair those samples. Good work!


Adrian
