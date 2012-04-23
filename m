Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54501 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab2DWHuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 03:50:20 -0400
Received: by eaaq12 with SMTP id q12so3108120eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 00:50:18 -0700 (PDT)
Date: Mon, 23 Apr 2012 09:50:01 +0200
From: Anisse Astier <anisse@astier.eu>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	RA-ShiangTu <Shiang_Tu@ralinktech.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Kevin Chou <kevin.chou@mediatek.com>,
	John Li <chen-yang.li@mediatek.com>,
	RA-Jay Hung <Jay_Hung@ralinktech.com>
Subject: Re: [PATCH] rt2800: add chipset revision RT5390R support
Message-ID: <20120423095001.50af46cf@destiny.ordissimo> (sfid-20120423_095039_698777_661799EF)
In-Reply-To: <BD323515-0FC1-4A0C-A5EC-92DBC75153CB@gmail.com>
References: <1334759039-24349-1-git-send-email-anisse@astier.eu>
	<BD323515-0FC1-4A0C-A5EC-92DBC75153CB@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 20 Apr 2012 19:07:38 +0200, Gertjan van Wingerde <gwingerde@gmail.com> wrote :

> Hi Anisse,
> 
> 
> On 18 apr. 2012, at 16:23, Anisse Astier <anisse@astier.eu> wrote:
> 
> > About 70% of the chips with revision RT5390R initialize incorrectly, using
> > the auxiliary antenna instead of the main one. The net result is that
> > signal reception is very poor (no AP further than 1M).
> > 
> > This chipset differs from RT5390 and RT5390F by its support of hardware
> > antenna diversity. Therefore antenna selection should be done
> > differently, by disabling software features and previously selected
> > antenna.
> > 
> > This changeset does just that, and makes all RT5390R work properly.
> > 
> > This is based on Ralink's 2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO
> > driver.
> > 
> > Signed-off-by: Anisse Astier <anisse@astier.eu>
> > ---
> > drivers/net/wireless/rt2x00/rt2800.h    |    1 +
> > drivers/net/wireless/rt2x00/rt2800lib.c |   10 ++++++++++
> > 2 files changed, 11 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> > index 063bfa8..1ce2634 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800.h
> > +++ b/drivers/net/wireless/rt2x00/rt2800.h
> > @@ -83,6 +83,7 @@
> > #define REV_RT3090E            0x0211
> > #define REV_RT3390E            0x0211
> > #define REV_RT5390F            0x0502
> > +#define REV_RT5390R            0x1502
> > 
> > /*
> >  * Signal information.
> > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> > index bd19802..6c95101 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> > @@ -3356,6 +3356,16 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
> >            rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
> >        }
> > 
> > +        /* This chip has hardware antenna diversity*/
> > +        if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
> > +            rt2x00dev->default_ant.tx = ANTENNA_HW_DIVERSITY; /* Unused */
> > +            rt2x00dev->default_ant.rx = ANTENNA_HW_DIVERSITY; /* Unused */
> > +
> > +            rt2800_bbp_write(rt2x00dev, 150, 0); /* Disable Antenna Software OFDM */
> > +            rt2800_bbp_write(rt2x00dev, 151, 0); /* Disable Antenna Software CCK */
> > +            rt2800_bbp_write(rt2x00dev, 154, 0); /* Clear previously selected antenna */
> > +        }
> > +
> >        rt2800_bbp_read(rt2x00dev, 152, &value);
> >        if (ant == 0)
> >            rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 1);
> 
> Thanks for figuring this out. However, I think the default_ant initializations should be put at the place where the other initializations for the same field are (I believe that is somewhere in the rt2800_init_eeprom function (or a function with a similar name).

I'm not even sure those are needed. I put them there in case someone
would want to use them in the future. What do you think ?


> The BBP CSR writes are in the right place.
> 
> ---
> Gertjan

--
Anisse
