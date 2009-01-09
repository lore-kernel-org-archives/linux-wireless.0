Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:41475 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZAIQNP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 11:13:15 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Vivek Natarajan <Vivek.Natarajan@atheros.com>
Subject: Re: multicast traffic and ath9k
Date: Fri, 9 Jan 2009 17:13:12 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1231346161.3545.52.camel@johannes> <1231506446.3703.18.camel@johannes> <44EE5C37ADC36343B0625A05DD408C4845A77DAF08@CHEXMB-01.global.atheros.com>
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4845A77DAF08@CHEXMB-01.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901091713.12777.chunkeey@web.de> (sfid-20090109_171319_517212_CEB001B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 January 2009 14:59:25 Vivek Natarajan wrote:
> 
> Johannes Berg wrote:
> 
> > > Is the mc bit
> > > checking done only on enabling power save? if set and mc packets are received,
> > > how does it automatically go back to sleep and wouldn't there be any conflict
> > > between mac80211 and the hw regarding power state since mac80211 is not aware
> > > of the mc bit induced state change?
> 
> > I don't think there would be a conflict. mac80211's CONF_PS is always
> > only "go to sleep if you can", so receiving multicast traffic would
> > obviously imply not being able to go to sleep. When mac80211 then unsets
> > the CONF_PS flag you'd just not go back to sleep after being awake for
> > MC traffic.
> 
> How does the mac80211 know if the hw is receiving mc traffic or not and
> unset the CONF_PS flag accordingly? Am I missing something basic here?
> 
> Maybe p54 (stlc45xx) has the answer for how it goes back to sleep after mc traffic.

Well we have a flag to tell the firmware to do the following thing in client mode (while sleeping)

"If the PSM object's *_PSM_MCBC flag is set, and a beacon is received with the TIM's multicast traffic bit
set, [...] or the LMAC stays awake until the TIM's multicast traffic bit is cleared again from the beacon".

see:
STSW45X0C LMAC API: page 24 - LM_PSM_MCBC (~ P54_PSM_MCBC)

Regards,
	Chr
