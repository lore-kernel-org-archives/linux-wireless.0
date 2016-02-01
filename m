Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53721 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbcBAMak (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:30:40 -0500
Message-ID: <1454329837.3211.2.camel@sipsolutions.net> (sfid-20160201_133043_798873_CE9E1C36)
Subject: Re: [PATCH] mac80211: minstrel: Scale expected_throughput by 10
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@open-mesh.com>, linux-wireless@vger.kernel.org
Cc: thomas@net.t-labs.tu-berlin.de, antonio@open-mesh.com, nbd@nbd.name
Date: Mon, 01 Feb 2016 13:30:37 +0100
In-Reply-To: <1454329450-31527-1-git-send-email-sven@open-mesh.com> (sfid-20160201_132429_424750_8B5B02B5)
References: <1454329450-31527-1-git-send-email-sven@open-mesh.com>
	 (sfid-20160201_132429_424750_8B5B02B5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-01 at 13:24 +0100, Sven Eckelmann wrote:
> The change from cur_tp to the function
> minstrel_get_tp_avg/minstrel_ht_get_tp_avg changed the unit used for
> the
> current throughtput. For example in minstrel_ht the correct
> conversion between them would be:
> 
>     mrs->cur_tp / 10 == minstrel_ht_get_tp_avg(..).
> 
> This factor 10 must also be included in the calculation of
> minstrel_get_expected_throughput and
> minstrel_ht_get_expected_throughput to
> get similar results as before the change.
> 

10 is a pretty expensive factor, perhaps that should use 16 instead?

johannes
