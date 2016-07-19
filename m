Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54528 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbcGSMkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 08:40:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	hante.meuleman@broadcom.com
Subject: Re: [PATCH 3/4] brcmsmac: Fix invalid memcpy() size in brcms_c_d11hdrs_mac80211
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
	<1468884277-18606-4-git-send-email-f.fainelli@gmail.com>
	<685abc5d-2e3d-cdce-4849-f7e5beb3309d@broadcom.com>
Date: Tue, 19 Jul 2016 15:40:05 +0300
In-Reply-To: <685abc5d-2e3d-cdce-4849-f7e5beb3309d@broadcom.com> (Arend Van
	Spriel's message of "Tue, 19 Jul 2016 12:38:40 +0200")
Message-ID: <87lh0xvm1m.fsf@kamboji.qca.qualcomm.com> (sfid-20160719_144015_053892_FE3B7E75)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 19-7-2016 1:24, Florian Fainelli wrote:
>> struct ieee80211_rts::ra is only ETH_ALEN wide, yet we attempt to copy 2
>> * ETH_ALEN, which will potentially overrun the destination buffer.
>
> NACK - this is intentional. Have to admit it is a bit of trickery.
> struct ieee80211_rts is mapped over struct d11txh which is sent to
> hardware. The struct is used for both RTS and CTS. Transmitting CTS will
> only fill 802.11 addr2 in struct ieee80211_rts::ra. Transmitting RTS
> fills 802.11 addr1 in ra and 802.11 addr2 in ta using single memcpy().
> Not very clear, but your change is not the way to go here.

Maybe add a comment explaining that?

-- 
Kalle Valo
