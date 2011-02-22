Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35854 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1BVND2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 08:03:28 -0500
Received: by iyb26 with SMTP id 26so1760909iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 05:03:27 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19811.46111.864480.892504@gargle.gargle.HOWL>
Date: Tue, 22 Feb 2011 18:33:27 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 12/23] ath9k_htc: Maintain individual counters for interfaces
In-Reply-To: <20110222050302.GA11916@vmraj-lnx.users.atheros.com>
References: <19809.52131.619464.414079@gargle.gargle.HOWL>
	<20110222050302.GA11916@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> > +	if (priv->num_ibss_vif ||
> > +	    (priv->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
> > +		ath_err(common, "IBSS coexistence with other modes is not allowed\n");
> > +		mutex_unlock(&priv->mutex);
> > +		return -ENOBUFS;
> >  	}
> Need to handle IBSS interface if vifs are already present.

I don't understand, addition of a new IBSS interface is denied if we
already have an ADHOC interface present, or any other type, for that matter.
This could be simplified, but this behavior might change in the future ...

Sujith
