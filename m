Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59666 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727478AbeICOiW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 10:38:22 -0400
Message-ID: <1535969922.3437.37.camel@sipsolutions.net> (sfid-20180903_121855_433464_E123555B)
Subject: Re: [RFC v2] ath10k: report tx rate using ieee80211_tx_status()
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date: Mon, 03 Sep 2018 12:18:42 +0200
In-Reply-To: <87k1o6d8hw.fsf@kamboji.qca.qualcomm.com>
References: <1524291786-30850-1-git-send-email-akolli@codeaurora.org>
         <87k1o6d8hw.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-08-31 at 15:29 +0300, Kalle Valo wrote:

> Too me this feels like a bad idea but I'm not familiar enough with
> mac80211 to really comment on this. What kind of implications does this
> have for Mesh or ATF, for example? Adding Johannes and Toke to hear
> about their opinion about this.

The biggest implication is probably radiotap. Beyond that, it's using
this to report the "last rate" to nl80211, but that's not all super
useful anyway.

The retry count is also affected, and since you report "somewhat
liberally" that would lead to erroneous statistics.

I'd recommend against doing this and disentangling the necessary code in
mac80211, e.g. with ieee80211_tx_status_ext() or adding similar APIs.

johannes
