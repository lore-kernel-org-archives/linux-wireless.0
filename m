Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52080 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1JCTZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 15:25:06 -0400
Received: by bkbzt4 with SMTP id zt4so5650823bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2011 12:25:05 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
Date: Mon, 3 Oct 2011 21:24:53 +0200
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <1317637758-11907-6-git-send-email-zefir.kurtisi@neratec.com> <CAB=NE6VO4W=ZJcgb3G5Gh=YM-jdkJ3ey5Ppka2Rn0XGmpx8=Gg@mail.gmail.com>
In-Reply-To: <CAB=NE6VO4W=ZJcgb3G5Gh=YM-jdkJ3ey5Ppka2Rn0XGmpx8=Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201110032124.53937.chunkeey@googlemail.com> (sfid-20111003_212517_879732_36B4804A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, October 03, 2011 08:27:39 PM Luis R. Rodriguez wrote:
> On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> >
> > Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > index e8aeb98..5defebe 100644
> > --- a/drivers/net/wireless/ath/ath9k/main.c
> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > @@ -344,6 +344,18 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
> >                        "Unable to reset channel, reset status %d\n", r);
> >                goto out;
> >        }
> > +#ifdef CONFIG_ATH9K_DFS
> > +       /**
> > +        * enable radar pulse detection
> > +        *
> > +        * TODO: do this only for DFS channels
> > +        */
> > +       ah->private_ops.set_radar_params(ah, &ah->radar_conf);
> > +       ath9k_hw_setrxfilter(ah,
> > +                       ath9k_hw_getrxfilter(ah) | ATH9K_RX_FILTER_PHYRADAR);
> > +       ath_dbg(common, ATH_DBG_DFS,
> > +               "DFS enabled for channel %d\n", hchan->chan->center_freq);
> > +#endif
> 
> Please spare the #ifdef and just call something within dfs.c, then
> dfs.h would wrap it to nothing if DFS is disabled.
Why would anyone want to disable DFS driver support?
I would say: drop the ifdefs altogether since DFS
is and will be "required".

Regards,
	Chr
