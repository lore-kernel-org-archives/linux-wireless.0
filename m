Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:48941 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZLHIfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 03:35:14 -0500
Received: by ewy1 with SMTP id 1so2422991ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 00:35:20 -0800 (PST)
Date: Tue, 8 Dec 2009 10:20:32 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>
Subject: Re: signed vs unsigned bug in ath9k
Message-ID: <20091208082031.GA29753@bicker>
References: <20091207110736.GA1338@bicker> <20091207155542.GB19643@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091207155542.GB19643@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 07, 2009 at 07:55:42AM -0800, Luis R. Rodriguez wrote:
> On Mon, Dec 07, 2009 at 03:07:36AM -0800, Dan Carpenter wrote:
> > drivers/net/wireless/ath/ath9k/recv.c
> >    205          sta = ieee80211_find_sta(sc->hw, hdr->addr2);
> >    206          if (sta) {
> >    207                  an = (struct ath_node *) sta->drv_priv;
> >    208                  if (ds->ds_rxstat.rs_rssi != ATH9K_RSSI_BAD &&
> > 
> > ds->ds_rxstat.rs_rssi is a signed 8 bit so it will never be == ATH9K_RSSI_BAD.
> 
> ATH9K_RSSI_BAD is -128 and the minimum value for int8_t is -128 so why is it a bug?
> 

It could be that someone fixed this already in the net tree?  In mainline it's still
positive 128.

#define ATH9K_RSSI_BAD                  0x80

regards,
dan carpenter

> >    209                     !ds->ds_rxstat.rs_moreaggr)
> >    210                          ATH_RSSI_LPF(an->last_rssi, ds->ds_rxstat.rs_rssi);
> >    211                  last_rssi = an->last_rssi;
> >    212          }
> > 
> > I would normally just change the declaration to unsigned but it looks like
> > someone may have chosen to have it signed on purpose.
> 
> Yeah it comes from hardware.
> 
>   Luis
