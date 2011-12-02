Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47620 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1LBLsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 06:48:51 -0500
Date: Fri, 2 Dec 2011 13:48:43 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Inform bss information to cfg80211 before
 connect event
Message-ID: <20111202114843.GC4358@jouni.qca.qualcomm.com> (sfid-20111202_124858_687812_6B6E0BAC)
References: <1322818619-29265-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1322818619-29265-1-git-send-email-vthiagar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 02, 2011 at 03:06:59PM +0530, Vasanthakumar Thiagarajan wrote:
> This is already done but only when bss entry is not availabe
> or aged out. Not updating the bss information when that bss
> is available creates a case where there is a bss entry when
> checked in ath6kl_cfg80211_connect_event() but it got aged out
> by the time cfg80211 checks for the bss entry in __cfg80211_roamed().
> This results in the following warning and the failure to notify
> roaming event to application. To fix this, update the bss information
> for which a romaing event is received. Also renamed ath6kl_add_bss_if_needed()
> to ath6kl_inform_bss().

I don't think this is a good fix for the problem and would prefer this
not getting applied before the real issue is fully understood.

This can clear valid IE information in the BSS table and make it more
difficult to complete 4-way handshake correctly. The previous condition
for the cfg80211_bss_inform() call in ath6kl_add_bss_if_needed() is
actually identical to the one that is used in __cfg80211_roamed(). In
other words, the issue is most likely from the BSS entry getting timed
out and removed between the operations and the proper fix for this is to
make sure the entry does not get removed and that should be doable
without filling it with bogus information.

-- 
Jouni Malinen                                            PGP id EFC895FA
