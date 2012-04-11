Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:56747 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab2DKGWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 02:22:36 -0400
Message-ID: <4F852329.8080702@tieto.com> (sfid-20120411_082240_367708_54316C35)
Date: Wed, 11 Apr 2012 08:22:33 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: remove hw.conf.channel usage where possible
References: <1333004518-12068-1-git-send-email-michal.kazior@tieto.com> <20120410192035.GB9218@tuxdriver.com>
In-Reply-To: <20120410192035.GB9218@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/12 21:20, John W. Linville wrote:
> On Thu, Mar 29, 2012 at 09:01:58AM +0200, Michal Kazior wrote:
>> Removes hw.conf.channel usage from the following functions:
>>   * ieee80211_mandatory_rates
>>   * ieee80211_sta_get_rates
>>   * ieee80211_frame_duration
>>   * ieee80211_rts_duration
>>   * ieee80211_ctstoself_duration
>>
>> This is in preparation for multi-channel operation.
>>
>> Signed-off-by: Michal Kazior<michal.kazior@tieto.com>
>
>    CC      drivers/net/wireless/b43/xmit.o
> drivers/net/wireless/b43/xmit.c: In function ‘b43_generate_txhdr’:
> drivers/net/wireless/b43/xmit.c:293:4: warning: passing argument 4 of ‘ieee80211_generic_frame_duration’ makes integer from pointer without a cast
> include/net/mac80211.h:2870:8: note: expected ‘size_t’ but argument is of type ‘struct ieee80211_rate *’
> drivers/net/wireless/b43/xmit.c:293:4: error: too few arguments to function ‘ieee80211_generic_frame_duration’
> include/net/mac80211.h:2870:8: note: declared here
> make[2]: *** [drivers/net/wireless/b43/xmit.o] Error 1
> make[1]: *** [drivers/net/wireless/b43] Error 2
> make: *** [drivers/net/wireless/] Error 2
>

Oops! Sorry I missed that. I'll send PATCH v2.


-- 
Pozdrawiam / Best regards, Michal Kazior.
