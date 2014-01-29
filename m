Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaA2NNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 08:13:50 -0500
Message-ID: <1391001212.4143.16.camel@jlt4.sipsolutions.net> (sfid-20140129_141353_503487_1263101F)
Subject: Re: [PATCH v3 2/2] cfg80211: regulatory introduce maximum bandwidth
 calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Wed, 29 Jan 2014 14:13:32 +0100
In-Reply-To: <1390645452-2495-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140125_112424_327803_ADA5FC37)
References: <1390645452-2495-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1390645452-2495-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140125_112424_327803_ADA5FC37)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-01-25 at 11:24 +0100, Janusz Dziedzic wrote:
> In case we will get regulatory request with rule
> where max_bandwidth_khz is set to 0, handle this case
> as a special one.
> Generally
> max_bandwidth_khz == 0 mean we should calculate maximum
> available bandwidth base on all frequency contiguous rules.

That's a pretty good solution too, without a flag, but I think you
should have a little bit of documentation changes in nl80211.h (and
probably change nl80211 to not actually require a zero attribute for
auto?)

johannes

