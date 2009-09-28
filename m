Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:64884 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZI1PZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 11:25:08 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [RFC] libertas: first stab at cfg80211 support
Date: Mon, 28 Sep 2009 17:24:59 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
References: <200909281321.21600.h.schurig@mn-solutions.de>
In-Reply-To: <200909281321.21600.h.schurig@mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909281724.59854.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm, I see two problems with my code:

> +struct wireless_dev *lbs_wdev_alloc(int sizeof_priv, struct 
device *dev)
> +{
...
> +	wdev->wiphy = wiphy_new(&lbs_cfg80211_ops,
> +		sizeof(struct lbs_private) + sizeof_priv);
...

and later:

> +	wdev = lbs_wdev_alloc(sizeof(struct lbs_private), dmdev);

That's rubbish, I now allocate "sizeof(lbs_private)" bytes twice.



Another thing is that it might be necessary to unbundle the
call of "wiphy_new()" and wiphy_register().

I need lbs_private allocated and usable, e.g. in 
lbs_start_card().

Later, in lbs_start_card(), when I query the firmware about it's 
capabilites I know enought to populate wiphy->bands. Only then 
should I call wiphy_register().

-- 
http://www.holgerschurig.de
