Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39316 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759042AbdAIKjz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 05:39:55 -0500
Message-ID: <1483958390.17582.16.camel@sipsolutions.net> (sfid-20170109_114113_080691_4077E97D)
Subject: Re: [PATCH v4] rfkill: Add rfkill-any LED trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82_K=C4=99pie=C5=84?= <kernel@kempniu.pl>
Cc: "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?=D0=9C=D0=B8=D1=85=D0=B0=D0=B8=D0=BB_?=
         =?UTF-8?Q?=D0=9A=D1=80=D0=B8=D0=BD=D0=BA=D0=B8=D0=BD?=
        <krinkin.m.u@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 09 Jan 2017 11:39:50 +0100
In-Reply-To: <20170106192027.GA756@kmp-mobile.hq.kempniu.pl> (sfid-20170106_202031_655798_4350A20F)
References: <20170106060747.6162-1-kernel@kempniu.pl>
         <1483705333.4089.6.camel@sipsolutions.net>
         <20170106192027.GA756@kmp-mobile.hq.kempniu.pl>
         (sfid-20170106_202031_655798_4350A20F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Looks better, but
> > 
> > > +static struct work_struct rfkill_any_work;
> > 
> > At least on module exit you need to cancel this work.
> 
> It is cancelled in rfkill_any_led_trigger_unregister().  It seemed
> fitting to do it this way as rfkill_any_work is initialized in
> rfkill_any_led_trigger_register().  And if CONFIG_RFKILL_LEDS=n,
> rfkill_any_work is neither initialized nor scheduled, so we should be
> good as well.  Am I missing something?

No, I just missed that, sorry.

Applied the patch now.

johannes
