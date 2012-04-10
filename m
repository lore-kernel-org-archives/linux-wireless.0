Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52133 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab2DJTc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 15:32:26 -0400
Date: Tue, 10 Apr 2012 15:20:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: remove hw.conf.channel usage where possible
Message-ID: <20120410192035.GB9218@tuxdriver.com> (sfid-20120410_213238_988561_739FB479)
References: <1333004518-12068-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1333004518-12068-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 29, 2012 at 09:01:58AM +0200, Michal Kazior wrote:
> Removes hw.conf.channel usage from the following functions:
>  * ieee80211_mandatory_rates
>  * ieee80211_sta_get_rates
>  * ieee80211_frame_duration
>  * ieee80211_rts_duration
>  * ieee80211_ctstoself_duration
> 
> This is in preparation for multi-channel operation.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

  CC      drivers/net/wireless/b43/xmit.o
drivers/net/wireless/b43/xmit.c: In function ‘b43_generate_txhdr’:
drivers/net/wireless/b43/xmit.c:293:4: warning: passing argument 4 of ‘ieee80211_generic_frame_duration’ makes integer from pointer without a cast
include/net/mac80211.h:2870:8: note: expected ‘size_t’ but argument is of type ‘struct ieee80211_rate *’
drivers/net/wireless/b43/xmit.c:293:4: error: too few arguments to function ‘ieee80211_generic_frame_duration’
include/net/mac80211.h:2870:8: note: declared here
make[2]: *** [drivers/net/wireless/b43/xmit.o] Error 1
make[1]: *** [drivers/net/wireless/b43] Error 2
make: *** [drivers/net/wireless/] Error 2

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
