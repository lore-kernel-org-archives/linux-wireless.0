Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36359 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbcAZTFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 14:05:47 -0500
Message-ID: <56A7C2ED.4010809@codeaurora.org> (sfid-20160126_200552_900044_FEB5C86E)
Date: Tue, 26 Jan 2016 11:03:09 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 13/13] ath10k: implement push-pull tx
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>	<1453384006-31907-14-git-send-email-michal.kazior@tieto.com>	<56A1182A.4060309@codeaurora.org>	<CA+BoTQnOfc-obhJR7woqg1=ZWBeOEDSQsaXTF1-wqH8V-Z-eRg@mail.gmail.com> <CA+BoTQ=ujALZiD5njhd=4e6iASJpxUeL7Kh_Pe_1zbAe9hLYcw@mail.gmail.com>
In-Reply-To: <CA+BoTQ=ujALZiD5njhd=4e6iASJpxUeL7Kh_Pe_1zbAe9hLYcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 01/26/2016 02:28 AM, Michal Kazior wrote:
> On 22 January 2016 at 08:47, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 21 January 2016 at 18:40, Peter Oh <poh@codeaurora.org> wrote:
>>> On 01/21/2016 05:46 AM, Michal Kazior wrote:
> [...]
>>>>    -     /* TODO: apply configuration */
>>>> +       rcu_read_unlock();
>>>> +
>>>> +       spin_lock_bh(&ar->htt.tx_lock);
>>>> +       ath10k_mac_tx_lock(ar, ATH10K_TX_PAUSE_Q_FLUSH_PENDING);
>>>> +       spin_unlock_bh(&ar->htt.tx_lock);
>>>> +
>>> Isn't it proved it break Mesh from working?
>> Yes, good point. I'm still working on this - I should've mentioned
>> that in the cover letter.
>>
>> Nonetheless I wanted to get the review process going for this patchset.
>>
>> I'll address the mesh problem in v2.
> For the record - the problem turned out to be a bug in mac80211 mesh
> fwding, see:
>
>    https://patchwork.kernel.org/patch/8108711/
I've verified that the patch fixed the mesh issue.
Thank you Michal.
>
>
> Michał

