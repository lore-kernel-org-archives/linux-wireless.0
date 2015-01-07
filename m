Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:43841 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbbAGSFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 13:05:08 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file entries
References: <1419685980-4728-1-git-send-email-arend@broadcom.com>
Date: Wed, 07 Jan 2015 20:05:00 +0200
In-Reply-To: <1419685980-4728-1-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Sat, 27 Dec 2014 14:13:00 +0100")
Message-ID: <87bnmapiur.fsf@kamboji.qca.qualcomm.com> (sfid-20150107_190512_156386_0B81F0DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> Use the helper to get rid of the file operations per debugfs file. The
> device driver data contains struct ieee80211_hw pointer and the
> struct ath9k_softc pointer is assigned to ieee80211_hw::priv so it can
> be accessed in the seq_file read operation.
>
> Cc: ath9k-devel@lists.ath9k.org
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi Kalle,
>
> This patch was reverted in the driver-core repository as I overlooked
> the use of driver data and caused ath9k driver to crash. I believe this
> revised patch properly uses it now although I have no ath9k hardware to
> test this. So I hope some ath9k developers out there can give this patch
> a run for its money. It compiles and no checkpatch or sparse warnings.
>
> The patch applies to the master branch of the wireless-drivers-next
> repository.

Can someone with ath9k hardware test this, please? I'm hesitant to apply
this without testing.

-- 
Kalle Valo
