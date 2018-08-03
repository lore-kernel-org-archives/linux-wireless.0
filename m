Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728122AbeHCLXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 07:23:53 -0400
Date: Fri, 3 Aug 2018 11:28:23 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Wireless <linux-wireless@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mt76x0: build driver only as module
Message-ID: <20180803092822.GD10284@redhat.com> (sfid-20180803_112836_360503_DCDEA989)
References: <20180803091401.GB10284@redhat.com>
 <87zhy36c4n.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87zhy36c4n.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 03, 2018 at 12:19:20PM +0300, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > There are various symbols that conflicts with mt7601u.
> > Due to that kernel will not build with allyesconfig.
> > For now limit the driver to be build only as module.
> >
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> Thanks for the quick patch!
> 
> > --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> > +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> > @@ -11,7 +11,7 @@ config MT76x2_COMMON
> >  
> >  config MT76x0U
> >  	tristate "MediaTek MT76x0U (USB) support"
> > -	depends on MAC80211
> > +	depends on MAC80211 && m
> 
> But this feels like an ugly hack to me. Isn't there a better way to fix
> this? (I don't have time to investigate the error in detail right now.)

Yes, rename symbols names. And I will do this, just wanted to provide
quick fix for the problem. 

Moreover seems the same thing should be done for mt7601u to avoid build
errors and perhaps with mt76 :-( 

So I'm going to rename functions.

Regards
Stanislaw 
