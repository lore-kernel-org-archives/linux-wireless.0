Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61366 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbbDARdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 13:33:09 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v6 0/7] ath10k: add multi-channel support
References: <1427797586-5132-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 1 Apr 2015 20:32:54 +0300
In-Reply-To: <1427797586-5132-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 31 Mar 2015 10:26:19 +0000")
Message-ID: <878uebycs9.fsf@kamboji.qca.qualcomm.com> (sfid-20150401_193316_239541_67789409)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> New qca6174 with wmi-tlv firmware supports
> multi-channel operation. To make use of it
> ath10k needs a few changes: implement mac80211's
> chanctx API and rework tx queue control a bit.
>
>
> Changes since RFC:
>  * I've sent `ath10k: defer AP self-peer removal
>    wait` separately now because it's not really
>    required for multi-channel per se
>
> v2:
>  * fix null deref after rebasing
>  * fix commit log typo
>
> v3:
>  * remove some duplication wrt mac80211 [Johannes]
>  * small fixes
>
> v4:
>  * rebased
>  * fix STA CSA
>  * drop ar->arvifs data_lock protection patch
>  * drop ar->arvifs for vif iteration in favour of
>    ieee80211_iterate_active_interfaces()
>  * small refactor in monitor recalc
>  * add a patch to fix fw resource allocation for
>    multi-vif/chan
>
> v5:
>  * rebased on top of pending branch
>  * 12 char commit ids
>  * increase vif limit to 3 in ifcombs
>
> v6:
>  * fix rcu locking
>  * rebased on master branch
>    (mind the cfg80211_get_bss conflict when
>     applying to pending branch)
>
> Michal Kazior (7):
>   ath10k: allow empty ssid vdev config
>   ath10k: implement chanctx API
>   ath10k: implement adaptive qcs command
>   ath10k: rework tx queue locking
>   ath10k: implement tx pause wmi event
>   ath10k: enable multi-channel on supported devices
>   ath10k: allocate fw resources for iface combinations

Thanks, all seven patches applied.

-- 
Kalle Valo
