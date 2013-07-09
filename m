Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3GITPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 15:15:55 -0400
Message-ID: <1373397346.8241.9.camel@jlt4.sipsolutions.net> (sfid-20130709_211557_992470_E000D720)
Subject: Re: [PATCH] mac80211: fix 5/10 MHz tx_status regression
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 09 Jul 2013 21:15:46 +0200
In-Reply-To: <1373397200-23686-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373397200-23686-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-07-09 at 21:13 +0200, Simon Wunderlich wrote:
> sdata may be used uninitialized in ieee80211_tx_status() when adding the
> radiotap header. It was added as parameter in "mac80211: select and
> adjust bitrates according to channel mode" to find the current control
> channel width (5/10/20+ MHz) and is used to report the bitrate
> correctly. Fix this by identifing the required shift when cycling
> through the interfaces.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> Cc: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
> ---
> You might want to squash this into the offending patch before sending it
> further upstream.

I was about to drop most of your patches again, but OK :)

johannes

