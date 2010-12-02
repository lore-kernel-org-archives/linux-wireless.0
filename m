Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59566 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab0LBR71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 12:59:27 -0500
Received: by qyk11 with SMTP id 11so4222325qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 09:59:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4cf7cb25.SwkH7gALTG7E00Zb%Larry.Finger@lwfinger.net>
References: <4cf7cb25.SwkH7gALTG7E00Zb%Larry.Finger@lwfinger.net>
Date: Thu, 2 Dec 2010 18:59:25 +0100
Message-ID: <AANLkTikchuCXgBA+JqFEOUgrQFrhorP=n1UYvWOZpApp@mail.gmail.com>
Subject: Re: [RFC/RFT] ssb: Attempt to recover from SPROM CRC error
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/2 Larry Finger <Larry.Finger@lwfinger.net>:
> +                       revision = buf[SSB_SPROMSIZE_WORDS_R4 - 1] & 0x00FF;

Should we define macro for that, to do not duplicate code from this part:
sprom_extract(...):
out->revision = in[size - 1] & 0x00FF;
?

I don't vote for any solution, but maybe one should be preferred and
you just didn't notice that? I noone have problem with this liiitle
duplication, ignore me ;)

-- 
Rafał
