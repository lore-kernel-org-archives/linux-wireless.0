Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31878 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2HPGc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 02:32:56 -0400
Message-ID: <502C9410.6030307@qca.qualcomm.com> (sfid-20120816_083259_719808_88EFB6C8)
Date: Thu, 16 Aug 2012 09:32:48 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 1/2] ath6kl: Fix potential skb double free in ath6kl_wmi_sync_point()
References: <1344919234-5012-1-git-send-email-vthiagar@qca.qualcomm.com> <502A60BB.7000106@qca.qualcomm.com> <502C9160.3000401@qca.qualcomm.com>
In-Reply-To: <502C9160.3000401@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2012 09:21 AM, Vasanthakumar Thiagarajan wrote:
> On Tuesday 14 August 2012 07:59 PM, Kalle Valo wrote:
>> On 08/14/2012 07:40 AM, Vasanthakumar Thiagarajan wrote:
>>> skb given to ath6kl_control_tx() is owned by ath6kl_control_tx().
>>> Calling function should not free the skb for error cases.
>>> This is found during code review.
>>>
>>> Signed-off-by: Vasanthakumar Thiagarajan<vthiagar@qca.qualcomm.com>
>>
>> Thanks, both applied. There was a checkpatch warning about parenthesis
>> alignment in the first patch but I fixed it.
> 
> Thanks, but for some reason i dont see any checkpatch warnings.

I'm using --strict which enables even more checks. But with latest
checkpatch there are false warnings (IMHO) so I have to use an older
version of checkpatch. But don't worry about that, it's enough that you
run checkpatch without --strict, I can deal with the rest.

Kalle
