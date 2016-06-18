Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:50995 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbcFRJRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2016 05:17:21 -0400
Date: Sat, 18 Jun 2016 12:11:16 +0300
From: Jouni Malinen <j@w1.fi>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Encrypt "Group addressed privacy" action frames
Message-ID: <20160618091116.GA2972@w1.fi> (sfid-20160618_111743_549776_1F9726FA)
References: <1465969112-2814-1-git-send-email-masashi.honma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465969112-2814-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 15, 2016 at 02:38:32PM +0900, Masashi Honma wrote:
> Previously, the action frames to group address was not encrypted. But
> [1] "Table 8-38 Category values" indicates "Mesh" and "Multihop" category
> action frames should be encrypted (Group addressed privacy == yes). And the
> encyption key should be MGTK ([1] 10.13 Group addressed robust management frame
> procedures). So this patch modifies the code to make it suitable for spec.

>  net/mac80211/tx.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

What about RX side? Shouldn't there be a matching change there to
enforce use of group addressed privacy for the specific Action
categories? This will make devices using fixed implementation not
interoperate with devices using older version, I'd assume, but it looks
like the current use of mesh with RSN is pretty hopelessly broken as far
as no PMF case is concerned at least when using the wpa_supplicant
implementation (sets IGTK incorrectly and ends up using BIP even when
PMF was not enabled), so there does not seem to be any convenient way of
addressing this apart from requiring all devices in the MBSS to get
updated to the fixed versions.

> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> +static bool debug_noinline
> +ieee80211_is_group_privacy_action(struct ieee80211_hdr *hdr)

And this helper should likely be in some more generic location so that
it could be shared for TX and RX..

-- 
Jouni Malinen                                            PGP id EFC895FA
