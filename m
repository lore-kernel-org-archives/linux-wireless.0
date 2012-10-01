Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2JAHYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 03:24:16 -0400
Message-ID: <1349076289.10330.5.camel@jlt4.sipsolutions.net> (sfid-20121001_092455_084954_E54E378A)
Subject: Re: [PATCH] mac80211: Fix FC masking in BIP AAD generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 01 Oct 2012 09:24:49 +0200
In-Reply-To: <20120930164740.GA16910@w1.fi>
References: <20120930164740.GA16910@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-30 at 19:47 +0300, Jouni Malinen wrote:
> The bits used in the mask were off-by-one and ended up masking PwrMgt,
> MoreData, Protected fields instead of Retry, PwrMgt, MoreData. Fix this
> and to mask the correct fields. While doing so, convert the code to mask
> the full FC using IEEE80211_FCTL_* defines similarly to how CCMP AAD is
> built.
> 
> Since BIP is used only with broadcast/multicast management frames, the
> Retry field is always 0 in these frames. The Protected field is also
> zero to maintain backwards compatibility. As such, the incorrect mask
> here does not really cause any problems for valid frames. In theory, an
> invalid BIP frame with Retry or Protected field set to 1 could be
> rejected because of BIP validation. However, no such frame should show
> up with standard compliant implementations, so this does not cause
> problems in normal BIP use.
> 
> Signed-off-by: Jouni Malinen <j@w1.fi>
> ---
>  net/mac80211/wpa.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> This incorrect mask value was reported to me through private email and I
> have not received permission to add a Reported-by: tag, so I can only
> credit the anonymous reporter here. Thanks!

:-)

Applied, thanks!

johannes

