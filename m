Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:44705 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937462AbXLQUSk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 15:18:40 -0500
Message-ID: <4766D99D.5090507@garzik.org> (sfid-20071217_201854_773250_D168D2C9)
Date: Mon, 17 Dec 2007 15:18:37 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net
Subject: Re: Please pull 'fixes-jgarzik' branch of wireless-2.6
References: <20071216043148.GE3096@tuxdriver.com> <20071217193402.GD3121@tuxdriver.com>
In-Reply-To: <20071217193402.GD3121@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sat, Dec 15, 2007 at 11:31:48PM -0500, John W. Linville wrote:
> 
>> Cyrill Gorcunov (2):
>>       ieee80211_rate: missed unlock
> 
>>  net/mac80211/ieee80211_rate.c                  |    1 +
> 
>> diff --git a/net/mac80211/ieee80211_rate.c b/net/mac80211/ieee80211_rate.c
>> index 7254bd6..3260a4a 100644
>> --- a/net/mac80211/ieee80211_rate.c
>> +++ b/net/mac80211/ieee80211_rate.c
>> @@ -33,6 +33,7 @@ int ieee80211_rate_control_register(struct rate_control_ops *ops)
>>  		if (!strcmp(alg->ops->name, ops->name)) {
>>  			/* don't register an algorithm twice */
>>  			WARN_ON(1);
>> +			mutex_unlock(&rate_ctrl_mutex);
>>  			return -EALREADY;
>>  		}
>>  	}
> 
> Crud...there is a one-line fix in here that should have gone to Dave.
> 
> Jeff, (assuming Dave ACKs it) would you mind just taking it your
> way along with the other posted patches?  Since this is intended for
> 2.6.24, there should be no great maintenance hardship if it goes to
> Linus through your tree instead of Dave's.

Will do...

	Jeff




