Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34305 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbeICLyU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 07:54:20 -0400
Subject: Re: [EXT] [BUG] net: wireless: mwifiex: A possible
 sleep-in-atomic-context bug in mwifiex_wait_queue_complete()
To: Ganapathi Bhat <gbhat@marvell.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <35980039-f268-2db3-5c7d-19ab0c917d44@gmail.com>
 <5fbe17917c344f318c25a688f2e94823@SC-EXCH02.marvell.com>
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <3ecba946-7656-3f86-df81-c0b5aff2e3d3@gmail.com> (sfid-20180903_093538_745710_7A592AF1)
Date: Mon, 3 Sep 2018 15:35:23 +0800
MIME-Version: 1.0
In-Reply-To: <5fbe17917c344f318c25a688f2e94823@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2018/9/3 14:41, Ganapathi Bhat wrote:
> Hi Jia-Ju,
>
>> [FUNC] schedule_timeout
>> drivers/net/wireless/marvell/mwifiex/sta_ioctl.c, 63:
>>       schedule_timeout in mwifiex_wait_queue_complete
>> drivers/net/wireless/marvell/mwifiex/cmdevt.c, 673:
>>       mwifiex_wait_queue_complete in mwifiex_send_cmd
> Here, mwifiex_send_cmd does not call mwifiex_wait_queue_complete, because the sync parameter is false.
> Note that the function mwifiex_multi_chan_resync did call mwifiex_send_cmd with sync = false.

Thanks for the reply.
I check the code again, and find my report it false, sorry for that.


Best wishes,
Jia-Ju Bai
