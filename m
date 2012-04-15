Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36120 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab2DOKYz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 06:24:55 -0400
Message-ID: <4F8AA1F5.5030402@openwrt.org> (sfid-20120415_122523_511385_8B7006FF)
Date: Sun, 15 Apr 2012 12:24:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [RFC 1/2] ath9k: add an extra boolean parameter to ath9k_hw_apply_txpower
References: <1334417539-6498-1-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1334417539-6498-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-14 5:32 PM, Gabor Juhos wrote:
> In order to unifying regulatory limit handling
> commit ca2c68cc7bc80fc4504fb420df04cce99c9ee6ec
> (ath9k_hw: clean up tx power handling) introduced
> a new helper function 'ath9k_hw_apply_txpower',
> and the direct calls of 'ah->eep_ops->set_txpower'
> has been replaced by a call of the helper function.
> 
> This caused a change in the behaviour of the
> 'ath9k_hw_set_txpowerlimit' function. The purpose
> of that function is to calculate and store the
> rate txpower table and the regulatory limit without
> touching the hardware registers. Before the commit,
> the 'test' parameter of the function was passed to
> the 'ah->eep_ops->set_txpower'. Now the calling of
> the 'set_txpower' function happens indirectly through
> 'ath9k_hw_apply_txpower', so the 'test' argument of
> the 'set_txpower' is always 'false'.
> 
> This patch restores the original behaviour of
> 'ath9k_hw_set_txpowerlimit' by adding a new
> argument to 'ath9k_hw_apply_txpower.'
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Cc: Felix Fietkau <nbd@openwrt.org>
Acked-by: Felix Fietkau <nbd@openwrt.org>
