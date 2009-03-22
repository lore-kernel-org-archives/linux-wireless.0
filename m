Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36028 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212AbZCVWN1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 18:13:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: Kernel panic with zd1211rw and today's compat-wireless
Date: Sun, 22 Mar 2009 23:12:07 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Alexander E. Patrakov" <patrakov@gmail.com>,
	linux-wireless@vger.kernel.org
References: <20090322174515.22f11d92@home.aephome.ru> <200903221609.26412.mb@bu3sch.de> <20090322220421.GG18141@hash.localnet>
In-Reply-To: <20090322220421.GG18141@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903222312.07360.mb@bu3sch.de> (sfid-20090322_231334_463785_4BBBF393)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 22 March 2009 23:04:21 Bob Copeland wrote:
> On Sun, Mar 22, 2009 at 04:09:26PM +0100, Michael Buesch wrote:
> > Is it possible that the skb->cb (where I guess the RX status and TX status
> > are stored) is getting corrupted after the skb got queued by the driver for
> > processing in the RX or TX status tasklet?
> 
> Hmm, that's an interesting possibility, and yeah that is stored in cb, for
> TX at least:

Ok, at least for the RX path the corruption was in the b43 driver.
See "[PATCH] b43: fix b43_plcp_get_bitrate_idx_ofdm return type".

So there's probably no cb corruption going on...

> >    struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> 
> I did debug it on the driver side and the rates I was sending back to the 
> RC were fine.  
> 



-- 
Greetings, Michael.
