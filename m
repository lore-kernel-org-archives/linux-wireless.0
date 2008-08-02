Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:40038 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbYHBM5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 08:57:47 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: p54usb broken by commit b19fa1f
Date: Sat, 2 Aug 2008 14:57:46 +0200
Cc: "David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4893CF3D.1070504@lwfinger.net>
In-Reply-To: <4893CF3D.1070504@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808021457.46438.chunkeey@web.de> (sfid-20080802_145750_699901_A13862B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 August 2008 05:06:37 Larry Finger wrote:
> In testing 2.6.27-rc1, I found that p54usb caused my machine to freeze. A
> few times, I was able to use the KDE system status applet to see that the
> system was using essentially 100% of the CPU's. One other time, the system
> responded a little - enough for me to see tha wpa_supplicant was consuming
> 100% of the my AMD Turion 64 X2 running an x86_64 kernel. From bisection,
> the problem is due to
>
> commit b19fa1fa91845234961c64dbd564671aa7c0fd27
> Author: David S. Miller <davem@davemloft.net>
> Date:   Tue Jul 8 23:14:24 2008 -0700
>
>      net: Delete NETDEVICES_MULTIQUEUE kconfig option.
>
>      Multiple TX queue support is a core networking feature.
>
>      Signed-off-by: David S. Miller <davem@davemloft.net>
>
> Obviously, something in the driver cannot handle multiqueues, but I
> have not found anything, and I have not been able to get any logged events
> that show what is going wrong.
>

Hmm that's a bit odd as my p54usb-adapter seems to work usual with
2.6.27-rc1?!... That said: it doesn't work nearly as stable as the
minipci card that I have too. Is there anyone else who can confirm
that this problem is specific to the p54 driver & 2.6.27-rc1?

Regards,
	Chr.
