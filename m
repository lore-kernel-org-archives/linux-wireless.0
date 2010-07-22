Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44136 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab0GVTpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 15:45:43 -0400
Date: Thu, 22 Jul 2010 15:35:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Carpenter <error27@gmail.com>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: potential null deref in minstrel_ht_update_caps()?
Message-ID: <20100722193543.GF2616@tuxdriver.com>
References: <20100722110933.GA17585@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100722110933.GA17585@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 01:09:33PM +0200, Dan Carpenter wrote:
> This is a smatch thing.
> 
> net/mac80211/rc80211_minstrel_ht.c +639 minstrel_ht_update_caps(15)
> 	warn: variable dereferenced before check 'sta'
>    631          struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
>    632          struct ieee80211_local *local = hw_to_local(mp->hw);
>    633          u16 sta_cap = sta->ht_cap.cap;
>                               ^^^^^^^^^^^^^^^
> 	Dereferenced here.
> 
>    634          int ack_dur;
>    635          int stbc;
>    636          int i;
>    637
>    638          /* fall back to the old minstrel for legacy stations */
>    639          if (sta && !sta->ht_cap.ht_supported) {
>                     ^^^
> 	Checked here.
> 
>    640                  msp->is_ht = false;
>    641                  memset(&msp->legacy, 0, sizeof(msp->legacy));
> 
> It seems like a bug, but I'm not sure how to deal with it.

I think that sta NULL check is unnecessary there.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
