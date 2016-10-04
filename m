Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44310 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752123AbcJDPeT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 11:34:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/4] ath10k: implement offset_tsf ieee80211_op
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160928235631.9197-3-twp@qca.qualcomm.com>
References: <20160928235631.9197-3-twp@qca.qualcomm.com>
To: "Pedersen, Thomas" <twp@qca.qualcomm.com>
CC: ath10k <ath10k@lists.infradead.org>,
        Thomas Pedersen <twp@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <ab600f17c1044dce96d9e58f26ebeb63@euamsexm01a.eu.qualcomm.com> (sfid-20161004_173423_230779_853EA43C)
Date: Tue, 4 Oct 2016 17:34:12 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Pedersen, Thomas" <twp@qca.qualcomm.com> wrote:
> Current set_tsf is implemented in terms of TSF_INCREMENT
> only. Instead support new WMI command TSF_DECREMENT and
> export these through offset_tsf. Advantage is we get
> more accurate TSF adjustments, and don't calculate wrong
> offset in case absolute TSF was calculated from rx_mactime
> (actual TSF).
> 
> The new WMI command is available in firmware
> 10.4-3.2.1-00033 for QCA4019 chips. Old drivers on new
> firmware or vice versa shouldn't  be a problem since
> get/set tsf logic was already broken.
> 
> Signed-off-by: Thomas Pedersen <twp@qca.qualcomm.com>

Depends on:

3a53731df7e2 mac80211: mesh: decrease max drift
354d381baf11 mac80211: add offset_tsf driver op and use it for mesh

2 patches set to Awaiting Upstream.

9355377 [2/4] ath10k: implement offset_tsf ieee80211_op
9355375 [3/4] ath10k: remove set/get_tsf ieee80211_ops

-- 
https://patchwork.kernel.org/patch/9355377/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
