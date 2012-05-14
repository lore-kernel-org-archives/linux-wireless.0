Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2ENOcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 10:32:55 -0400
Message-ID: <1337005971.4303.18.camel@jlt3.sipsolutions.net> (sfid-20120514_163259_145116_564FAC52)
Subject: Re: [PATCH] mac80211: Remove race condition in sending null frame
 to check AP status
From: Johannes Berg <johannes@sipsolutions.net>
To: Soumik DAS <soumik.das@stericsson.com>
Cc: "John Linville (linville@tuxdriver.com)" <linville@tuxdriver.com>,
	"linux-wireless (linux-wireless@vger.kernel.org)"
	<linux-wireless@vger.kernel.org>,
	"Kalle Valo (kvalo@adurom.com)" <kvalo@adurom.com>
Date: Mon, 14 May 2012 16:32:51 +0200
In-Reply-To: <2E48302EED53D048A7BA72B0A307FB511FB906B796@EXDCVYMBSTM005.EQ1STM.local> (sfid-20120514_102614_353743_E968150D)
References: <2E48302EED53D048A7BA72B0A307FB511FB906B796@EXDCVYMBSTM005.EQ1STM.local>
	 (sfid-20120514_102614_353743_E968150D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-14 at 10:25 +0200, Soumik DAS wrote:
> mac80211 tries to verify the existence of the current AP by probing or sending a NULL frame in function ieee80211_mgd_probe_ap_send. It 1st sends a null frame to the AP, increments probe_send_count and
> waits for the ACK to the NULL frame for a finite duration of time. At times, it happens that by the time
> mac80211 gets to increment probe_send_count, the ACK for the NULL frame transmitted has already
> been processed. This leads to a race condition where mac80211 times out waiting for the ACK for the NULL
> frame causing unnecessary disconnection with the AP.

Please break your commit log lines to ~65 characters

johannes


