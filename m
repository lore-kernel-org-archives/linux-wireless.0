Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:62638 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbcFOVae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 17:30:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: use s8 instead of char
Date: Wed, 15 Jun 2016 23:25:13 +0200
Message-ID: <5245411.kmNEkqpVVS@wuerfel> (sfid-20160615_233051_050950_37E9C5ED)
In-Reply-To: <wrfjbn32taxw.fsf@redhat.com>
References: <20160615210318.4130648-1-arnd@arndb.de> <wrfjbn32taxw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, June 15, 2016 5:10:51 PM CEST Jes Sorensen wrote:
> 
> Arnd,
> 
> rtlwifi and rtl8xxxu are two distinct drivers managed by different
> people. I'd be really nice if you could split this into a per driver
> patch.
> 
> That said, the use of char in rtl8xxxu is all as a flag indicator, so I
> don't think the s/char/s8/ conversion is justified. I used char rather
> than ugly bool to reduce the size of the struct.

Makes sense, I'll resend without that change. If anything, the flag
should become u8, not s8 anyway.

	Arnd

