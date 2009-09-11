Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:16749 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZIKHwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 03:52:43 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: allow scanning on specified frequencies when using wext-compatibility
Date: Fri, 11 Sep 2009 09:52:14 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200909091309.55068.hs4233@mail.mn-solutions.de> <1252629664.23427.4.camel@johannes.local>
In-Reply-To: <1252629664.23427.4.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909110952.14644.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This is a bit weird -- this way you don't report errors if the
> user specified frequencies that don't exist.

The old code did this:

Loop over all bands
   Loop over all channels
      Stick channel to scan request

I simply added this:

Loop over all bands
   Loop over all channels
      If scan-request hasn't this channel freq: continue
      Stick channel to scan request


Now, if I want to report an -EINVAL for every possibly invalid 
scan-request channel, I'd have to do this:


If scan-request has freqs:
   Loop over all scan-request freqs
      Loop over all bands
         Loop over all channels
            search for freq
   if found:
       Stick channel to scan request
   else:
       err = -EINVAL
else:
   Loop over all bands
      Loop over all channels
         Stick channel to scan request

This is considerable code-bloat for such a seldom-used function.


I'd rather do it like this:


Loop over all bands
   Loop over all channels
      If scan-request hasn't this channel freq: continue
      Stick channel to scan request
if no channels:
   err = -EINVAL

That's a compromise :-)

-- 
http://www.holgerschurig.de
