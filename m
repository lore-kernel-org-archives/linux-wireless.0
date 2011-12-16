Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46089 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab1LPCGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 21:06:25 -0500
Received: by ggdk6 with SMTP id k6so2342887ggd.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 18:06:25 -0800 (PST)
Date: Thu, 15 Dec 2011 18:06:20 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com
Subject: Re: [PATCH 3/3] ath9k: add DFS radar pulse processing
Message-ID: <20111216000804.GA1092@tux> (sfid-20111216_030629_271489_1979DA50)
References: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1323922595-15533-4-git-send-email-mcgrof@qca.qualcomm.com>
 <CAGRGNgXPFM4Yo4WM0mUp0=famt2JeLxSRAX=iVtYDiGo9r+RTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAGRGNgXPFM4Yo4WM0mUp0=famt2JeLxSRAX=iVtYDiGo9r+RTw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 03:58:32PM +1100, Julian Calaby wrote:
> > diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
> > index 390797d..783559c 100644
> > --- a/drivers/net/wireless/ath/ath9k/Makefile
> > +++ b/drivers/net/wireless/ath/ath9k/Makefile
> > @@ -10,6 +10,8 @@ ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
> >  ath9k-$(CONFIG_ATH9K_PCI) += pci.o
> >  ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
> >  ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
> > +ath9k-$(CONFIG_ATH9K_DEBUGFS) += dfs_debug.o
> 
> Shouldn't this config variable be CONFIG_ATH9K_DFS_DEBUGFS?

Yeap!

> You introduce that config variable but never use it.

Good catch.

> > +ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += dfs.o
> >
> >  obj-$(CONFIG_ATH9K) += ath9k.o
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.h b/drivers/net/wireless/ath/ath9k/dfs_debug.h
> > <etC>
> > +
> > +#if defined(CONFIG_ATH9K_DEBUGFS)
> 
> Same here.
> 
> > +
> > +#define DFS_STAT_INC(sc, c) (sc->debug.stats.dfs_stats.c++)
> > +void ath9k_dfs_init_debug(struct ath_softc *sc);
> > +
> > +#else
> > +
> > +#define DFS_STAT_INC(sc, c) do { } while (0)
> > +static inline void ath9k_dfs_init_debug(struct ath_softc *sc) { }
> > +
> > +#endif /* CONFIG_ATH9K_DEBUGFS */
> 
> And here =)

Thanks for the review, I just submitted a v2.

  Luis
