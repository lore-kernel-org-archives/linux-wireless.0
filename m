Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:35697 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbFKN7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 09:59:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Liu CF/TW <cfliu.tw@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: add 'cryptmode' param to support raw tx injection and software crypto
References: <1433812382-10287-1-git-send-email-cfliu.tw@gmail.com>
Date: Thu, 11 Jun 2015 16:59:31 +0300
In-Reply-To: <1433812382-10287-1-git-send-email-cfliu.tw@gmail.com> (Liu CF's
	message of "Mon, 8 Jun 2015 18:13:02 -0700")
Message-ID: <87vbeubb24.fsf@kamboji.qca.qualcomm.com> (sfid-20150611_155946_922953_5238A6F2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Liu CF/TW <cfliu.tw@gmail.com> writes:

> This change supports hardware crypto engine bypass by enabling raw
> Rx/Tx encap mode. This enables use cases such as software crypto and raw
> tx injection. This change introduces a new module param 'cryptmode'.
>
> cryptmode:
>
>   0: Use hardware crypto engine globally with native Wi-Fi mode TX/RX
>      encapsulation to the firmware. This is the default mode.
>   1: Use sofware crypto engine globally with raw mode TX/RX encapsulation
>      to the firmware.

These two values are ok.

>   2: Supports both hardware and software crypto with raw mode TX/RX
>      encapsulation to the firmware. By default hardware crypto engine is
>      used. To use software crypto in this mode, set the per ath10k_vif
>      'nohwcrypt' flag value to True.*
>      *) The patch for setting vif specific 'nohwcrypt' flag when
>         cryptmode=2 would be a separate patch to mac80211.

But this the problematic one. I cannot apply something to ath10k until
Johannes applies the mac80211 part. Didn't I mention this already
earlier? At least I was supposed to do that.

And most importantly does Johannes even agree with the approach? IIRC he
was pretty reluctant about configuring the crypto mode via nl80211.

I suggest splitting the patch into two: patch 1 adding support for
cryptmode values 0 and 1, patch 2 adding support for cryptmode 2. That
way we can commit patch 1 early and see what we can do with patch 2.

-- 
Kalle Valo
