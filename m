Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23233 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbAMOPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 09:15:48 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] ath10k: add per station debugfs support
References: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 13 Jan 2015 16:15:34 +0200
In-Reply-To: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 24 Dec 2014 13:29:01 +0530")
Message-ID: <87twzu6a2h.fsf@kamboji.qca.qualcomm.com> (sfid-20150113_151551_782093_9A49C856)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> The following patches add support for sending addba/addba response/delba
> for every station entries. These commands are purely for testing purpose.
>
> Before using any of the above aggregation commands, the mode should be moved
> to manual. To disable automatic aggretation in target
>
> echo 1 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
>         stations/XX:XX:XX:XX:XX:XX/aggr_mode
>
> Then for sending addba request,
>
> echo 1 32 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
>         stations/XX:XX:XX:XX:XX:XX/addba
>
> To send addba response,
>
> echo 0 25 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
>         stations/XX:XX:XX:XX:XX:XX/addba_resp
>
> And for delba,
>
> echo 0 1 37 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
>         stations/XX:XX:XX:XX:XX:XX/delba
>
> v2: Rebased on top of 10.2.4 WMI ops support
>
> Rajkumar Manoharan (8):
>   ath10k: add wmi support for addba_clear_resp
>   ath10k: add wmi support for addba_send
>   ath10k: add wmi support for addba_set_resp
>   ath10k: add wmi support for delba_send
>   ath10k: Implement sta_add_debugfs
>   ath10k: add support to send addba request
>   ath10k: add support to send addba response
>   ath10k: add support to send delba

Thanks, all eight patches applied to ath.git.

-- 
Kalle Valo
