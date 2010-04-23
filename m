Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:42978 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466Ab0DWSI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 14:08:58 -0400
Received: by ewy20 with SMTP id 20so3164263ewy.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Apr 2010 11:08:57 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: rt2800lib: disable HT40 for now as it causes reception problems
Date: Fri, 23 Apr 2010 20:08:54 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
References: <201004231505.29689.helmut.schaa@googlemail.com> <4BD1BAF8.1060908@gmail.com>
In-Reply-To: <4BD1BAF8.1060908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201004232008.55022.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 April 2010, Gertjan van Wingerde wrote:
> On 04/23/10 15:05, Helmut Schaa wrote:
> > Disable HT40 support for now as it causes rx problems with HT40 capable
> > 11n APs (when mac80211 enables HT40, rx is completely disfunctional).
> > 
> > Once the rt2800 HT code is capable of using HT40 we should enable the
> > flag again.
> > 
> > I only tested this patch with a rt305x SoC device, nevertheless the
> > patch disables HT40 also on PCI and USB rt2800 devices.
> > 
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> 
> I can confirm that this also helps for PCI and USB devices.
> With this patch applied all my rt28xx and rt30xx based devices starting working correctly.
> 
> So, definately,
> 
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

And also thanks for figuring this out, this at least gives a good starting
point for investigation for resolving the last issues. :)

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> > ---
> > 
> > Using this patch I was able to associate a rt305x SoC device with my 11n
> > capable AP using WPA and the connection basically works although I see lots
> > of retried frames when sniffing the wireless traffic.
> > 
> > If someone already had success with rt2800 and HT40 capable APs we should
> > consider to only conditionally unset the HT40 flag for 305x SoC devices.
> > 
> >  drivers/net/wireless/rt2x00/rt2800lib.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> > index 2648f31..aa02ff6 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> > @@ -2318,8 +2318,11 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> >  	else
> >  		spec->ht.ht_supported = false;
> >  
> > +	/*
> > +	 * Don't set IEEE80211_HT_CAP_SUP_WIDTH_20_40 for now as it causes
> > +	 * reception problems with HT40 capable 11n APs
> > +	 */
> >  	spec->ht.cap =
> > -	    IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
> >  	    IEEE80211_HT_CAP_GRN_FLD |
> >  	    IEEE80211_HT_CAP_SGI_20 |
> >  	    IEEE80211_HT_CAP_SGI_40 |
> 
> 


