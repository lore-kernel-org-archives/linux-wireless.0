Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:50609 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbXKPBMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 20:12:48 -0500
Received: by py-out-1112.google.com with SMTP id u77so3891993pyb
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2007 17:12:47 -0800 (PST)
Message-ID: <43e72e890711151712l78c52e95lcc97881ff15f7f82@mail.gmail.com> (sfid-20071116_011256_806574_9C9A5393)
Date: Thu, 15 Nov 2007 20:12:46 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 2/4] ath5k: Fix device info reporting
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
In-Reply-To: <40f31dec0711151559g2822f644s462d7ac8ffb0bbb2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071114161440.GB6365@localhost.domain.invalid>
	 <43e72e890711151038k68d102f9m7f421ea301433cf@mail.gmail.com>
	 <40f31dec0711151559g2822f644s462d7ac8ffb0bbb2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 15, 2007 6:59 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2007/11/15, Luis R. Rodriguez <mcgrof@gmail.com>:
>
> > On Nov 14, 2007 11:14 AM, Nick Kossifidis <mick@madwifi.org> wrote:
> > > *Fix device info code
> > >
> > > Changes-licensed-under: 3-clause-BSD
> > > Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
> > >
> > > ---
> > > diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> > > index 4c4837f..0d0e060 100644
> > > --- a/drivers/net/wireless/ath5k/base.c
> > > +++ b/drivers/net/wireless/ath5k/base.c
> > > @@ -570,22 +570,40 @@ ath5k_pci_probe(struct pci_dev *pdev,
> > >         if (ret)
> > >                 goto err_ah;
> > >
> > > -       dev_info(&pdev->dev, "Atheros AR%s chip found: MAC 0x%x, PHY: 0x%x\n",
> > > +       dev_info(&pdev->dev, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
> > >                         ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
> > >                                         sc->ah->ah_mac_srev,
> > >                                         sc->ah->ah_phy_revision);
> > >
> > > -       if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision){
> > > -               dev_info(&pdev->dev, "RF%s radio found (0x%x)\n",
> > > -                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > > -                                       sc->ah->ah_radio_5ghz_revision);
> > > -       } else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
> > > -               dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> > > -                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > > -                                       sc->ah->ah_radio_5ghz_revision);
> > > -               dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> > > -                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
> > > -                                       sc->ah->ah_radio_2ghz_revision);
> > > +       if(!sc->ah->ah_single_chip){
> >
> > I'm a bit confused here you check for not single chip
> >
> Single chip solution (ah_single_chip) means PHY chip integrated with
> MAC, we don't need to print radio info for them because there are no
> separate radio chips.

Ah, thanks for clarifying this. Hm, we should rename ah_single_chip
then being that we use "single chip" very differently below. That can
wait though.

> > > +               /* Single chip radio (!RF5111) */
> > > +               if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision) {
> >
> > And here you say it is. Can you elaborate a bit on this?
> >
> This is single chip radio, a PHY that both 5HGz/2GHz radios are in one
> chip (only 5111 is a dual chip radio with 5111 for 5GHz and 2111 for
> 2GHz).
>

Thanks for clarifying this.

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
