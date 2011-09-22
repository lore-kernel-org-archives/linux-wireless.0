Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30569 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1IVIFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 04:05:17 -0400
Message-ID: <4E7AEC37.40405@qca.qualcomm.com> (sfid-20110922_100530_007335_95F6C026)
Date: Thu, 22 Sep 2011 11:05:11 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath6kl: Report PMKSA candidate events through cfg80211
References: <20110921135729.GA26105@jouni.qca.qualcomm.com>
In-Reply-To: <20110921135729.GA26105@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2011 04:57 PM, Jouni Malinen wrote:
> This allows RSN pre-authentication to be used when roaming decisions are
> done in the target.
> 
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/wmi.c |   30 ++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath6kl/wmi.h |   10 ++++++++++
>  2 files changed, 40 insertions(+), 0 deletions(-)
> 
> Please note that this depends on a recent change in wireless-testing.git
> for cfg80211_pmksa_candidate_notify(). This commit
> c9df56b48e4ff003eaebd680ec7a45342dcd03ea is not yet in ath6kl.git.

Thanks for the warning, this is always good to know.

John, I merged latest wireless-next to ath6kl-next branch in ath6kl.git
to get the latest cfg80211 changes, I hope that's ok. Let's keep this in
mind when I send the next pull request and double check that I didn't
break anything.

Kalle
