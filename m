Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36481 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1JVBot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 21:44:49 -0400
Received: by ggnb1 with SMTP id b1so4375712ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 18:44:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ5hJZSm4P5Vpzmi6yfF3vy2XAMKH9kE-Kv=FfDLVX9DwQC4Aw@mail.gmail.com>
References: <CAJ5hJZSm4P5Vpzmi6yfF3vy2XAMKH9kE-Kv=FfDLVX9DwQC4Aw@mail.gmail.com>
Date: Sat, 22 Oct 2011 09:44:49 +0800
Message-ID: <CAJ-Vmo=ji4VeKfYptt0S=g6LKeFqX-V0J_tRDWX-a6dR6B6O_g@mail.gmail.com> (sfid-20111022_034457_768131_9796B17A)
Subject: Re: Setting negative value in dBm for power output (txpower)
From: Adrian Chadd <adrian@freebsd.org>
To: =?ISO-8859-2?Q?Patryk_=AF=F3=B3towski?=
	<patryk.zoltowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The AR9280 and later atheros NICs support a minimum TX power of -5 dBm.
It depends on what the actual NIC manufacturer does (if they glue an
amplifier on the end, then all bets are off) but the chipsets are
capable of it.

It's also possible someone's glued attenuators to pre-AR9280 series
NICs to achieve the same output. Or you could do the same.
But at that point you're not communicating < 0 dBm to the NIC, and I
don't think cfg80211 has the idea of a TX power offset (ie, that the
NIC output is +/- x dBm different to the programmed value.)

HTH,


Adrian
