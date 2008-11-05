Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:39766 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYKEPdE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 10:33:04 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC/RFT PATCH v2 1/2] rtl8187: implement conf_tx callback to configure tx queues
Date: Wed, 5 Nov 2008 13:33:10 -0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
References: <1225806649-10050-1-git-send-email-herton@mandriva.com.br> <4910CD21.6020807@lwfinger.net> <4910D6A3.2030704@openwrt.org>
In-Reply-To: <4910D6A3.2030704@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811051333.13072.herton@mandriva.com.br> (sfid-20081105_163308_549472_6FC678AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 November 2008 21:11:31 Felix Fietkau wrote:
> Larry Finger wrote:
> > Herton Ronaldo Krzesinski wrote:
> >> Add conf_tx callback and use it to configure tx queues of 8187L/8187B.
> >>
> >> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> >
> > Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> >
> > This patch is OK. With 1 and 2, the rate-control mechanism works the way
> > it did before.
>
> Has anybody tested this thing with the minstrel rate control yet?
> At some point I would like to make minstrel the default RC,
> since it has shown much better performance on drivers like b43 or ath5k.

Tested minstrel here, seems to be working fine, that is, it's changing rate 
above 1M after some seconds of traffic and sticking to a stable rate unlike 
pid where it seems to go in cicles here (from 1M to 9M and going back to 1M 
and so on, unlinke minstrel that sticks to 9M, same environment in both 
cases). Looks a better rate control in practice, didn't make any further 
verifications.

>
> - Felix

--
[]'s
Herton
