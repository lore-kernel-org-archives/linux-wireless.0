Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48528 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbcCFOSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 09:18:15 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 00/11] ath10k: implement push-pull tx model
Date: Sun, 6 Mar 2016 14:18:02 +0000
Message-ID: <874mcjwv04.fsf@kamboji.qca.qualcomm.com> (sfid-20160306_151818_561606_933493F8)
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
	<1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 1 Mar 2016 11:32:45 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This adds support for the new logic where host
> tells firmware how many frames are queued for each
> station/tid and then firmware asks host to submit
> frames for given station/tid.
>
> The patch count is a bit high but I tried
> splitting the patches as much as possible to keep
> them short and easy to review. Hopefully it's not
> going to be a huge headache.
>
> v2:
>  - squashes some patches
>  - reworked pending frame scheduling
>
>
> Michal Kazior (11):
>   ath10k: refactor tx code
>   ath10k: unify txpath decision
>   ath10k: refactor tx pending management
>   ath10k: maintain peer_id for each sta and vif
>   ath10k: add fast peer_map lookup
>   ath10k: add new htt message generation/parsing logic
>   ath10k: implement wake_tx_queue
>   ath10k: implement updating shared htt txq state
>   ath10k: store txq in skb_cb
>   ath10k: keep track of queue depth per txq
>   ath10k: implement push-pull tx

I saw two conflicts, please double check my resolutions in the pending
branch:

Applying: ath10k: implement wake_tx_queue
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/htt_rx.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/htt_rx.c
Auto-merging drivers/net/wireless/ath/ath10k/core.c
Failed to merge in the changes.
Patch failed at 0007 ath10k: implement wake_tx_queue

[...]

Applying: ath10k: implement push-pull tx
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/htt_rx.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/htt_rx.c
Failed to merge in the changes.
Patch failed at 0011 ath10k: implement push-pull tx

-- 
Kalle Valo