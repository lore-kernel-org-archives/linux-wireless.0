Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:34099 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbXJaTjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 15:39:13 -0400
Received: by ik-out-1112.google.com with SMTP id c28so122837ika
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 12:39:10 -0700 (PDT)
Message-ID: <40f31dec0710311239m7e5e1fa0q62fd212e7631f68c@mail.gmail.com> (sfid-20071031_193917_217627_AAB2240B)
Date: Wed, 31 Oct 2007 21:39:09 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 4/7] ath5k: Add SREV values for newer chips
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
In-Reply-To: <43e72e890710311214y52bbdfd3y24d3c05c05257ac6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071027232033.GD5973@localhost.domain.invalid>
	 <43e72e890710311110l4a301f8cpb67b21bd90e251b4@mail.gmail.com>
	 <40f31dec0710311155p78e41515rf74b6243c4decd40@mail.gmail.com>
	 <43e72e890710311214y52bbdfd3y24d3c05c05257ac6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/31, Luis R. Rodriguez <mcgrof@gmail.com>:
> On 10/31/07, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > 2007/10/31, Luis R. Rodriguez <mcgrof@gmail.com>:
> > > On 10/27/07, Nick Kossifidis <mick@madwifi.org> wrote:
> > >
> > > > * Give more infos about mac/phy/radio revision during attach.
> > >
> > > > @@ -535,10 +568,24 @@ ath5k_pci_probe(struct pci_dev *pdev,
> > > >         if (ret)
> > > >                 goto err_ah;
> > > >
> > > > -       dev_info(&pdev->dev, "%s chip found: mac %d.%d phy %d.%d\n",
> > > > -                       ath5k_chip_name(id->driver_data), sc->ah->ah_mac_version,
> > > > -                       sc->ah->ah_mac_revision, sc->ah->ah_phy_revision >> 4,
> > > > -                       sc->ah->ah_phy_revision & 0xf);
> > > > +       dev_info(&pdev->dev, "Atheros AR%s chip found: MAC 0x%x, PHY: 0x%x\n",
> > > > +                       ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
> > > > +                                       sc->ah->ah_mac_srev,
> > > > +                                       sc->ah->ah_phy_revision);
> > > > +
> > > > +       if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision){
> > > > +               dev_info(&pdev->dev, "RF%s radio found (0x%x)\n",
> > > > +                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > > > +                                       sc->ah->ah_radio_5ghz_revision);
> > > > +       } else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
> > > > +               dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
> > > > +                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > > > +                                       sc->ah->ah_radio_5ghz_revision);
> > > > +               dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
> > > > +                       ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
> > > > +                                       sc->ah->ah_radio_2ghz_revision);
> > > > +       }
> > > > +
> > > >
> > > >         /* ready to process interrupts */
> > > >         __clear_bit(ATH_STAT_INVALID, sc->status);
> > > >
> > >
> > > I have ACK'd this as I believe its a lot more useful information than
> > > what we had before but I am confused by what some different prints may
> > > yield. For example, on AR5213, I get:
> > >
> > > ath5k_pci 0001:11:02.0: Atheros AR5213 chip found: MAC 0x56, PHY: 0x41
> > > ath5k_pci 0001:11:02.0: RF5111 5GHz radio found (0x17)
> > > ath5k_pci 0001:11:02.0: RF2111 2GHz radio found (0x23)
> > >
> > > On my Cardbus card, I then get:
> > >
> > > ath5k_pci 0000:15:00.0: Atheros AR5213A chip found: MAC 0x59, PHY: 0x43
> > > ath5k_pci 0000:15:00.0: RF5112A radio found (0x36)
> > >
> > > Now, both are capable of 2 GHz and 5 GHz though and only one prints a
> > > line which shows the type of RF both for 2 GHz and 5 GHz. Essentially
> > > my ah_radio_2ghz_revision is 0x00 for that card. What exactly does
> > > having a print for both RFs here indicate besides the fact we are
> > > indicating the type of radio and revision? And in the Cardbus card I
> > > have where only one RF line is printed what does that indicate?
> > >
> > >   Luis
> >
> > RF5111 is only 5GHz capable without 2111, 2111 is only 2GHz capable
> > (it's actually an extension to 5111), on the other hand 5112 is
> > multiband, that's why we don't say it's type.
>
> Can add in the message that its RF is multiband then (2GHz/5GHz note will work)?
>
> > On single chip solutions
> > both revisions are 0 so no RF chip msg is displayed.
>
> Hm.. interesting.. we probably should inform the band the RF is
> capable of then at least. What do you think?
>

Note: We set them to zero (check out attach) to make things easier.
I believe that for single chips we should check capability bits and
for b/g only report 2GHz, for a only report 5Ghz and for both report
multband or nothing.

> > We have to handle this better for b/g only cards but i didn't have
> > such cards to test so i'll try it later (first we have to see what's
> > going on and they don't work).
>
> You have one now?
>
>   Luis
>

Nope but i believe that regdumps from them should give us something...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
