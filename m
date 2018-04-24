Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55884 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755754AbeDXICu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 04:02:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Anilkumar Kolli <akolli@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] ath10k: report tx rate using ieee80211_tx_status()
References: <1524291786-30850-1-git-send-email-akolli@codeaurora.org>
Date: Tue, 24 Apr 2018 11:02:46 +0300
In-Reply-To: <1524291786-30850-1-git-send-email-akolli@codeaurora.org>
        (Anilkumar Kolli's message of "Sat, 21 Apr 2018 11:53:06 +0530")
Message-ID: <87zi1tav6h.fsf@kamboji.qca.qualcomm.com> (sfid-20180424_100254_825310_7775D854)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anilkumar Kolli <akolli@codeaurora.org> writes:

> Mesh path metric needs txrate information from ieee80211_tx_status()
> call but in ath10k there is no mechanism to report tx rate information
> via ieee80211_tx_status(), the rate is only accessible via
> sta_statiscs() op.
>
> Per peer stats has tx rate info available, this patch stores per peer
> last tx rate and updates the tx rate info structures in tx completition.
> The rate updated in ieee80211_tx_status() is not exactly for the last
> transmitted frame instead the rate is from one of the previous frames.
>
> Per peer txrate information is updated through per peer statistics
> and is available for QCA9888/QCA9984/QCA4019/QCA998X only
>
> Tested on QCA9984 with firmware-5.bin_10.4-3.5.3-00053
> Tested on QCA998X with firmware-5.bin_10.2.4-1.0-00036
>
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>

BTW, your name in patchwork is "akolli@codeaurora.org" but it should be
"Anilkumar Kolli" and that's why my script uses the wrong name. Please
fix it by registering to patchwork as it's possible to change your name
during registration, but only one time. If that doesn't work then send a
request to helpdesk@kernel.org and the admins will fix it.

-- 
Kalle Valo
