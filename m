Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3JQHqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:46:08 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VWiHU-0002Vn-Kf
	for linux-wireless@vger.kernel.org; Thu, 17 Oct 2013 09:46:04 +0200
Message-ID: <1381995961.14391.0.camel@jlt4.sipsolutions.net> (sfid-20131017_100807_534319_63073F7E)
Subject: Re: [PATCH 3.12 3/3] mac80211: sanity check WMM/QoS parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 17 Oct 2013 09:46:01 +0200
In-Reply-To: <1381843030-12260-3-git-send-email-johannes@sipsolutions.net> (sfid-20131015_151903_954538_B0C1D1CC)
References: <1381843030-12260-1-git-send-email-johannes@sipsolutions.net>
	 <1381843030-12260-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131015_151903_954538_B0C1D1CC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-15 at 15:17 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Check for invalid WMM parameters (AIFSN < 2 or CWmax < CWmin)
> and try to set them to usable values in this case.
> 
> Notably the Sitecom WL-153 v1 with firmware 1.45 is sending
> AIFSN, ECWmin and ECWmax as all zero.

We reviewed this and decided that it would be more robust to connect as
a non-WMM station, since we can't know what other parameters are wrong.
I've just posted a replacement patch to that effect.

johannes

