Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:39989 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdAQBsf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 20:48:35 -0500
Date: Tue, 17 Jan 2017 02:48:07 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 14/14] rt2x00: add support for RT5350 WiSoC
Message-ID: <20170117014806.GE1912@makrotopia.org> (sfid-20170117_024839_111604_B1C4BC83)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116031734.GA32321@makrotopia.org>
 <20170116101743.GF6968@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116101743.GF6968@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2017 at 11:17:44AM +0100, Stanislaw Gruszka wrote:
> On Mon, Jan 16, 2017 at 04:17:58AM +0100, Daniel Golle wrote:
> > @@ -7131,6 +7236,12 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
> >  		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF2820);
> >  		rt2800_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
> >  		rt2x00_eeprom_dbg(rt2x00dev, "Antenna: 0x%04x\n", word);
> > +	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
> > +		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RXPATH, 1);
> > +		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_TXPATH, 1);
> > +		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF3320);

Good catch. This line was probably left over when trying to implement
support for RT5350 based on adding codepaths to RF3320 which ended up
messy... As EEPROM_NIC_CONF0_RF_TYPE aparently isn't used anywhere else
in the code apart from setting rf type which is later on overwritten
for RT5350 anyway. So no need to set it at all. I suggest to simply
drop that line.

> 
> Here you set RF3320 ..
> > +		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
> > +		rt2x00_eeprom_dbg(rt2x00dev, "Antenna: 0x%04x\n", word);
> >  	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
> >  		   rt2x00_rt(rt2x00dev, RT2872)) {
> >  		/*
> > @@ -7265,6 +7376,8 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
> >  		rt2800_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &rf);
> >  	else if (rt2x00_rt(rt2x00dev, RT3352))
> >  		rf = RF3322;
> > +	else if (rt2x00_rt(rt2x00dev, RT5350))
> > +		rf = RF5350;
> 
> and here RF5350. This does not seems to be correct.
> 
> Stanislaw
