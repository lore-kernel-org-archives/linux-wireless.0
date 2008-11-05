Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n4a.bullet.ukl.yahoo.com ([217.146.183.152]:20451 "HELO
	n4a.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752309AbYKERKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 12:10:50 -0500
Message-ID: <4911D3CC.1050900@yahoo.co.uk> (sfid-20081105_181055_010319_87D1D91A)
Date: Wed, 05 Nov 2008 17:11:40 +0000
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets
 using tx close descriptor for 8187B
References: <970642.22610.qm@web23103.mail.ird.yahoo.com> <200811051342.05303.herton@mandriva.com.br>
In-Reply-To: <200811051342.05303.herton@mandriva.com.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:

>> and applying the two patches on top, they applies cleanly and compile okay
>> except for some warnings in a different module about missing symbols
>> (<something>_sta) but the result dies very painfully with a kernel oops:
> 
> Looks like something bad in combination of compat-wireless plus kernel 
> 2.6.27.4-73.fc10.x86_64, please try a plain wireless-testing tree with the 
> two patches.

Hmm, I'll have to check, but I was a bit puzzled that compat-wireless didn't 
build the mac80211 module and the fc10 kernel didn't have one either. (and early 
kernels have a mac80211.ko). Has this been made obsolete, or did the fc10 kernel 
shipped it compiled-in and for some good/bad reason compat-wireless doesn't
build modules that are compiled in? (obviously there is no point in building a 
module the older version of which is compiled in since it won't be used...)

The status.retry_count vs status.rate[0].count change must be in mac80211.ko
or some other more generic module?

Hin-Tak
P.S. I know building a whole wireless-testing kernel is the way to go, but
it takes *very long*...


