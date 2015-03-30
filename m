Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:49936 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbbC3MGw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 08:06:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v4 0/6] ath10k: add basic tdls support
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
Date: Mon, 30 Mar 2015 15:06:43 +0300
In-Reply-To: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Fri, 20 Mar 2015 12:02:53 +0100")
Message-ID: <874mp2665o.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_140655_754984_2AB41E30)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> This patchset introduces tdls funtionality without tdls peer uapsd
> and tdls channel switching. Tdls is supported by qca6174 hardware 
> what is indicated by firmware through supported services.
> Tdls station when authorized requires some parameters that are filled in 
> by rate control initialization. Rate control for tdls is initialized
> at proper time in mac80211 patch:
> mac80211: initialize rate control earlier for tdls station
>
> So tdls funtionality implemented by this patchset depends on 
> mac80211: initialize rate control earlier for tdls station
>
> v2:
> -introduce tdls peer counter
> -minor changes after review
>
> v3:
> -more minor changes after review
> -replace tdls peer counter variable by iterate station function
>
> v4:
> -provide functions for counting tdls station per vif and tdls vifs
> -handle maximum number of tdls vifs
> -split code into more patches
>
> Marek Puzyniak (5):
>   ath10k: make peer type configurable
>   ath10k: store max tdls vdevs that fw can handle
>   ath10k: update station counting
>   ath10k: add wmi support for tdls
>   ath10k: introduce basic tdls functionality
>
> Michal Kazior (1):
>   ath10k: unify tx mode and dispatch

Thanks, all applied.

For the record, I had to pull mac80211-next to ath-next to solve the
dependency:

commit 23d6660d7f0feacb4c0e24c5cb8f29674aa38567
Merge: 53513c302f35 5d8325ecb9c2
Author: Kalle Valo <kvalo@qca.qualcomm.com>
Date:   Mon Mar 30 10:07:12 2015 +0300

    Merge mac80211-next into ath-next
    
    Patch "ath10k: introduce basic tdls functionality" depends on this mac80211
    patch:
    
    c23e31cf7b55 mac80211: initialize rate control earlier for tdls station


-- 
Kalle Valo
