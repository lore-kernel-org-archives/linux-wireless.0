Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47200 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab1C2I4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 04:56:38 -0400
Received: by wya21 with SMTP id 21so3549746wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 01:56:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D916D55.3030008@lockie.ca>
References: <4D916D55.3030008@lockie.ca>
Date: Tue, 29 Mar 2011 14:26:37 +0530
Message-ID: <AANLkTimu8B0Bt4ZqE4QHxCt7OZtvwx0uxEXeFKQFyn7-@mail.gmail.com>
Subject: Re: trace == bug?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2011 at 10:55 AM, James <bjlockie@lockie.ca> wrote:
>
> WARNING: at drivers/net/wireless/ath/ath9k/recv.c:534
> ath_stoprecv+0xf3/0x100 [ath9k]()
> Call Trace:
>  [<ffffffff810353db>] ? warn_slowpath_common+0x7b/0xc0
>  [<ffffffffa0b8b043>] ? ath_stoprecv+0xf3/0x100 [ath9k]
>  [<ffffffffa0b879b3>] ? ath_set_channel+0xe3/0x280 [ath9k]
>  [<ffffffffa0b87f9e>] ? ath9k_config+0x44e/0x6d0 [ath9k]
>  [<ffffffffa009c320>] ? ieee80211_scan_work+0x0/0x580 [mac80211]
>  [<ffffffffa009bd75>] ? __ieee80211_scan_completed_finish+0x15/0x90
> [mac80211]
>  [<ffffffffa009c320>] ? ieee80211_scan_work+0x0/0x580 [mac80211]
>  [<ffffffff8104ae3b>] ? process_one_work+0xfb/0x3b0
>  [<ffffffff8104b514>] ? worker_thread+0x144/0x3d0
>  [<ffffffff81029050>] ? __wake_up_common+0x50/0x80
>  [<ffffffff8104b3d0>] ? worker_thread+0x0/0x3d0
>  [<ffffffff8104b3d0>] ? worker_thread+0x0/0x3d0
>  [<ffffffff8104ecc6>] ? kthread+0x96/0xa0
>  [<ffffffff81003014>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff8104ec30>] ? kthread+0x0/0xa0
>  [<ffffffff81003010>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace a8977d8ac5dc8425 ]---
>

ideally this should not happen(dma is not get stopped within the
timeout) and because of this we are hitting the warning.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
