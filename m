Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53297 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbbFHOtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 10:49:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Liu CF/TW <cfliu.tw@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] ath10k: add 'cryptmode' param to support raw tx injection and sw crypto.
References: <1433440033-49570-1-git-send-email-cfliu.tw@gmail.com>
Date: Mon, 8 Jun 2015 17:49:01 +0300
In-Reply-To: <1433440033-49570-1-git-send-email-cfliu.tw@gmail.com> (Liu CF's
	message of "Thu, 4 Jun 2015 10:47:13 -0700")
Message-ID: <87twuigsrm.fsf@kamboji.qca.qualcomm.com> (sfid-20150608_164918_354097_962ED15E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Liu CF/TW <cfliu.tw@gmail.com> writes:

> This change supports bypassing HW crypto engine by enabling raw Rx/Tx mode.
> This will enable use cases such as sw crypto and raw tx injection.
> This change introduces a new module param 'cryptmode'.
>
> cryptmode:
>
>  0    Use HW crypto engine. Use native WiFi mode Tx/Rx encap
>
>  1    Use SW crypto engine. Use raw mode Tx/Rx encap
>
>  2    Supports both SW & HW crypto engine. Use raw mode Tx/Rx encap.
>
> Testing: used QCA988x hw 2.0 with firmware-4.bin_10.2.4.48 with backports-20150424
> (Skipped ATH10K_FW_FEATURE_RAW_MODE_SUPPORT check in core.c within this patch. 
>  Since none of the existing QCA official firmware has the feature bit set yet)
>
>  ath10k
>  cryptmode
>  param      Testing Status
>  -------    ---------------------------------
>     0       HW CCMP/TKIP tested ok.
>             Note: HW crypto bypass not supported by ath10k hw in native WiFi
>             mode.
>
>     1       - mac80211 SW crypto tested ok.
>             - raw Tx frame injection tested ok.
>
>     2       HW CCMP/TKIP tested ok.
>             SW CCMP/TKIP tested ok.
>             Tested raw Tx encrypted frame injection ok.
>
> Signed-off-by: Liu CF/TW <cfliu.tw@gmail.com>

Kbuild bot found a sparse warning:

>> drivers/net/wireless/ath/ath10k/core.c:34:14: sparse: symbol 'ath10k_cryptmode_param' was not declared. Should it be static?


-- 
Kalle Valo
