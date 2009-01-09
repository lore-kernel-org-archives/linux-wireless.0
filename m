Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:53365 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZAIRdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 12:33:44 -0500
Received: by bwz14 with SMTP id 14so29326288bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 09:33:42 -0800 (PST)
To: Christian Lamparter <chunkeey@web.de>
Cc: Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: multicast traffic and ath9k
References: <1231346161.3545.52.camel@johannes>
	<1231506446.3703.18.camel@johannes>
	<44EE5C37ADC36343B0625A05DD408C4845A77DAF08@CHEXMB-01.global.atheros.com>
	<200901091713.12777.chunkeey@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 09 Jan 2009 19:33:40 +0200
In-Reply-To: <200901091713.12777.chunkeey@web.de> (Christian Lamparter's message of "Fri\, 9 Jan 2009 17\:13\:12 +0100")
Message-ID: <874p08tmdn.fsf@litku.valot.fi> (sfid-20090109_183348_925072_E3277238)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@web.de> writes:

>> How does the mac80211 know if the hw is receiving mc traffic or not and
>> unset the CONF_PS flag accordingly? Am I missing something basic here?
>> 
>> Maybe p54 (stlc45xx) has the answer for how it goes back to sleep
>> after mc traffic.
>
> Well we have a flag to tell the firmware to do the following thing
> in client mode (while sleeping)
>
> "If the PSM object's *_PSM_MCBC flag is set, and a beacon is
> received with the TIM's multicast traffic bit set, [...] or the LMAC
> stays awake until the TIM's multicast traffic bit is cleared again
> from the beacon".

I doubt that LMAC stays awake until next beacon arrives, that would
increase the power consumption too much. Most probably it follows the
more data from the multicast frames and goes to sleep immeaditely
after it has received the last multicast frame.

-- 
Kalle Valo
