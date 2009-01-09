Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18274 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbZAIODx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 09:03:53 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 06:03:53 -0800
From: Vivek Natarajan <Vivek.Natarajan@Atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 9 Jan 2009 19:29:25 +0530
Subject: RE: multicast traffic and ath9k
Message-ID: <44EE5C37ADC36343B0625A05DD408C4845A77DAF08@CHEXMB-01.global.atheros.com> (sfid-20090109_150359_500670_ED4A1F69)
References: <1231346161.3545.52.camel@johannes>
	 <44EE5C37ADC36343B0625A05DD408C4845A77DAF07@CHEXMB-01.global.atheros.com>,<1231506446.3703.18.camel@johannes>
In-Reply-To: <1231506446.3703.18.camel@johannes>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Johannes Berg wrote:

> > Is the mc bit
> > checking done only on enabling power save? if set and mc packets are received,
> > how does it automatically go back to sleep and wouldn't there be any conflict
> > between mac80211 and the hw regarding power state since mac80211 is not aware
> > of the mc bit induced state change?

> I don't think there would be a conflict. mac80211's CONF_PS is always
> only "go to sleep if you can", so receiving multicast traffic would
> obviously imply not being able to go to sleep. When mac80211 then unsets
> the CONF_PS flag you'd just not go back to sleep after being awake for
> MC traffic.

How does the mac80211 know if the hw is receiving mc traffic or not and
unset the CONF_PS flag accordingly? Am I missing something basic here?

Maybe p54 (stlc45xx) has the answer for how it goes back to sleep after mc traffic.

Vivek.
