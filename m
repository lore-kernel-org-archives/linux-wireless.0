Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n20.bullet.mail.ukl.yahoo.com ([87.248.110.137]:29028 "HELO
	n20.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754654AbYGJWnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 18:43:41 -0400
Message-ID: <48769266.4090407@yahoo.co.uk> (sfid-20080711_004347_996169_1DE923A8)
Date: Thu, 10 Jul 2008 23:51:18 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>, proski@gnu.org
Subject: Re: [RFC] Try to improve RTL8187B initialization time
References: <200807101851.31985.herton@mandriva.com.br>
In-Reply-To: <200807101851.31985.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> As reported before, we know that the initialization of rtl8187b interfaces is
> slow. There were some strange sleeps from vendor driver that were imported too
> just to be sure, but they don't seem to be needed. After looking at r8180 code,
> I think they really aren't needed, and using it as reference, I did a similar
> initialization now for rtl8187b, on quick tests seems to work well.

Most of the change is minor - mainly 6 secs is removed in 3 big chunks, but
a fraction of a sec here and there is added back elsewhere, so the net effect
is probably 4-5 sec, or less, since you also added some new code.
How about just removing the 3 chunks as below?

I am wondering also if some of the delays is simply that some of the init
numbers is wrong and the firmware gets thrown into some mini-recovery over-ride
routine.

I also have another "theory" - the windows driver is sensitive to the hardware 
switch and the linux driver not, so obviously the effect of the hardware switch
can be overrided in software. To give the *appearance* of fast initialization,
maybe the windows driver simply initialize everything on load (i.e. when windows 
starts), then switch the radio on and off when the user asks to shut off the
interface, etc. I have never got ndiswrapper to work on x86_64 (ifconfig up
stuck) - how does timing of ifconfig up/down with ndiswrapper compare?

BTW, ndiswrapper won't even build with 2.6.26-rc9.

> diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
> index f981fdb..25d9a0e 100644
> --- a/drivers/net/wireless/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl8187_dev.c

> @@ -643,14 +641,13 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)

> -	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
> -	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
> -	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
> -	msleep(1100);
> -

1st one.

> diff --git a/drivers/net/wireless/rtl8187_rtl8225.c b/drivers/net/wireless/rtl8187_rtl8225.c
> index 1bae899..9549e33 100644
> --- a/drivers/net/wireless/rtl8187_rtl8225.c
> +++ b/drivers/net/wireless/rtl8187_rtl8225.c

> @@ -850,25 +859,36 @@ static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)

> -	rtl8225_write(dev, 0x3, 0x080); msleep(1);
> -	rtl8225_write(dev, 0x5, 0x004); msleep(1);
> -	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
> -	msleep(3000);

2nd


> +	rtl8225_write(dev, 0x0, 0x0B7);
> +	msleep(100);
> +	rtl8225_write(dev, 0x2, 0xC4D);
> +	msleep(200);
> +	rtl8225_write(dev, 0x2, 0x44D);
> +	msleep(100);
>  
> -	rtl8225_write(dev, 0x2, 0xC4D); msleep(1);
> -	msleep(2000);

3rd, but some are added as above.

