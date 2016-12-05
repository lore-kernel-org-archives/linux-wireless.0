Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39890 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbcLEOrW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:47:22 -0500
Message-ID: <58457DF8.5020808@candelatech.com> (sfid-20161205_154725_359924_A4ACD3BA)
Date: Mon, 05 Dec 2016 06:47:20 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211:  Show pending txqlen in debugfs.
References: <1480442753-6830-1-git-send-email-greearb@candelatech.com>   (sfid-20161129_190601_478280_B404B299) <1480946371.31788.7.camel@sipsolutions.net>
In-Reply-To: <1480946371.31788.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/05/2016 05:59 AM, Johannes Berg wrote:
> +static ssize_t misc_read(struct file *file, char __user *user_buf,
>> +			 size_t count, loff_t *ppos)
>> +{
>> +	struct ieee80211_local *local = file->private_data;
>> +	size_t bufsz = 1000;
>> +	char *buf = kzalloc(bufsz, GFP_KERNEL);
>
> You need at most IEEE80211_MAX_QUEUES * 16 (==256) which I think you
> can put on the stack?

I actually run with 64 queues in my tree, and either way, I thought large-ish
things on the stack were frowned upon for systems that want to run smaller stacks?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
