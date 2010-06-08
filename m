Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:30595 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751571Ab0FHBSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 21:18:55 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0649729933
	for <linux-wireless@vger.kernel.org>; Tue,  8 Jun 2010 10:18:53 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3 1/3] cfg80211: Add nl80211 antenna configuration
Date: Tue, 8 Jun 2010 10:19:10 +0900
References: <20100607065858.16060.38448.stgit@tt-desk> <1275901408.3639.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1275901408.3639.2.camel@jlt3.sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006081019.10217.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 June 2010 18:03:28 you wrote:
> On Mon, 2010-06-07 at 15:58 +0900, Bruno Randolf wrote:
> > +static int nl80211_get_antenna(struct sk_buff *skb, struct genl_info
> > *info) +{
> > +	struct cfg80211_registered_device *rdev;
> > +	struct sk_buff *msg;
> > +	void *hdr;
> > +	int res;
> > +	u8 tx_ant, rx_ant;
> 
> You should probably set them both to 0 here,

ok.
 
> > +	res = rdev->ops->get_antenna(&rdev->wiphy, &tx_ant, &rx_ant);
> > +	if (res)
> > +		goto free_msg;
> 
> and complain about the driver if they still are after this.

would that be a WARN_ON?

thanks,
bruno
