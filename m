Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61368 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757762Ab1CORYt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 13:24:49 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 10:24:26 -0700
Date: Tue, 15 Mar 2011 22:55:04 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath9k_hw: Speedup register ops for HTC driver
Message-ID: <20110315172504.GA12239@vmraj-lnx.users.atheros.com>
References: <1300199138-11851-1-git-send-email-rmanoharan@atheros.com>
 <1300199138-11851-3-git-send-email-rmanoharan@atheros.com>
 <19839.38108.516103.285131@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19839.38108.516103.285131@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 15, 2011 at 10:03:32PM +0530, Sujith wrote:
> Rajkumar Manoharan wrote:
> > diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
> > index fccd87d..995949d 100644
> > --- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
> > +++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
> > @@ -799,6 +799,8 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
> >  							   pwr_table_offset,
> >  							   &diff);
> >  
> > +			ENABLE_REGWRITE_BUFFER(ah);
> > +
> >  			if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
> >  				if (OLC_FOR_AR9280_20_LATER) {
> >  					REG_WRITE(ah,
> > @@ -847,6 +849,7 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
> >  
> >  				regOffset += 4;
> >  			}
> > +			REGWRITE_BUFFER_FLUSH(ah);
> >  		}
> >  	}
> >  
> > @@ -1205,6 +1208,8 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
> >  		}
> >  	}
> >  
> > +	ENABLE_REGWRITE_BUFFER(ah);
> > +
> >  	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
> >  		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
> >  		  | ATH9K_POW_SM(ratesArray[rate12mb], 16)
> > @@ -1291,6 +1296,8 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
> >  	REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
> >  		  ATH9K_POW_SM(pModal->pwrDecreaseFor3Chain, 6)
> >  		  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
> > +
> > +	REGWRITE_BUFFER_FLUSH(ah);
> >  }
> >  
> 
> Since this issue was observed in UB95, shouldn't eeprom_9287 be fixed ?

Yeah.. I missed it. send v2 patch. Thanks ;)

--
Rajkumar
