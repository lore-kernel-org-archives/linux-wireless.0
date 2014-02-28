Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:45563 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaB1JHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 04:07:09 -0500
Received: by mail-ea0-f179.google.com with SMTP id q10so2464295ead.24
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 01:07:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <877g8fd32c.fsf@kamboji.qca.qualcomm.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-6-git-send-email-michal.kazior@tieto.com>
	<877g8fd32c.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 28 Feb 2014 10:07:08 +0100
Message-ID: <CA+BoTQk9z+Qp3+2QV0iBCaUkNzX=qkY_JKnzvinwyAKd6V6GdQ@mail.gmail.com> (sfid-20140228_100717_290435_17D38AFC)
Subject: Re: [PATCH v3 5/8] ath10k: batch htt tx/rx completions
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 February 2014 10:00, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> HTT Rx endpoint processes both frame rx
>> indications and frame tx completion indications.
>>
>> Those completions typically come in batches and
>> may be mixed so it makes sense to defer processing
>> hoping to get a bunch of them and take advantage
>> of hot caches.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> +void ath10k_htt_txrx_compl_task(unsigned long ptr)
>> +{
>> +     struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
>> +     struct htt_resp *resp;
>> +     struct sk_buff *skb;
>
> I think this can be a static function. Is it ok if I change this patch
> with the diff below?

I don't really mind.


Michał
