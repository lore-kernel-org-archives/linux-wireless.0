Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:59002 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbZLHQId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 11:08:33 -0500
Received: by ewy1 with SMTP id 1so2925915ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 08:08:39 -0800 (PST)
Date: Tue, 8 Dec 2009 18:08:43 +0200
From: Dan Carpenter <error27@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>
Subject: Re: signed vs unsigned bug in ath9k
Message-ID: <20091208160843.GB28661@bicker>
References: <20091207110736.GA1338@bicker> <20091207155542.GB19643@tux> <20091208082031.GA29753@bicker> <20091208144209.GC15172@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091208144209.GC15172@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 08, 2009 at 09:42:10AM -0500, John W. Linville wrote:
> On Tue, Dec 08, 2009 at 10:20:32AM +0200, Dan Carpenter wrote:
> > On Mon, Dec 07, 2009 at 07:55:42AM -0800, Luis R. Rodriguez wrote:
> > > On Mon, Dec 07, 2009 at 03:07:36AM -0800, Dan Carpenter wrote:
> > > > drivers/net/wireless/ath/ath9k/recv.c
> > > >    205          sta = ieee80211_find_sta(sc->hw, hdr->addr2);
> > > >    206          if (sta) {
> > > >    207                  an = (struct ath_node *) sta->drv_priv;
> > > >    208                  if (ds->ds_rxstat.rs_rssi != ATH9K_RSSI_BAD &&
> > > > 
> > > > ds->ds_rxstat.rs_rssi is a signed 8 bit so it will never be == ATH9K_RSSI_BAD.
> > > 
> > > ATH9K_RSSI_BAD is -128 and the minimum value for int8_t is -128 so why is it a bug?
> > > 
> > 
> > It could be that someone fixed this already in the net tree?  In mainline it's still
> > positive 128.
> > 
> > #define ATH9K_RSSI_BAD                  0x80
> 
> I queued a patch to fix that for 2.6.33.
> 

Grand.  Sorry for the noise.  We static checker people are all finding the same
bugs...

I have been trying to buy enough wifi cards to download the latest git, but 
apparently the English gentleman who generates them has been on a week
long drinking binge.  I have been here asking about it on five days out of the 
last seven...  :/

regards,
dan carpenter

> Hth!
> 
> John
> -- 
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
