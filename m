Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51830 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387662AbeHAKn7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 06:43:59 -0400
Date: Wed, 1 Aug 2018 10:59:14 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 12/14] mt76: Kconfig and Makefile for mt76x0 driver
Message-ID: <20180801085913.GC4526@redhat.com> (sfid-20180801_105934_557939_F9111A46)
References: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
 <1533040864-9026-13-git-send-email-sgruszka@redhat.com>
 <8736vy1r0j.fsf@purkki.adurom.net>
 <20180801082844.GB4526@redhat.com>
 <87600u8on6.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87600u8on6.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 01, 2018 at 11:41:33AM +0300, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > On Wed, Aug 01, 2018 at 10:32:12AM +0300, Kalle Valo wrote:
> >> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> >> 
> >> > Add Kconfig and Makefiles for mt76x0 driver. Now the driver
> >> > can be build.
> >> >
> >> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >> > ---
> >> >  drivers/net/wireless/mediatek/mt76/Kconfig         | 7 +++++++
> >> >  drivers/net/wireless/mediatek/mt76/Makefile        | 1 +
> >> >  drivers/net/wireless/mediatek/mt76/mt76x0/Makefile | 7 +++++++
> >> >  3 files changed, 15 insertions(+)
> >> >  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
> >> >
> >> > diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
> >> > index 69906c733a1c..850611ad347a 100644
> >> > --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> >> > +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> >> > @@ -9,6 +9,13 @@ config MT76x2_COMMON
> >> >  	tristate
> >> >  	depends on MT76_CORE
> >> >  
> >> > +config MT76x0U
> >> > +	tristate "MediaTek MT76x0U (USB) support"
> >> > +	depends on MAC80211
> >> > +	depends on USB
> >> > +	help
> >> > +	  This adds support for MT7610U-based wireless USB dongles.
> >> 
> >> Does it make sense to add a Kconfig option for every mt76 device? I'm
> >> worried that soon we have over a dozen of them. I can understand having
> >> separate options to enable PCI or USB devices, but I don't see the
> >> benefit for anything more finegrained than that.
> >
> > I think it does make sense for AP/home routers and other embedded
> > devices.
> 
> How much of memory savings are we talking about?

Currently mt76x0.ko module is 285 KB big on x86_64 after debug symbols
strip (with debug symbols size is 6MB).

Stanislaw
