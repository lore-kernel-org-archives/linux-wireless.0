Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34456 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039AbYLORGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 12:06:36 -0500
Date: Mon, 15 Dec 2008 19:06:13 +0200
From: Jouni Malinen <j@w1.fi>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: Updated padding stuff for the RX and TX side.
	TX side has been 100%
Message-ID: <20081215170613.GA22627@jm.kir.nu> (sfid-20081215_180640_452909_B5498C81)
References: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 03:34:58PM +0100, Benoit Papillault wrote:
> This patch is close to the original code except that
> ieee80211_get_hdrlen_from_skb() has been replaced by
> ath5k_hw_get_hdrlen_from_skb() which is specific to Atheros hardware. The same
> probably applies to ath9k as well.

Most of this is changes on how unspecified frames are handled (e.g.,
frames that are not used in IEEE 802.11). What is the use case that
justifies this type of extra complexity to be added into the driver?
Please note that there are no guarantees that all hardware revisions
behave the same as far as undocumented functionality is concerned. The
only clear case when padding is required is data frames with non-empty
frame body.

-- 
Jouni Malinen                                            PGP id EFC895FA
