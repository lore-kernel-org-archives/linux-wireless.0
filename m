Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47521 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZFEGcS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 02:32:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2009 23:32:20 -0700
Date: Fri, 5 Jun 2009 12:00:59 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 01/15] ath9k: fix oops by downgrading assert in rc.c
Message-ID: <20090605063059.GF17632@vasanth-laptop>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com> <1244180502-4323-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1244180502-4323-2-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +
> +       /*
> +        * Fine tuning for when no decent rate was found, the
> +        * lowest should *not* be used under normal circumstances.
> +        */
> +       if (rix == ath_rc_priv->valid_rate_index[0]) {
> +               DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
> +                       "disabling MRR\n");
> +               rates[0].idx = rate_lowest_index(sband, sta);
> +               /* Disable MRR when ath_rc_ratefind_ht() found rate 0 */
> +               rates[1].idx = -1;
> +       }

I think we can still fill other rates (1..3) with the lowest rate
index as we dont differentiate the situation where the lowest rate
is chosen truely by the algorithm from this particular case. 

Vasanth
