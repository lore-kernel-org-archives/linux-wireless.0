Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34839 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966527AbdCXQYm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 12:24:42 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alban <albeu@free.fr>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        John Crispin <john@phrozen.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chrisrblake93@gmail.com
Subject: Re: [PATCH 3/7] ath9k: Add support for reading the EEPROM data using the nvmem API
Date: Fri, 24 Mar 2017 17:24:38 +0100
Message-ID: <4828897.dR6pcKhMJ3@debian64> (sfid-20170324_172638_805748_D298BC73)
In-Reply-To: <20170323154328.4bb5db44@avionic-0020>
References: <1489439116-4233-1-git-send-email-albeu@free.fr> <1609202.bQK0rlNN3Y@debian64> <20170323154328.4bb5db44@avionic-0020>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, March 23, 2017 3:43:28 PM CET Alban wrote:
> On Tue, 14 Mar 2017 00:53:55 +0100
> Christian Lamparter <chunkeey@googlemail.com> wrote:
> 
> > On Monday, March 13, 2017 10:05:11 PM CET Alban wrote:
> > > Currently SoC platforms use a firmware request to get the EEPROM data.
> > > This is mostly a hack and rely on using a user-helper scripts which is
> > > deprecated. A nicer alternative is to use the nvmem API which was
> > > designed for this kind of task.
> > > 
> > > Furthermore we let CONFIG_ATH9K_AHB select CONFIG_NVMEM as such
> > > devices will generally use this method for loading the EEPROM data.
> > > 
> > > Signed-off-by: Alban <albeu@free.fr>
> > > ---
> > > @@ -654,6 +656,25 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
> > >  	if (ret)
> > >  		return ret;
> > >  
> > > +	/* If the EEPROM hasn't been retrieved via firmware request
> > > +	 * use the nvmem API insted.
> > > +	 */
> > > +	if (!ah->eeprom_blob) {
> > > +		struct nvmem_cell *eeprom_cell;
> > > +
> > > +		eeprom_cell = nvmem_cell_get(ah->dev, "eeprom");
> > > +		if (!IS_ERR(eeprom_cell)) {
> > > +			ah->eeprom_data = nvmem_cell_read(
> > > +				eeprom_cell, &ah->eeprom_size);
> > > +			nvmem_cell_put(eeprom_cell);
> > > +
> > > +			if (IS_ERR(ah->eeprom_data)) {
> > > +				dev_err(ah->dev, "failed to read eeprom");
> > > +				return PTR_ERR(ah->eeprom_data);
> > > +			}
> > > +		}
> > > +	}
> > > +
> > >  	if (ath9k_led_active_high != -1)
> > >  		ah->config.led_active_high = ath9k_led_active_high == 1;
> > >    
> > Are you sure this works with AR93XX SoCs that have the calibration data
> > in the OTP?
> 
> I only tested this on an ar9132 platform, so it might well be that a
> few things are missing for the newer SoC. However this shouldn't break
> anything existing as a platform needs to define an nvmem cell on the
> athk9 device for this code to be used a all.

Yes, I looked at it.
+		eeprom_cell = nvmem_cell_get(ah->dev, "eeprom");
+		if (!IS_ERR(eeprom_cell)) {
+			...
+		}
So if there's a error with the "eeprom" nvmem property,
(i.e.: it's not present) the driver should works as before.

Thanks,
Christian
