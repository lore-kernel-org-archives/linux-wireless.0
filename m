Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52245 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbbFOMZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 08:25:45 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21886.50258.16025.465771@gargle.gargle.HOWL> (sfid-20150615_142552_385003_EAFC09D3)
Date: Mon, 15 Jun 2015 17:55:54 +0530
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC] ath9k: allow to receive probe request when offchannel
In-Reply-To: <CALhHN=r5FyRzG18KOmN7zFRhx2O4jjQ-MxUmRfcT9EKpmpbqig@mail.gmail.com>
References: <1433912583-15918-1-git-send-email-janusz.dziedzic@tieto.com>
	<CALhHN=r5FyRzG18KOmN7zFRhx2O4jjQ-MxUmRfcT9EKpmpbqig@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic wrote:
> >         case ATH_OFFCHANNEL_ROC_START:
> > +               /* Allow to receive probe requests */
> > +               rfilt = ath_calcrxfilter(sc);
> > +               rfilt |= ATH9K_RX_FILTER_PROBEREQ;
> > +               ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
> > +

ath9k_set_offchannel_state() would be a better place to do this,
since setting up various bits in the HW for offchannel operation
is done there. Also, it would make sure that the HW state is
retained when a chip reset is done for some reason.

Sujith
