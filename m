Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40291 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbbKLT3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 14:29:20 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/9] ath10k: clean up ath10k_skb_cb
References: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
	<1447161055-2283-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 12 Nov 2015 21:29:04 +0200
In-Reply-To: <1447161055-2283-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 10 Nov 2015 14:10:46 +0100")
Message-ID: <87mvuj585b.fsf@kamboji.qca.qualcomm.com> (sfid-20151112_202923_992918_0F81A6C8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The ath10k_skb_cb structure wasn't really space
> efficient. Some stuff is removed or replaced with
> more compact representation.
>
> This cleanup is necessary for future features.
>
> The size of ath10k_skb_cb:
>
>           before   after
>  x86-32   26       12
>  x86-64   34       20
>
>
> v2:
>  * fix a bug (patch 7/9 introduced)
>
>
> Michal Kazior (9):
>   ath10k: merge is_protected with nohwcrypt
>   ath10k: rename function to adhere to naming convention
>   ath10k: remove txmode from skb_cb
>   ath10k: remove is_offchan
>   ath10k: remove freq from skb_cb
>   ath10k: pack up flags in skb_cb
>   ath10k: fix tx header parsing
>   ath10k: replace vdev_id and tid in skb cb
>   ath10k: store msdu_id instead of txbuf pointers

I have a conflict which I can't fix myself:

Applying: ath10k: merge is_protected with nohwcrypt
Applying: ath10k: rename function to adhere to naming convention
Applying: ath10k: remove txmode from skb_cb
Applying: ath10k: remove is_offchan
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/mac.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0004 ath10k: remove is_offchan

-- 
Kalle Valo
