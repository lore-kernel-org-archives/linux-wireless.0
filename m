Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:34022 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYGSAnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 20:43:04 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] rtl8187: Improve wireless statistics for RTL8187B
Date: Fri, 18 Jul 2008 21:42:59 -0300
Cc: "Hin-Tak Leung" <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
In-Reply-To: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807182142.59921.herton@mandriva.com.br> (sfid-20080719_024315_288855_F56EED44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Thursday 17 July 2008 12:02:56 Larry Finger escreveu:
> Wireless statistics produced by the RTL8187B driver are not particularly
> informative about the strength of the received signal. From the data sheet
> provided by Realtek, I discovered that certain parts of the RX header
> should have the information necessary to calculate signal quality and
> strength. With testing, it became clear that most of these quantities were
> very jittery - only the AGC correlated with the signals expected from
> nearby AP's. As a result, the quality and strength are derived from the agc
> value. The scaling has been determined so that the numbers are close to
> those obtained by b43 under the same conditions. The results are
> qualitatively correct.
>
> Statistics derived for the RTL8187 have not been changed.
>
> The RX header variables have been renamed to match the quantites described
> in the Realtek data sheet.

Hi,

I did some tests here and statistics are better now. I only couldn't use 
latest wireless-testing because something of latest changes broke 
communication, I couldn't scan/associate anymore, but using wireless-testing 
head at d61f20889de4978ed87d2a37d6f27147faec22d1 plus later anaparam*off 
change, with your patch I can confirm the better statistics, later I'll try 
to find what in wireless-testing broke here, I didn't have time to look into 
this today.

>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Pavel,
>
> Please check that this patch does not break the RTL8187 statistics.
> Perhaps, similar changes should be made there, but I don't have the
> hardware.
>
> Larry

-- 
[]'s
Herton
