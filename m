Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:41060 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXKOX70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 18:59:26 -0500
Received: by an-out-0708.google.com with SMTP id b36so145778ana
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2007 15:59:24 -0800 (PST)
Message-ID: <40f31dec0711151559g2822f644s462d7ac8ffb0bbb2@mail.gmail.com> (sfid-20071115_235929_689009_3AE7FCED)
Date: Fri, 16 Nov 2007 01:59:24 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 2/4] ath5k: Fix device info reporting
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
In-Reply-To: <43e72e890711151038k68d102f9m7f421ea301433cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071114161440.GB6365@localhost.domain.invalid>
	 <43e72e890711151038k68d102f9m7f421ea301433cf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/15, Luis R. Rodriguez <mcgrof@gmail.com>:
> On Nov 14, 2007 11:14 AM, Nick Kossifidis <mick@madwifi.org> wrote:
> > *Fix device info code
> >
> > Changes-licensed-under: 3-clause-BSD
> > Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
> >
> > ---
> > diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> > index 4c4837f..0d0e060 100644
> > --- a/drivers/net/wireless/ath5k/base.c
> > +++ b/drivers/net/wireless/ath5k/base.c
> > @@ -570,22 +570,40 @@ ath5k_pci_probe(struct pci_dev *pdev,
> >         if (ret)
> >                 goto err_ah;
> >
> > -       dev_info(&pdev->dev, "Atheros AR%s chip found: MAC 0x%x, PHY: 0x%x\n",
> > +       dev_info(&pdev->dev, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
> >                         ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
> >                                         sc->ah->ah_mac_srev,
> >                                         sc->ah->ah_phy_revision);
> >
> > -       if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision){
> > -               dev_info(&pdev->dev, "RF%s radio found (0x%x)\n",
> > -                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > -                                       sc->ah->ah_radio_5ghz_revision);
> > -       } else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
> > -               dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> > -                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > -                                       sc->ah->ah_radio_5ghz_revision);
> > -               dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> > -                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
> > -                                       sc->ah->ah_radio_2ghz_revision);
> > +       if(!sc->ah->ah_single_chip){
>
> I'm a bit confused here you check for not single chip
>
Single chip solution (ah_single_chip) means PHY chip integrated with
MAC, we don't need to print radio info for them because there are no
separate radio chips.

> > +               /* Single chip radio (!RF5111) */
> > +               if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision) {
>
> And here you say it is. Can you elaborate a bit on this?
>
This is single chip radio, a PHY that both 5HGz/2GHz radios are in one
chip (only 5111 is a dual chip radio with 5111 for 5GHz and 2111 for
2GHz).

> > +                       /* No 5GHz support -> report 2GHz radio */
> > +                       if(!test_bit(MODE_IEEE80211A, sc->ah->ah_capabilities.cap_mode)){
> > +                               dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> > +                                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > +                                                       sc->ah->ah_radio_5ghz_revision);
> > +                       /* No 2GHz support (5110 and some 5Ghz only cards) -> report 5Ghz radio */
> > +                       } else if(!test_bit(MODE_IEEE80211B, sc->ah->ah_capabilities.cap_mode)){
> > +                               dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> > +                                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > +                                                       sc->ah->ah_radio_5ghz_revision);
> > +                       /* Multiband radio */
> > +                       } else {
> > +                               dev_info(&pdev->dev, "RF%s multiband radio found (0x%x)\n",
> > +                                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > +                                                       sc->ah->ah_radio_5ghz_revision);
> > +                       }
> > +               }
> > +               /* Multi chip radio (RF5111 - RF2111) -> report both 2GHz/5GHz radios */
> > +               else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
> > +                       dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> > +                               ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > +                                               sc->ah->ah_radio_5ghz_revision);
> > +                       dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> > +                               ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
> > +                                               sc->ah->ah_radio_2ghz_revision);
> > +               }
> >         }
> >
>
> Thanks,
>
>   Luis
> _______________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
