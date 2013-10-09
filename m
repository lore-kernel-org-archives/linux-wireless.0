Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:57467 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3JIC7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 22:59:08 -0400
Received: by mail-bk0-f52.google.com with SMTP id e11so62440bkh.39
        for <linux-wireless@vger.kernel.org>; Tue, 08 Oct 2013 19:59:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87siwbr2sc.fsf@kamboji.qca.qualcomm.com>
References: <1380805765-31521-1-git-send-email-michal.kazior@tieto.com>
	<1380865425-3791-1-git-send-email-michal.kazior@tieto.com>
	<1380865425-3791-2-git-send-email-michal.kazior@tieto.com>
	<87mwmjsz2k.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=qep+rKEyLKrNjNP6K1q+FHKpvkscwXuRMR_45YnRvHA@mail.gmail.com>
	<87siwbr2sc.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 8 Oct 2013 19:59:06 -0700
Message-ID: <CA+BoTQkPRAVz_2mwv7bL4SEBkQ5BT-4mBvBY7vwNadJkfv9o4w@mail.gmail.com> (sfid-20131009_045924_590814_B87DD8E0)
Subject: Re: [PATCH/RFT v2 1/4] ath10k: fix add_interface failure handling
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 October 2013 12:16, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 8 October 2013 05:54, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Michal Kazior <michal.kazior@tieto.com> writes:
>>>
>>>> If something failed along add_interface() setup it
>>>> was possible to leak a vdev id, vdev and peer.
>>>>
>>>> This could end up with leaked FW state or FW crash
>>>> (assuming add_interface() failure wasn't a result of
>>>> a crash).
>>>>
>>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>>
>>> Then I apply this patch on top of current ath.git master branch (commit
>>> 18fe0b53e76) interface up fails on the managed mode:
>>>
>>> $ sudo ip link set wlan1 up
>>> RTNETLINK answers: Invalid argument
>>>
>>> Logs don't have anything special (the TX encap error was already
>>> before):
>>>
>>> [ 1259.818863] ath10k: MSI-X didn't succeed (1), trying MSI
>>> [ 1259.819298] ath10k_pci 0000:02:00.0: irq 49 for MSI/MSI-X
>>> [ 1259.820055] ath10k: MSI interrupt handling
>>> [ 1260.747877] ath10k: UART prints disabled
>>> [ 1260.828219] ath10k: firmware 10.1.389 booted
>>> [ 1260.837585] ath10k: htt target version 2.1
>>> [ 1260.838498] ath10k: Failed to set TX encap: -22
>>
>> Ah. Right. I've tested this patch with main FW branch which supports
>> TX encap command. The TX encap issue should be dealth with first.
>
> What do you mean? Did I miss a patch?

You didn't miss any patch.

I think you've already pointed out the TX encap warning in your other email.

It's the TX encap that most likely gets you "invalid argument" when
trying to bring up the interface with my patch as FW 10.1.389 doesn't
support the command.


Michał
