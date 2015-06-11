Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:23161 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbbFKOPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 10:15:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: enable VHT for IBSS
References: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 11 Jun 2015 17:15:42 +0300
In-Reply-To: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Wed, 10 Jun 2015 07:14:44 +0200")
Message-ID: <87mw06bab5.fsf@kamboji.qca.qualcomm.com> (sfid-20150611_161627_418216_30688D0F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Enable VHT support for IBSS, while mac80211/cfg80211 and
> wpa_supplicant already support this.
>
> In my test env, ath10k 2x2 I get:
> (udp) ath10k-1 >>>> ath10k-2 (server) -  speed: 419 Mbits/sec
> (tcp) ath10k-1 >>>> ath10k-2 (server) -  speed: 404 Mbits/sec

What hw and firmware version? Do you expect this to work with both
qca988x and qca6174?

Oh, we should still add ATH10K_FW_FEATURE_NO_ADHOC so that we can
disable ad-hoc on 10.x firmwares. Anyone have some spare time to cook up
a patch?

> During tests I used wpa_supplicant (current version)

Better to say "current git version" (if that's what you mean).

-- 
Kalle Valo
