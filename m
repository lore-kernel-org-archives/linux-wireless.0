Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:42487 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0A0Esw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 23:48:52 -0500
Received: by fxm20 with SMTP id 20so1171321fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 20:48:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100127021040.GA15520@tuxdriver.com>
References: <1264540940-30813-1-git-send-email-linville@tuxdriver.com>
	<69e28c911001261453r12a687eay3eac8669d3f0bfad@mail.gmail.com>
	<20100127021040.GA15520@tuxdriver.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 27 Jan 2010 05:48:31 +0100
Message-ID: <69e28c911001262048t519256e5o8ad67259f83d2520@mail.gmail.com>
Subject: Re: [PATCH] rtl8180: implement get_tsf op for mac80211
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/27 John W. Linville <linville@tuxdriver.com>:
> On Tue, Jan 26, 2010 at 11:53:38PM +0100, Gábor Stefanik wrote:
>> On Tue, Jan 26, 2010 at 10:22 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> > ---
>> >  drivers/net/wireless/rtl818x/rtl8180_dev.c |   15 +++++++++++++++
>> >  1 files changed, 15 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
>> > index 5a2b719..8dbb504 100644
>> > --- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
>> > +++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
>> > @@ -761,6 +761,20 @@ static void rtl8180_configure_filter(struct ieee80211_hw *dev,
>> >        rtl818x_iowrite32(priv, &priv->map->RX_CONF, priv->rx_conf);
>> >  }
>> >
>> > +static u64 rtl8180_get_tsf(struct ieee80211_hw *dev)
>> > +{
>> > +       struct rtl8180_priv *priv = dev->priv;
>> > +       u32 tsftl;
>> > +       u64 tsft;
>> > +
>> > +       tsftl = rtl818x_ioread32(priv, &priv->map->TSFT[0]);
>> > +       tsft = rtl818x_ioread32(priv, &priv->map->TSFT[1]);
>> > +       tsft <<= 32;
>> > +       tsft |= tsftl;
>> > +
>> > +       return tsft;
>> > +}
>>
>> Why not:
>>
>> struct rtl8180_priv *priv = dev->priv;
>> u64 tsft;
>>
>> tsft = rtl818x_ioread32(priv, &priv->map->TSFT[0]);
>> tfst |= rtl818x_ioread32(priv, &priv->map->TSFT[1]) << 32;
>>
>> return tsft;
>
> What difference does it make?
>
> John

The primary difference is that it is significantly shorter, and gets
away without a temp variable.

(This is like writing

driver_write32(dev, reg, driver_read32(dev, reg) | 0x80);

instead of

tmp = driver_read32(dev, reg);
tmp |= 0x80;
driver_write32(dev, reg, tmp);

Saves some code.)

> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
