Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:49254 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab0AVOOZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 09:14:25 -0500
MIME-Version: 1.0
Date: Fri, 22 Jan 2010 09:14:22 -0500
From: <pat-lkml@erley.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<lrodriguez@atheros.com>
Subject: Re: [RFC/RFT v2]: compat-wireless for 2.6.32.4 - multiqueue backport
 support
In-Reply-To: <1264152878.11396.82.camel@johannes.local>
References: <20100121230600.GC8069@bombadil.infradead.org> <1264152878.11396.82.camel@johannes.local>
Message-ID: <76acc753e1ea73bdffe1a9772f58bba2@127.0.0.1>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 22 Jan 2010 10:34:38 +0100, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-01-21 at 18:06 -0500, Luis R. Rodriguez wrote:
> 
>> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
>> +static bool ieee80211_all_queues_stopped(struct ieee80211_hw *hw)
> 
> You want "all queues started" :)
> 
Are you certain of this?  I stared and stared trying to see what case
the function would behave as a "started" check.  It loops through all 
queues, returning false if it finds any started queues.  If it makes
it through all the queues and hasn't found a single started queue, it
returns true (to indicate all queues are stopped).  

Or do you mean, as a second function?

>> +{
>> +	unsigned int queue;
>> +
>> +	for (queue = 0; queue < hw->queues; queue++)
>> +		if (!ieee80211_queue_stopped(hw, queue))
>> +			return false;
>> +	return true;
>> +}
>> +#endif
>> +
> johannes

Pat
