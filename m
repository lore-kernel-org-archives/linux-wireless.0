Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:24258 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbcHKQLl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 12:11:41 -0400
Subject: Re: [PATCH 1/2] ath9k: use ieee80211_tx_status_noskb where possible
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
References: <20160804214940.78476-1-nbd@nbd.name>
Cc: kvalo@codeaurora.org
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <8aeb7913-d955-d894-d82c-4614e17d3ee4@neratec.com> (sfid-20160811_181145_115194_210F6798)
Date: Thu, 11 Aug 2016 18:05:46 +0200
MIME-Version: 1.0
In-Reply-To: <20160804214940.78476-1-nbd@nbd.name>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/04/2016 11:49 PM, Felix Fietkau wrote:
> It removes the need for undoing the padding changes to skb->data and it
> improves performance by eliminating one tx status lookup per MPDU in the
> status path. It is also useful for preparing a follow-up fix to better
> handle powersave filtering.
> 

For me, this one introduces a regression to the statistics, e.g.
'dot11TransmittedFragmentCount' is now accounted differently since it is not
updated from within ieee80211_tx_status_noskb().

Cheers,
Zefir
