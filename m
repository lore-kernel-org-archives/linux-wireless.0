Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48414 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0IIFHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 01:07:24 -0400
Received: by iwn5 with SMTP id 5so725958iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 22:07:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTindGAm4DPaG1MYa6u1rkRNv8z9EjUq+bwjD-+zX@mail.gmail.com>
References: <AANLkTimq7nB-ea1XmORprBiS2B-OBNtEiiQXAZLzZfA2@mail.gmail.com>
 <AANLkTi=i_7oMX4nTiWwcjGezv8vG92gX_8UV1tv_KdYL@mail.gmail.com>
 <AANLkTi=oVwssd-YvVCqujm2MNqPGF4t6FUAXGu9Wei5=@mail.gmail.com> <AANLkTindGAm4DPaG1MYa6u1rkRNv8z9EjUq+bwjD-+zX@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 8 Sep 2010 22:07:03 -0700
Message-ID: <AANLkTi=F_7aJeig9jtFxvETqAVtuEbr6wednJh9Q7xsA@mail.gmail.com>
Subject: Re: ath9k: freeze when putting interface up
To: =?UTF-8?Q?Bj=C3=B8rnar_Hansen?= <tilbjornar@gmail.com>,
	Nick Nobody <me@nikosapi.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Satagopan Kanthadai <Satagopan.Kanthadai@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel-request@lists.ath9k.org,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	Vivek Natarajan <vnatarajan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 5, 2010 at 12:49 PM, Bjørnar Hansen <tilbjornar@gmail.com> wrote:
> Hi again,
>
> I managed to use git bisect to pinpoint the exact commit that causes
> my laptop to freeze:
>
> 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f is the first bad commit
> commit 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f
> Author: Vivek Natarajan <vnatarajan@atheros.com>
> Date:   Mon Apr 5 14:48:04 2010 +0530
>
>    ath9k: Add support for newer AR9285 chipsets.
>
>    This patch adds support for a modified newer version of AR9285
>    chipsets.
>
>    Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
>
> I'm CC'ing this to Vivek also.
> The chipset is reported as AR9285 rev 01. by lspci (I previously
> stated it was rev 2, this is wrong).
>
> While bisecting I found a reliable way to reproduce the freeze. I
> devised a script to continuously bring the interface up and down:
>
> COUNTER=1
> while(true); do
>    sudo ifconfig wlan0 up &&
>    sudo ifconfig wlan0 down &&
>    echo $COUNTER &&
>    let COUNTER=COUNTER+1
> done
>
> On stable kernels I let it run to around 150. On unstable kernels it
> reached at most 8.

Some attention to this would be appreciated.

  Luis
