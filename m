Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60212 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbeEAAOV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 20:14:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 01 May 2018 05:44:19 +0530
From: Sriram R <srirrama@codeaurora.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: Re: [PATCH 2/2 - linux-stable-4.4] ath10k: rebuild crypto header in
 rx data frames
In-Reply-To: <583dcb6821d9803277f60780385dff52@codeaurora.org>
References: <1525069587-19281-1-git-send-email-srirrama@codeaurora.org>
 <1525069587-19281-3-git-send-email-srirrama@codeaurora.org>
 <20180430190901.GB8415@kroah.com>
 <583dcb6821d9803277f60780385dff52@codeaurora.org>
Message-ID: <dc88bf84bb843958dceb401ca2e6be17@codeaurora.org> (sfid-20180501_021425_371130_FB1126E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-01 05:14, Sriram R wrote:
> On 2018-05-01 00:39, Greg KH wrote:
>> On Mon, Apr 30, 2018 at 11:56:27AM +0530, Sriram R wrote:
>>> Rx data frames notified through HTT_T2H_MSG_TYPE_RX_IND and
>>> HTT_T2H_MSG_TYPE_RX_FRAG_IND expect PN/TSC check to be done
>>> on host (mac80211) rather than firmware. Rebuild cipher header
>>> in every received data frames (that are notified through those
>>> HTT interfaces) from the rx_hdr_status tlv available in the
>>> rx descriptor of the first msdu. Skip setting RX_FLAG_IV_STRIPPED
>>> flag for the packets which requires mac80211 PN/TSC check support
>>> and set appropriate RX_FLAG for stripped crypto tail. Hw QCA988X,
>>> and QCA99X0 currently need the rebuilding of cipher header to
>>> perform PN/TSC check for replay attack.
>>> 
>>> [Upstream Commit : 7eccb738fce57cbe53ed903ccf43f9ab257b15b3]
>>> 
>>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
>>> Signed-off-by: Sriram R <srirrama@codeaurora.org>
>>> ---
>>>  drivers/net/wireless/ath/ath10k/htt_rx.c | 98 
>>> ++++++++++++++++++++++++++------
>>>  1 file changed, 82 insertions(+), 16 deletions(-)
>> 
>> This patch breaks the build.  Always test build your patches!
>> 
>> thanks,
>> 
>> greg k-h
> Hi Greg,
> 
>   This patch along with its dependency patches (in the following order)
> 
> f980ebc058c2 : mac80211: allow not sending MIC up from driver for HW 
> crypto
> f631a77ba920 : mac80211: allow same PN for AMSDU sub-frames
> cef0acd4d7d4 : mac80211: Add RX flag to indicate ICV stripped
> [PATCH 1/2 linux-stable-4.4] ath10k: Add new hw param to identify
> alignment for different chipsets
> 
Hi Greg,

  I feel this breaks since the above mentioned mac80211 commits are not 
available in this queue.

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/diff/queue-4.4/series?id=8e2985dd801f00640be6998ec831018a688bb221

Could you please check after these commits are queued as well before 
this patch is applied.

Please let me know if i miss something here so i could check from my 
side as well.

Thanks,
Sriram.R
> build fine when checked with v4.4.130.
> 
> Kindly let me know if you face any issues while trying out in this 
> order.
> 
> Thanks,
> Sriram.R
