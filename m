Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54017 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1AVQ7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 11:59:47 -0500
Received: by pzk35 with SMTP id 35so459817pzk.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jan 2011 08:59:47 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19771.3273.765665.239084@gargle.gargle.HOWL>
Date: Sat, 22 Jan 2011 22:28:49 +0530
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"ath9k-devel" <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC/WIP 00/33] ath9k_htc AP mode
In-Reply-To: <201101221348.57720.chunkeey@googlemail.com>
References: <19768.62903.947245.576431@gargle.gargle.HOWL>
	<19770.18332.859418.283909@gargle.gargle.HOWL>
	<19770.20402.711305.279934@gargle.gargle.HOWL>
	<201101221348.57720.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> You only have to have a sane tx status if the IEEE80211_TX_CTL_REQ_TX_STATUS
> flag is set. In all other cases, the IEEE80211_TX_STAT_ACK handling is
> *optional*. In fact if you don't set the TX_STAT_ACK flag, mac80211 will
> automatically do the right thing when it sees that a STA has become
> "temporarily" unavailable.

Looking at mac80211, IEEE80211_TX_CTL_REQ_TX_STATUS is set only for mgmt and
a couple of action frames now, but of course this could be fixed for other
use cases too.

> Sure, IEEE80211_HW_REPORTS_TX_ACK_STATUS would be the way to go.
> Especially because IEEE80211_HW_PS_NULLFUNC_STACK also benefits
> from it.

Yeah, agreed.
Well, let's see how things turn out. :)

Sujith
