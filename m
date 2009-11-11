Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:65099 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZKKAy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 19:54:59 -0500
Date: Wed, 11 Nov 2009 13:55:27 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
To: Adam Wozniak <awozniak@irobot.com>
cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: compat-wireless and minstrel
In-Reply-To: <4AF9F03E.2010405@irobot.com>
Message-ID: <alpine.DEB.2.00.0911111217580.6214@kauri.acheron.indranet.co.nz>
References: <4AF0D54D.4090303@irobot.com> <200911041653.33737.chunkeey@googlemail.com> <alpine.DEB.2.00.0911050951000.16407@kauri.acheron.indranet.co.nz> <4AF9F03E.2010405@irobot.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
> Do you know which frames in the mac80211 code are missing this required 
> information?  Or was that conjecture?

it was mostly conjecture. I had done some work with an earlier pull of 
compat wireless in adhoc. the rates tried by minstrel were bad - it was 
stuck at the slowest rate.

I too had found that the fix was to adjust the array so that all rates 
were marked as supported.

Derek

On Tue, 10 Nov 2009, Adam Wozniak wrote:

> Reading through the 802.11 spec, it appears to me that "Supported rates" (and 
> "Extended Supported Rates" when number of rates > 8) is REQUIRED for all 
> management frames except authentication, deauthentication, and action frames. 
> (IEEE 802.11-2007, 7.2.3)
>
> Do you know which frames in the mac80211 code are missing this required 
> information?  Or was that conjecture?
>
> Looking at mac80211/tx.c ieee80211_beacon_get_tim, it is not clear to me how 
> (or if) this rate information is being set for ad-hoc beacons.
>
> Derek Smithies wrote:
>> Some management frames don't contain a full report of the rates supported 
>> by the sender.
>> My view is that node A (in this example) is incorrectly determining that B 
>> only supports the 1mb/sec rate. Consequently, node A fills the 
>> rate_supported  array with one rate - 1mb/sec.
>
>
>

-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/

"The only thing IE should be used for is to download Fire Fox"

"My favorite language is call STAR. It's extremely concise. It has
  exactly one verb '*', which does exactly what I want at the moment."
     --Larry Wall
