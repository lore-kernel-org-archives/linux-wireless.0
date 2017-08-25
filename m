Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932981AbdHYOuo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 10:50:44 -0400
Date: Fri, 25 Aug 2017 16:50:43 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2800: fix TX_PIN_CFG setting for non MT7620 chips
Message-ID: <20170825145042.GA6959@redhat.com> (sfid-20170825_165139_664520_1DFDC705)
References: <20170825113828.GA3959@redhat.com>
 <20170825121508.GA1159@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825121508.GA1159@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 25, 2017 at 02:15:08PM +0200, Daniel Golle wrote:
> Hi Stanislaw,
> 
> On Fri, Aug 25, 2017 at 01:38:29PM +0200, Stanislaw Gruszka wrote:
> > Since commit 41977e86c984 ("rt2x00: add support for MT7620") we do not
> > initialize TX_PIN_CFG setting. This cause breakage at least on some
> > RT3573 devices. To fix the problem patch restores previous behaviour
> > for non MT7620 chips.
> > 
> > Fixes: 41977e86c984 ("rt2x00: add support for MT7620")
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1480829
> > Reported-and-tested-by: Jussi Eloranta <jussi.eloranta@csun.edu>
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > index d11c7b2..5672aec 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > @@ -3699,7 +3699,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
> >  	if (rt2x00_rt(rt2x00dev, RT3572))
> >  		rt2800_rfcsr_write(rt2x00dev, 8, 0);
> >  
> > -	rt2800_register_read(rt2x00dev, TX_PIN_CFG, &tx_pin);
> > +	if (rt2x00_rt(rt2x00dev, RT6352))
> > +		rt2800_register_read(rt2x00dev, TX_PIN_CFG, &tx_pin);
> 
> should be
> 
> 	tx_pin = rt2800_register_read(rt2x00dev, TX_PIN_CFG);
> 
> since the calling convention of rt2800_register_read was changed in
> commit eebd68e782 rt2x00: convert rt2800_register_read return type.
> Probably you based the patch on an outdated tree...?

Yes, is was on 4.12. Will post v2.

Thanks
Stanislaw
