Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:32866 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbZA3WEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 17:04:51 -0500
Message-ID: <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk> (sfid-20090130_230456_249829_442BAAEC)
In-Reply-To: <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
    <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>
    <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>
    <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>
Date: Fri, 30 Jan 2009 22:04:46 -0000 (UTC)
Subject: Re: rtl8187 wireless issues
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Cc: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ok,

Actually dmesg reports the same as you

phy0: hwaddr f729a040, RTL8187BvE V0 + rtl8225z2
usbcore: registered new interface driver rtl8187

NetworkManager advice taken with thanks.

>
> That's wierd - are you sure? Compat-wireless is supposed to put the
> whole lot (about 50MB of kernel modules, nearly 50 of them) into
> updates, although only about 4-5 kernel modules are used for rtl8187b=
=2E
>

After running make uninstall and make install a few times, this is the
structure of files I end with in /lib/modules/`uname -r`.

updates
updates/net
updates/net/mac80211
updates/net/mac80211/mac80211.ko
updates/net/wireless
updates/net/wireless/ifcfg80211.ko
updates/net/wireless/lib80211_crypt_tkip.ko
updates/net/wireless/lib80211.ko
updates/net/wireless/lib80211_crypt_ccmp.ko
updates/net/wireless/lib80211_crypt_wep.ko
updates/drivers
updates/drivers/net
updates/drivers/net/b44.ko
updates/drivers/net/wireless
updates/drivers/net/usb
updates/drivers/net/usb/rndis_host.ko
updates/drivers/net/usb/usbnet.ko
updates/drivers/net/usb/cdc_ether.ko
updates/drivers/misc
updates/drivers/misc/eeprom
updates/drivers/misc/eeprom/eeprom_93cx6.ko
updates/drivers/ssb
updates/drivers/ssb/ssb.ko

I manually added in to complete it:
updates/drivers/net/wireless/rtl818x
updates/drivers/net/wireless/rtl818x/rtl8187.ko

I am not that familiar with kernel makefiles but it would seem that the
drivers/net/wireless line below is not recursive:

obj-y :=3D net/wireless/ net/mac80211/
ifeq ($(ONLY_CORE),)
obj-$(CONFIG_B44) +=3D drivers/net/b44.o
obj-y +=3D drivers/ssb/ \
        drivers/misc/eeprom/ \
        drivers/net/usb/ \
        drivers/net/wireless/
endif

Anyway, its only a minor thing.

Cheers

PGR



--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
