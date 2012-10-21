Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:44391 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab2JUQlZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 12:41:25 -0400
Message-ID: <50842576.1000808@ti.com> (sfid-20121021_184127_272579_A921751A)
Date: Sun, 21 Oct 2012 18:40:22 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<assaf@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 4/6] mac80211: add ability to enable TX on op-channel
References: <1350226137-13704-1-git-send-email-victorg@ti.com>  <1350226137-13704-5-git-send-email-victorg@ti.com> <1350414234.10177.14.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350414234.10177.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/10/2012 21:03, Johannes Berg wrote:
> On Sun, 2012-10-14 at 16:48 +0200, Victor Goldenshtein wrote:
>
>> +static int ieee80211_dfs_en_tx(struct wiphy *wiphy, struct net_device *dev,
>> +			       struct ieee80211_channel *chan)
>> +{
>> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +	struct ieee80211_local *local = sdata->local;
>> +	int ret = -ENOENT;
>> +
>> +	if (!local->ops->dfs_en_tx)
>> +		return -EOPNOTSUPP;
>> +
>> +	ret = drv_dfs_en_tx(local, sdata, chan);
>> +	return ret;
>

sorry, missed that one - I can resend v5 ?

-- 
Thanks,
Victor.
