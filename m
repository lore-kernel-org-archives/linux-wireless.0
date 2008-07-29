Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:35157 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbYG2Ksd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 06:48:33 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3351657waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 03:48:33 -0700 (PDT)
Message-ID: <1ba2fa240807290348y58026caag341a7115c0d78083@mail.gmail.com> (sfid-20080729_124841_738471_4277914D)
Date: Tue, 29 Jul 2008 13:48:32 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217323927.10489.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217323927.10489.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 12:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This patch fixes mac80211 to not use the skb->cb over the queue step
> from virtual interfaces to the master. The patch also, for now,
> disables aggregation because that would still require requeuing,
> will fix that in a separate patch. There are two other places (software
> requeue and powersaving stations) where requeue can happen, but that is
> not currently used by any drivers/not possible to use respectively.

What about about ieee80211_get_rate(hw, const struct ieee80211_tx_info *c).
It's used in tx path in the drivers and info is fetched from cb

Tomas
