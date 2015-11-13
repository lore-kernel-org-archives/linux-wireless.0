Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38153 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbbKMGUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 01:20:08 -0500
Received: by wmec201 with SMTP id c201so16456627wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 22:20:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87mvuj585b.fsf@kamboji.qca.qualcomm.com>
References: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
	<1447161055-2283-1-git-send-email-michal.kazior@tieto.com>
	<87mvuj585b.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 13 Nov 2015 07:20:06 +0100
Message-ID: <CA+BoTQnQioRd_aR4+DVRsR942JoCAH1dUc2fdWX-Td7=j5++NA@mail.gmail.com> (sfid-20151113_072012_799680_29CB0B84)
Subject: Re: [PATCH v2 0/9] ath10k: clean up ath10k_skb_cb
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 November 2015 at 20:29, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> The ath10k_skb_cb structure wasn't really space
>> efficient. Some stuff is removed or replaced with
>> more compact representation.
>>
>> This cleanup is necessary for future features.
>>
>> The size of ath10k_skb_cb:
>>
>>           before   after
>>  x86-32   26       12
>>  x86-64   34       20
>>
>>
>> v2:
>>  * fix a bug (patch 7/9 introduced)
>>
>>
>> Michal Kazior (9):
>>   ath10k: merge is_protected with nohwcrypt
>>   ath10k: rename function to adhere to naming convention
>>   ath10k: remove txmode from skb_cb
>>   ath10k: remove is_offchan
>>   ath10k: remove freq from skb_cb
>>   ath10k: pack up flags in skb_cb
>>   ath10k: fix tx header parsing
>>   ath10k: replace vdev_id and tid in skb cb
>>   ath10k: store msdu_id instead of txbuf pointers
>
> I have a conflict which I can't fix myself:
>
> Applying: ath10k: merge is_protected with nohwcrypt
> Applying: ath10k: rename function to adhere to naming convention
> Applying: ath10k: remove txmode from skb_cb
> Applying: ath10k: remove is_offchan
> fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/mac.c).
> Repository lacks necessary blobs to fall back on 3-way merge.
> Cannot fall back to three-way merge.
> Patch failed at 0004 ath10k: remove is_offchan

Ah, sorry. I thought I rebased on top of your master branch but it
looks like I didn't. Let me fix that..


Michał
