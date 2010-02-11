Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:17639 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0BKM1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 07:27:43 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: cfg80211 support
Date: Thu, 11 Feb 2010 13:24:57 +0100
Cc: Samuel Ortiz <sameo@linux.intel.com>
References: <20100202000934.GA19847@sortiz.org> <201002041052.00858.holgerschurig@gmail.com> <20100211120133.GA3136@sortiz.org>
In-Reply-To: <20100211120133.GA3136@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002111324.57501.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What I changed is triggerring the scan work whenever the last
> one is done, i.e. triggering it from lbs_ret_scan().

Ah, that makes sense.

> My initial thought was that you could have 2 lbs_cfg_scan()
> running at the same time since you could potentially have a 2nd
> lbs_cfg_scan() call before scan_request is actually set.

Hmm, even when cfg80211 would allow this, I wouldn't allow this 
in the driver. All the hoops with the delayed-scan-work is 
because the firmware can't send a I'm-on-powersafe-notification 
to the current AP while being on other channels. So I have to 
make sure to return from time to time to my AP, so that I won't 
loose packets for me and won't be disconnected.

If now two scan_req and therefore two scan workers run, the time 
we're away from our "home channel" increases, which also 
increase the deauthentication problem.


Oh, and btw: we can later add an optimization that if we aren't 
connected at all, we do all scans in one-go, without delays. We 
still need to send several scan-commands to the firmware, to 
reduce the possible that a huuuuuge scan response overflows some 
firmware buffer limit.


Thanks for your answers.

Best regards,
Holger

-- 
http://www.holgerschurig.de
