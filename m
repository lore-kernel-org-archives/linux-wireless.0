Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64075 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbZAIQhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 11:37:06 -0500
Received: by bwz14 with SMTP id 14so29222974bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 08:37:04 -0800 (PST)
To: Vivek Natarajan <Vivek.Natarajan@Atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: multicast traffic and ath9k
References: <1231346161.3545.52.camel@johannes>
	<44EE5C37ADC36343B0625A05DD408C4845A77DAF07@CHEXMB-01.global.atheros.com>
	<1231506446.3703.18.camel@johannes>
	<44EE5C37ADC36343B0625A05DD408C4845A77DAF08@CHEXMB-01.global.atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 09 Jan 2009 18:37:01 +0200
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4845A77DAF08@CHEXMB-01.global.atheros.com> (Vivek Natarajan's message of "Fri\, 9 Jan 2009 19\:29\:25 +0530")
Message-ID: <87d4ewtp02.fsf@litku.valot.fi> (sfid-20090109_173712_349356_340A6D4F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <Vivek.Natarajan@Atheros.com> writes:

> Johannes Berg wrote:
>
>> > Is the mc bit checking done only on enabling power save? if set
>> > and mc packets are received, how does it automatically go back to
>> > sleep and wouldn't there be any conflict between mac80211 and the
>> > hw regarding power state since mac80211 is not aware of the mc
>> > bit induced state change?
>
>> I don't think there would be a conflict. mac80211's CONF_PS is always
>> only "go to sleep if you can", so receiving multicast traffic would
>> obviously imply not being able to go to sleep. 

Yes, there is no conflict. If stlc45xx firmware notices that multicast
tim bit is set, it will just stay awake long enough to receive all the
multicast frames, delivers them to the host and goes immediately back
to sleep.

>> When mac80211 then unsets the CONF_PS flag you'd just not go back
>> to sleep after being awake for MC traffic.
>
> How does the mac80211 know if the hw is receiving mc traffic or not and
> unset the CONF_PS flag accordingly? Am I missing something basic here?

Why would mac80211 need to unset CONF_PS? It can just receive the
multicast frames from the driver, it doesn't need to change the power
save state.

> Maybe p54 (stlc45xx) has the answer for how it goes back to sleep
> after mc traffic.

stlc45xx firmware handles multicast frames automatically.

-- 
Kalle Valo
