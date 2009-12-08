Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42188 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbZLHOpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 09:45:09 -0500
Date: Tue, 8 Dec 2009 09:42:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Carpenter <error27@gmail.com>
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
Message-ID: <20091208144209.GC15172@tuxdriver.com>
References: <20091207110736.GA1338@bicker> <20091207155542.GB19643@tux> <20091208082031.GA29753@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091208082031.GA29753@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 08, 2009 at 10:20:32AM +0200, Dan Carpenter wrote:
> On Mon, Dec 07, 2009 at 07:55:42AM -0800, Luis R. Rodriguez wrote:
> > On Mon, Dec 07, 2009 at 03:07:36AM -0800, Dan Carpenter wrote:
> > > drivers/net/wireless/ath/ath9k/recv.c
> > >    205          sta = ieee80211_find_sta(sc->hw, hdr->addr2);
> > >    206          if (sta) {
> > >    207                  an = (struct ath_node *) sta->drv_priv;
> > >    208                  if (ds->ds_rxstat.rs_rssi != ATH9K_RSSI_BAD &&
> > > 
> > > ds->ds_rxstat.rs_rssi is a signed 8 bit so it will never be == ATH9K_RSSI_BAD.
> > 
> > ATH9K_RSSI_BAD is -128 and the minimum value for int8_t is -128 so why is it a bug?
> > 
> 
> It could be that someone fixed this already in the net tree?  In mainline it's still
> positive 128.
> 
> #define ATH9K_RSSI_BAD                  0x80

I queued a patch to fix that for 2.6.33.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
