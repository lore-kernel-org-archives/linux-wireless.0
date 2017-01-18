Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751799AbdARO7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 09:59:41 -0500
Date: Wed, 18 Jan 2017 15:47:20 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 14/14] rt2x00: add support for RT5350 WiSoC
Message-ID: <20170118144719.GB22837@redhat.com> (sfid-20170118_155944_584427_2DCBCB75)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116031734.GA32321@makrotopia.org>
 <20170116101743.GF6968@redhat.com>
 <20170117014806.GE1912@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170117014806.GE1912@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 17, 2017 at 02:48:07AM +0100, Daniel Golle wrote:
> On Mon, Jan 16, 2017 at 11:17:44AM +0100, Stanislaw Gruszka wrote:
> > On Mon, Jan 16, 2017 at 04:17:58AM +0100, Daniel Golle wrote:
> > > @@ -7131,6 +7236,12 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
> > >  		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF2820);
> > >  		rt2800_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
> > >  		rt2x00_eeprom_dbg(rt2x00dev, "Antenna: 0x%04x\n", word);
> > > +	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
> > > +		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RXPATH, 1);
> > > +		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_TXPATH, 1);
> > > +		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF3320);
> 
> Good catch. This line was probably left over when trying to implement
> support for RT5350 based on adding codepaths to RF3320 which ended up
> messy... As EEPROM_NIC_CONF0_RF_TYPE aparently isn't used anywhere else
> in the code apart from setting rf type which is later on overwritten
> for RT5350 anyway. So no need to set it at all. I suggest to simply
> drop that line.

I'm not sure about that, but overwrite EEPROM_NIC_CONF0_RXPATH
and EEPROM_NIC_CONF0_TXPATH should not be needed as well. EEPROM
should contain proper values.

Stanislaw
