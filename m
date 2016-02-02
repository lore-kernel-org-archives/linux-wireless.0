Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42470 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbcBBLtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 06:49:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Gareth McCaughan <gareth.mccaughan@pobox.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wpa_supplicant over-eagerly blacklisting AP sending PREV_AUTH_NOT_VALID?
References: <56B08F03.1040802@g.local>
Date: Tue, 02 Feb 2016 13:48:51 +0200
In-Reply-To: <56B08F03.1040802@g.local> (Gareth McCaughan's message of "Tue, 2
	Feb 2016 11:12:03 +0000")
Message-ID: <87r3gvs57g.fsf@purkki.adurom.net> (sfid-20160202_124910_517084_859B056D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gareth McCaughan <gareth.mccaughan@pobox.com> writes:

> I have some reason to believe the following:
>
>   * Some Cisco wireless APs will regularly try to force clients
>     to reauthenticate by sending deauthorization frames
>     with reason code 2 (PREV_AUTH_NOT_VALID).
>
>   * When one of these arrives, wpa_supplicant will respond by
>     putting the AP on a blacklist and roaming to another AP
>     rather than by immediately trying to reauthenticate with
>     the same AP.
>
> This is a Bad Thing (isn't it?) because e.g. if you have two of
> these APs within range but one provides a much better signal
> than the other, you'll alternate between them rather than
> sticking with the good one. It seems like it might be better
> for wpa_supplicant to try the original AP again immediately.
>
> (The problem that actually sent me looking at this stuff is
> more severe and involves machines completely falling off
> the network after several of these transitions, but I think
> that's a separate issue that I don't understand yet.)
>
> Some details follow.

wpa_supplicant and hostapd have a dedicated list:

http://lists.infradead.org/mailman/listinfo/hostap

-- 
Kalle Valo
