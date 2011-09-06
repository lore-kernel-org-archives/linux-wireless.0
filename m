Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1IFIoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 04:44:24 -0400
Subject: Re: How to request firmware during module init?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4E65DC7D.70306@qca.qualcomm.com> (sfid-20110906_104037_973452_28D96118)
References: <4E65DC7D.70306@qca.qualcomm.com>
	 (sfid-20110906_104037_973452_28D96118)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 10:44:20 +0200
Message-ID: <1315298660.3900.0.camel@jlt3.sipsolutions.net> (sfid-20110906_104427_458162_4FD06EEC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-06 at 11:40 +0300, Kalle Valo wrote:
> Hi,
> 
> ath6kl needs to request the firmware from user space during module init
> (or to be exact from sdio probe, but it's almost the same thing) and
> boot hardware to get some settings etc before it registers itself to
> cfg80211. What's the proper way to handle this?
> 
> I noticed that when I compile ath6kl into kernel boot fails on my x86
> box as firmware is not available because user space is not ready.

We do an async request, once it comes back we register with mac80211.

johannes

