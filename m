Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3KMSX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:23:28 -0500
Message-ID: <1384367004.14578.14.camel@jlt4.sipsolutions.net> (sfid-20131113_192331_426439_B5168229)
Subject: Re: [PATCH] iw: Use NL80211_FREQUENCY_ATTR_NO_IR channel attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Nov 2013 19:23:24 +0100
In-Reply-To: <1384271210-26762-1-git-send-email-ilan.peer@intel.com> (sfid-20131112_164640_986833_456571BC)
References: <1384271210-26762-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20131112_164640_986833_456571BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-12 at 17:46 +0200, Ilan Peer wrote:

> +					/* If both flags are set assume an new kernel */
> +					if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IR] && tb_freq[__NL80211_FREQUENCY_ATTR_NO_IBSS]) {
> +						print_flag("not allowed to initiate radiation", &open);

That seems excessive, any way to shorten that string?

		Frequencies:
			* 5180 MHz [36] (15.0 dBm) (not allowed to initiate radiation)
			* 5200 MHz [40] (15.0 dBm) (not allowed to initiate radiation)
			* 5220 MHz [44] (15.0 dBm) (not allowed to initiate radiation)
			* 5240 MHz [48] (15.0 dBm) (not allowed to initiate radiation)
			* 5260 MHz [52] (15.0 dBm) (not allowed to initiate radiation, radar detection)
			  DFS state: usable (for 41141 sec)


johannes

