Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50962 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2BFRsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 12:48:07 -0500
Message-ID: <4F30122E.3060004@qca.qualcomm.com> (sfid-20120206_184811_473343_EA6C2211)
Date: Mon, 6 Feb 2012 19:47:26 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath6kl: add blocking debugfs file for retrieving
 firmware logs
References: <20120206062327.20231.11602.stgit@localhost6.localdomain6> <20120206062340.20231.55630.stgit@localhost6.localdomain6> <20120206090654.GA3260@chvasanth-lnx> <4F2FC989.5000306@qca.qualcomm.com> <20120206150515.GA4024@chvasanth-lnx>
In-Reply-To: <20120206150515.GA4024@chvasanth-lnx>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2012 05:05 PM, Vasanthakumar Thiagarajan wrote:
> On Mon, Feb 06, 2012 at 02:37:29PM +0200, Kalle Valo wrote:
>> On 02/06/2012 11:06 AM, Vasanthakumar Thiagarajan wrote:
>>
>>> Why not to use simple_read_from_buffer()?, looks like it can also
>>> takes care of len == 0 case in the following check.
>>>
>>> if (pos >= available || !count)
>>>         return 0;
>>>
>>> when available (len) is 0, pos = available with
>>> ath6kl_fwlog_block_read().
>>
>> I actually used simple_read_from_buffer() first, but the problem is that
>> it assumes that there's just one buffer from which the data is copied.
>> But in this case there can be multiple buffers from which I copy data.
>>
>> Ok, that was a bit confusing, let's try to explain a bit differently :)
>>
>> If 'ppos > 0' (for example during the second function call)
>> simple_read_from_buffer() will try to copy from 'user_buf + ppos' but I
>> would want to copy from 'user_buf'.
> 
> I think you mean s/user_buf/buf.

Correct.

> Are you not making sure that the
> length of the data is not more than the requested one which is
> passed to copy_to_user() so that read() is always called with
> *ppos=0?. The following code seems to do that

But the function is called multiple times with increasing values of
*ppos as more data is returned to user space:

[  100.303747] ath6kl_fwlog_block_read(): *ppos 0
[  100.305252] ath6kl_fwlog_block_read(): *ppos 30116
[  101.768947] ath6kl_fwlog_block_read(): *ppos 31624
[  117.027469] ath6kl_fwlog_block_read(): *ppos 33124
[  117.090146] ath6kl_fwlog_block_read(): *ppos 34628
[  117.172338] ath6kl_fwlog_block_read(): *ppos 36128

So I can't assume that *ppos = 0.

Kalle
