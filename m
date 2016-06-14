Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3374 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbcFNMTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 08:19:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath5k: fix misplaced default label in sifs switch
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1464871430-23803-1-git-send-email-me@bobcopeland.com>
To: Bob Copeland <me@bobcopeland.com>
CC: <linux-wireless@vger.kernel.org>, Bob Copeland <me@bobcopeland.com>
Message-ID: <06a41e02155b47f6a10bdf4b3400bd11@euamsexm01a.eu.qualcomm.com> (sfid-20160614_141908_566589_425B1B5D)
Date: Tue, 14 Jun 2016 14:18:51 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> wrote:
> In this switch statement, the default case does not always assign
> sifs.  In practice, ah->ah_bwmode cannot take values besides the
> other labels, so this is not an actual problem, but it looks odd
> and smatch complains thus:
> 
>     ath5k_hw_get_default_sifs() warn: missing break? reassigning 'sifs'
> 
> Silence the warning by moving default label up a line.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

deb85bb1dadf ath5k: fix misplaced default label in sifs switch

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9149925/

