Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:2394 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752804Ab0G1I3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 04:29:39 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0908175777
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 17:29:37 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] iw: Add antenna configuration commands
Date: Wed, 28 Jul 2010 17:29:38 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20100727094932.27300.10253.stgit@tt-desk> <201007281107.04455.br1@einfach.org> <1280299848.3832.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1280299848.3832.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007281729.38652.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed July 28 2010 15:50:48 Johannes Berg wrote:
> On Wed, 2010-07-28 at 11:07 +0900, Bruno Randolf wrote:
> > On Tue July 27 2010 19:04:21 Johannes Berg wrote:
> > > On Tue, 2010-07-27 at 18:49 +0900, Bruno Randolf wrote:
> > > > +	if (tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
> > > > +	    tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
> > > > +		printf("\tAntenna: TX %d RX %d\n",
> > > > +		       nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX]),
> > > > +		       nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]));
> > > 
> > > That's like the worst possible way to show the info.
> > 
> > which way would you prefer?
> 
> It occurred to me later that with the normal numbers we have (1 through
> 7) it won't matter much ... but still, I'd prefer %#x.

ok. changed that and the command line parsing to use "strtoul(argv[1], &end, 
0)" so we can use hex, decimal or octal for the setting. i will resend the 
patches once a consensus is reached (or after an unspecified timeout ;)).

bruno
