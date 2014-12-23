Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37759 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbaLWJKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 04:10:25 -0500
Message-ID: <1419325819.1720.1.camel@sipsolutions.net> (sfid-20141223_101033_475473_68D75F6E)
Subject: Re: [PATCH] mac80211: fix dot11MulticastTransmittedFrameCount
 tested address
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 23 Dec 2014 10:10:19 +0100
In-Reply-To: <1419168328-6114-1-git-send-email-eliad@wizery.com> (sfid-20141221_142533_445059_B1EE4471)
References: <1419168328-6114-1-git-send-email-eliad@wizery.com>
	 (sfid-20141221_142533_445059_B1EE4471)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-12-21 at 15:25 +0200, Eliad Peller wrote:
> dot11MulticastTransmittedFrameCount should be updated according
> to the DA, which might be different from hdr1.
> 
> (Checking hdr1 results in the counter being 0 in case of station,
> as TODS data frames use hdr1 for the bssid address)

I've found this in the spec - see sta_tx_dcf_3.1d(10) (page 2410 of
802.11-2012):

cTmcfrm:=
  If (fsdu!grpa or
      ((toDs(tpdu) = 1) and (isGrp(addr3(tpdu))) and (fsdu!fTot=fsdu!
fCur+1))
     )
  then inc(cTmcfrm)
  else cTmcfrm fi

fsdu!grpa is true if RA is multicast, but the rest is clearly checking
the DA (and for fragmentation, which can happen in that case.)

So I believe this patch is correct and will apply it (with some commit
message fixes - should say A1 not hdr1)

johannes

