Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:27814 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbbFHO7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 10:59:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Liu CF/TW <cfliu.tw@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] ath10k: add 'cryptmode' param to support raw tx injection and sw crypto.
References: <1433440033-49570-1-git-send-email-cfliu.tw@gmail.com>
Date: Mon, 8 Jun 2015 17:59:40 +0300
In-Reply-To: <1433440033-49570-1-git-send-email-cfliu.tw@gmail.com> (Liu CF's
	message of "Thu, 4 Jun 2015 10:47:13 -0700")
Message-ID: <87pp56gs9v.fsf@kamboji.qca.qualcomm.com> (sfid-20150608_165952_449855_DA256DE8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Liu CF/TW <cfliu.tw@gmail.com> writes:

> This change supports bypassing HW crypto engine by enabling raw Rx/Tx mode.
> This will enable use cases such as sw crypto and raw tx injection.
> This change introduces a new module param 'cryptmode'.

Please use full words, eg. sw -> software, hw -> hardware

> cryptmode:
>
>  0    Use HW crypto engine. Use native WiFi mode Tx/Rx encap

"Use hardware crypto engine with native Wi-Fi mode TX/RX encapsulation
to the firmware"

>  1    Use SW crypto engine. Use raw mode Tx/Rx encap

"Use sofware crypto engine from mac80211 with raw mode TX/RX
encapsulation to the firmware"

>  2    Supports both SW & HW crypto engine. Use raw mode Tx/Rx encap.

It's not clear how to use this. How does the user choose between SW or
HW crypto modes? Please document that fully in the commit log.

>  ath10k
>  cryptmode
>  param      Testing Status
>  -------    ---------------------------------
>     0       HW CCMP/TKIP tested ok.
>             Note: HW crypto bypass not supported by ath10k hw in native WiFi
>             mode.

What's "HW crypto bypass"? Please write the commit log so that everyone
can understand it.

>     1       - mac80211 SW crypto tested ok.
>             - raw Tx frame injection tested ok.

What does "mac80211 SW crypto tested ok" exactly mean?

>     2       HW CCMP/TKIP tested ok.
>             SW CCMP/TKIP tested ok.

How were the HW and SW modes chosen?

>             Tested raw Tx encrypted frame injection ok.

With HW or SW crypto mode?

-- 
Kalle Valo
