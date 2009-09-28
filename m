Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:36353 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZI1HO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 03:14:58 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH]: nl80211: report age of scan results
Date: Mon, 28 Sep 2009 09:14:48 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200909241055.51604.hs4233@mail.mn-solutions.de> <20090926081438.GA20788@jm.kir.nu>
In-Reply-To: <20090926081438.GA20788@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909280914.48847.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 September 2009 10:14:38 Jouni Malinen wrote:
> This would depend on your use case.. I would have preferred
> absolute time since it allows the application to filter out
> entries that were not updated after the last scan request,
> i.e., to figure out which entries were found based on the last
> scan request (or well, based on frames received during this
> time). 

Oh, we can still easily change that to an absolute time, if you 
prefer. It's not yet upstream, AFAIK.



With the current patch, I'll still ignore scan results with an 
age > 3 seconds. To make a decision about "which AP should I use 
next", I don't need to know if the result was from this scan 
request, or from the one before, or from a shell script doing

   while true; do 
     iw xxx scan trigger freq 2412 essid SOME_AP
     sleep 0.5
   done

-- 
http://www.holgerschurig.de
