Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46685 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0HVU2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 16:28:52 -0400
Received: by pzk26 with SMTP id 26so2044083pzk.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 13:28:51 -0700 (PDT)
Message-ID: <4C7188C3.90702@lwfinger.net>
Date: Sun, 22 Aug 2010 15:29:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-2?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/2] b43: N-PHY: add sub calls of band width setting
References: <1282506589-8220-1-git-send-email-zajec5@gmail.com>	<1282506589-8220-2-git-send-email-zajec5@gmail.com>	<AANLkTi=dXNY+Hf8--Yp4VjQBOMwDCFuQqNSi_OAsq=2X@mail.gmail.com>	<AANLkTimeKMR8MfoNKyr6i-JxA8bdqwMKriUbBOagw-z5@mail.gmail.com> <AANLkTi=ELhn1sFmpYn5a1-GcWqVBAeRGC6Kc7OBDLmZw@mail.gmail.com>
In-Reply-To: <AANLkTi=ELhn1sFmpYn5a1-GcWqVBAeRGC6Kc7OBDLmZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/22/2010 03:04 PM, Gábor Stefanik wrote:
> 
> Sorry, I'm on a Windows-only machine right now.
> However, the general rule of translation is:
> mhf(a, b, c, d) -> b43_hf_write(dev, (b43_hf_read(dev) & (~b <<
> (a*16))) | (c << (a*16)))
> (Yes, the last parameter is ignored; it seems to be just Broadcrap -
> crap written by Broadcom.)
> 

IIRC, the d part is a flag used to save the state and avoid writes if the code
is setting a state already available. As these writes are not very expensive,
this part can indeed be called Broadcrap.

Larry
