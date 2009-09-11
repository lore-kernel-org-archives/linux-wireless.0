Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:44286 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbZIKHgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 03:36:21 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: allow scanning on specified frequencies when using wext-compatibility
Date: Fri, 11 Sep 2009 09:35:47 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200909091309.55068.hs4233@mail.mn-solutions.de> <1252629664.23427.4.camel@johannes.local>
In-Reply-To: <1252629664.23427.4.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909110935.47253.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This is a bit weird -- this way you don't report errors if the
> user specified frequencies that don't exist.

Couldn't / shouldn't this done in user-space, e.g. after checking
IWRANGE.


> Also, are you sure that it has to be a frequency as opposed to
> a channel number?

I'm not totally sure, because there's nowhere any documentation
about the exact meanings of fields in "struct iw_freq". My patch
for wpa_supplicant's driver_wext.c only put's a frequency there:

+        req.channel_list[i].m = params->freqs[i] * 100000;
+        req.channel_list[i].e = 1;
+        req.channel_list[i].i = i;
+        req.channel_list[i].flags = 0;

But now that you bring this into my mind, I should have looked
at another consumer of "struct iw_freq", e.g. I should use
cfg80211_wext_freq() like cfg80211_wext_siwfreq() ?!?

I'll prepare some patch.

-- 
http://www.holgerschurig.de
