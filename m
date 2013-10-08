Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63652 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab3JHTUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 15:20:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH/RFT v2 1/4] ath10k: fix add_interface failure handling
References: <1380805765-31521-1-git-send-email-michal.kazior@tieto.com>
	<1380865425-3791-1-git-send-email-michal.kazior@tieto.com>
	<1380865425-3791-2-git-send-email-michal.kazior@tieto.com>
	<87mwmjsz2k.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=qep+rKEyLKrNjNP6K1q+FHKpvkscwXuRMR_45YnRvHA@mail.gmail.com>
Date: Tue, 8 Oct 2013 22:16:51 +0300
In-Reply-To: <CA+BoTQ=qep+rKEyLKrNjNP6K1q+FHKpvkscwXuRMR_45YnRvHA@mail.gmail.com>
	(Michal Kazior's message of "Tue, 8 Oct 2013 09:49:59 -0700")
Message-ID: <87siwbr2sc.fsf@kamboji.qca.qualcomm.com> (sfid-20131008_212048_511597_FC5266A0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 8 October 2013 05:54, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> If something failed along add_interface() setup it
>>> was possible to leak a vdev id, vdev and peer.
>>>
>>> This could end up with leaked FW state or FW crash
>>> (assuming add_interface() failure wasn't a result of
>>> a crash).
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> Then I apply this patch on top of current ath.git master branch (commit
>> 18fe0b53e76) interface up fails on the managed mode:
>>
>> $ sudo ip link set wlan1 up
>> RTNETLINK answers: Invalid argument
>>
>> Logs don't have anything special (the TX encap error was already
>> before):
>>
>> [ 1259.818863] ath10k: MSI-X didn't succeed (1), trying MSI
>> [ 1259.819298] ath10k_pci 0000:02:00.0: irq 49 for MSI/MSI-X
>> [ 1259.820055] ath10k: MSI interrupt handling
>> [ 1260.747877] ath10k: UART prints disabled
>> [ 1260.828219] ath10k: firmware 10.1.389 booted
>> [ 1260.837585] ath10k: htt target version 2.1
>> [ 1260.838498] ath10k: Failed to set TX encap: -22
>
> Ah. Right. I've tested this patch with main FW branch which supports
> TX encap command. The TX encap issue should be dealth with first.

What do you mean? Did I miss a patch?

-- 
Kalle Valo
