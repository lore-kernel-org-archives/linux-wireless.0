Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:32970 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726Ab2EJIoV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 04:44:21 -0400
From: Soumik DAS <soumik.das@stericsson.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 10 May 2012 10:43:57 +0200
Subject: RE: [PATCH] mac80211: Increment probe_send_count earlier
Message-ID: <2E48302EED53D048A7BA72B0A307FB511FB9009215@EXDCVYMBSTM005.EQ1STM.local> (sfid-20120510_104431_809522_91D28FB6)
References: <2E48302EED53D048A7BA72B0A307FB511FB9009098@EXDCVYMBSTM005.EQ1STM.local>
 <87vck48q92.fsf@purkki.adurom.net>
In-Reply-To: <87vck48q92.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Mac80211 tries to verify the existence of the current AP by probing or sending a NULL frame (function: ieee80211_mgd_probe_ap_send). It 1st sends a null frame to the AP increments probe_send_count and waits for the ACK to the NULL frame for a finite duration of time.

Normally, the sequence of events will be -
	a. call ieee80211_send_nullfunc()
	b. increment probe_send_count ( this indicates probing is underway)
	c. null frame gets transmitted and acked, so mac80211 resets probe_send_count and concludes that the current is still alive.

In some cases the sequence of events gets changed -
	a. call ieee80211_send_nullfunc()
		(current thread gets scheduled out/pre-empted at this point)
	b. null frame gets transmitted and acked
	c. probe_send_count is incremented
	d. mac80211 waits for some specified timeout and checks that probe_send_count is still > 0. It concludes that AP did not acknowledge the null frame and disassociates from the current AP.
	e. After a scan STA again re-associate with the same AP.

Btw, this verification of current AP by sending null frame occurs after every scan.

Regards,
Soumik

-----Original Message-----
From: Kalle Valo [mailto:kvalo@adurom.com] 
Sent: Thursday, May 10, 2012 12:41 PM
To: Soumik DAS
Cc: John Linville; linux-wireless; Johannes Berg
Subject: Re: [PATCH] mac80211: Increment probe_send_count earlier

Hi Soumik,

Soumik DAS <soumik.das@stericsson.com> writes:

> At times, null frame gets transmitted and acked before mac80211 gets 
> to increment probe_send_count. This leads to a situation where 
> mac80211 waits for ack to null frame, but no ack comes causing 
> unnecessary disconnection.

Can explain a bit more about the scenario when this happens, please?
It's not clear for me from the patch.

--
Kalle Valo
