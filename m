Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:55942 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbcBAWxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 17:53:30 -0500
Date: Mon, 1 Feb 2016 23:53:20 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Sven Eckelmann <sven@open-mesh.com>
Cc: linux-wireless@vger.kernel.org, thomas@net.t-labs.tu-berlin.de,
	antonio@open-mesh.com, nbd@nbd.name, johannes@sipsolutions.net
Subject: Re: [PATCHv3] mac80211: minstrel: Change expected throughput unit
 back to Kbps
Message-ID: <20160201225320.GB6507@sig21.net> (sfid-20160201_235336_119520_B13465A9)
References: <1454364016-3234-1-git-send-email-sven@open-mesh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454364016-3234-1-git-send-email-sven@open-mesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sven,

On Mon, Feb 01, 2016 at 11:00:16PM +0100, Sven Eckelmann wrote:
> -	tp_avg = minstrel_ht_get_tp_avg(mi, i, j, prob) * AVG_PKT_SIZE * 8 / 1024;
> +	tp_avg = minstrel_ht_get_tp_avg(mi, i, j, prob) * 10;
> +	tp_avg *= AVG_PKT_SIZE * 8 / 1024;

This doesn't look right, in integer arithmetics there is a big
difference between (a * b) / c and a * ( b / c).


Johannes
