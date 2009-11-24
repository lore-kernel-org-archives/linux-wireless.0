Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:44535 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933501AbZKXRM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:12:26 -0500
Received: by ey-out-2122.google.com with SMTP id 4so1312217eyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 09:12:31 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [rt2x00-users] [PATCH v2 1/8] rt2x00: Only initialize HT on  rt2800 devices that support it.
Date: Tue, 24 Nov 2009 18:12:29 +0100
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com> <1259012694-14869-2-git-send-email-gwingerde@gmail.com> <30353c3d0911231418s4aedc5c3vc9cfead334a02c3f@mail.gmail.com>
In-Reply-To: <30353c3d0911231418s4aedc5c3vc9cfead334a02c3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911241812.29532.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 November 2009, David Ellingsworth wrote:
> On Mon, Nov 23, 2009 at 4:44 PM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
> > Some RT28xx/RT30xx devices don't support 802.11n, when they are combined with
> > the RF2020 chipset. Ensure that HT is disabled for these devices.
> >
> > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> > ---
> >  drivers/net/wireless/rt2x00/rt2800lib.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> > index e94f1e1..fcd0c88 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> > @@ -2072,7 +2072,11 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> >        /*
> >         * Initialize HT information.
> >         */
> > -       spec->ht.ht_supported = true;
> > +       if (!rt2x00_rf(chip, RF2020))
> > +               spec->ht.ht_supported = true;
> > +       else
> > +               spec->ht.ht_supported = false;
> > +
> 
> Maybe I'm the only one, but I hate conditional statements with no
> meaning. Maybe this instead?
> 
> spec->ht.ht_supported = !rt2x00_rf(chip, RF2020);

I think this would look better as well. But either way you can add my:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
