Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61278 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444Ab0LBMKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 07:10:05 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 04:09:51 -0800
Date: Thu, 2 Dec 2010 17:39:25 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 16/27] ath9k_hw: Read and configure antenna
	diversity control for AR9485
Message-ID: <20101202120925.GM12908@vasanth-laptop>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com> <1291288031-3409-17-git-send-email-vasanth@atheros.com> <AANLkTi=Fb0HA1DbaRp21kOS3x4-s_Oh+UZok2jNK3-PG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTi=Fb0HA1DbaRp21kOS3x4-s_Oh+UZok2jNK3-PG@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 02, 2010 at 04:52:33PM +0530, Julian Calaby wrote:
> Small nit:
> 
> On Thu, Dec 2, 2010 at 22:07, Vasanthakumar Thiagarajan
> <vasanth@atheros.com> wrote:
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   24 ++++++++++++++++++++----
> >  drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   10 ++++++++++
> >  2 files changed, 30 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> > index 02b6150..9ce6846 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> > @@ -3512,11 +3514,25 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
> >        value = ar9003_hw_ant_ctrl_chain_get(ah, 0, is2ghz);
> >        REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_0, AR_SWITCH_TABLE_ALL, value);
> >
> > -       value = ar9003_hw_ant_ctrl_chain_get(ah, 1, is2ghz);
> > -       REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_1, AR_SWITCH_TABLE_ALL, value);
> > +       if (!AR_SREV_9485(ah)) {
> > +               value = ar9003_hw_ant_ctrl_chain_get(ah, 1, is2ghz);
> > +               REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_1, AR_SWITCH_TABLE_ALL,
> > +                             value);
> >
> > -       value = ar9003_hw_ant_ctrl_chain_get(ah, 2, is2ghz);
> > -       REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_2, AR_SWITCH_TABLE_ALL, value);
> > +               value = ar9003_hw_ant_ctrl_chain_get(ah, 2, is2ghz);
> > +               REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_2, AR_SWITCH_TABLE_ALL,
> > +                             value);
> > +       }
> 
> else?

No, these are to separate things. 

Vasanth
