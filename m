Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8230 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2BFMhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 07:37:36 -0500
Message-ID: <4F2FC989.5000306@qca.qualcomm.com> (sfid-20120206_133741_067570_0F8DE3A8)
Date: Mon, 6 Feb 2012 14:37:29 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath6kl: add blocking debugfs file for retrieving
 firmware logs
References: <20120206062327.20231.11602.stgit@localhost6.localdomain6> <20120206062340.20231.55630.stgit@localhost6.localdomain6> <20120206090654.GA3260@chvasanth-lnx>
In-Reply-To: <20120206090654.GA3260@chvasanth-lnx>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2012 11:06 AM, Vasanthakumar Thiagarajan wrote:
> On Mon, Feb 06, 2012 at 08:23:40AM +0200, Kalle Valo wrote:
>> When debugging firmware issues it's not always enough to get
>> the latest firmware logs, sometimes we need to get logs from a longer
>> period. To make this possible, add a debugfs file named fwlog_block. When
>> reading from this file ath6kl will send firmware logs whenever available
>> and otherwise it will block and wait for new logs.
>>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

[...]

>> +	not_copied = copy_to_user(user_buf, buf, len);
>> +	if (not_copied != 0) {
>> +		ret_cnt = -EFAULT;
>> +		goto out;
>> +	}
>> +
>> +	*ppos = *ppos + len;
> 
> Why not to use simple_read_from_buffer()?, looks like it can also
> takes care of len == 0 case in the following check.
> 
> if (pos >= available || !count)
>         return 0;
> 
> when available (len) is 0, pos = available with
> ath6kl_fwlog_block_read().

I actually used simple_read_from_buffer() first, but the problem is that
it assumes that there's just one buffer from which the data is copied.
But in this case there can be multiple buffers from which I copy data.

Ok, that was a bit confusing, let's try to explain a bit differently :)

If 'ppos > 0' (for example during the second function call)
simple_read_from_buffer() will try to copy from 'user_buf + ppos' but I
would want to copy from 'user_buf'.

Kalle
