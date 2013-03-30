Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757011Ab3C3SNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Mar 2013 14:13:24 -0400
Message-ID: <1364667185.8398.1.camel@jlt4.sipsolutions.net> (sfid-20130330_191348_453890_CBBC340A)
Subject: Re: [PATCH] net/wireless/sme: sched_scan_mtx lock in
 cfg80211_conn_work()
From: Johannes Berg <johannes@sipsolutions.net>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Sat, 30 Mar 2013 19:13:05 +0100
In-Reply-To: <1364664014-12304-1-git-send-email-artem.savkov@gmail.com> (sfid-20130330_182140_133456_75DB275A)
References: <1364664014-12304-1-git-send-email-artem.savkov@gmail.com>
	 (sfid-20130330_182140_133456_75DB275A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-03-30 at 21:20 +0400, Artem Savkov wrote:
> Introduced in f9f475292dbb0e7035fb6661d1524761ea0888d9
> 
> cfg80211_conn_scan() which requires sched_scan_mtx to be held can be called
> from cfg80211_conn_work(). Without this we are hitting multiple warnings like
> the following:
> 
> [   51.996440] ------------[ cut here ]------------
> [   51.996484] WARNING: at net/wireless/sme.c:88 cfg80211_conn_scan+0x1dc/0x3a0 [cfg80211]()

Applied, thanks. I guess I need to add

iw wlan0 scan trigger ; iw wlan0 connect -w NO_SUCH_SSID

to my tests ...

johannes

