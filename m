Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2836 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373AbZCVWHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 18:07:01 -0400
Date: Sun, 22 Mar 2009 18:04:21 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Alexander E. Patrakov" <patrakov@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Kernel panic with zd1211rw and today's compat-wireless
Message-ID: <20090322220421.GG18141@hash.localnet> (sfid-20090322_230724_653450_00E96449)
References: <20090322174515.22f11d92@home.aephome.ru> <1237726612.19647.2.camel@johannes.local> <b6c5339f0903220749j5373d132gdf24edc4d6ac610c@mail.gmail.com> <200903221609.26412.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200903221609.26412.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 22, 2009 at 04:09:26PM +0100, Michael Buesch wrote:
> Is it possible that the skb->cb (where I guess the RX status and TX status
> are stored) is getting corrupted after the skb got queued by the driver for
> processing in the RX or TX status tasklet?

Hmm, that's an interesting possibility, and yeah that is stored in cb, for
TX at least:
    
>    struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);

I did debug it on the driver side and the rates I was sending back to the 
RC were fine.  

-- 
Bob Copeland %% www.bobcopeland.com

