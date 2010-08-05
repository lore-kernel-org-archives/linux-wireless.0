Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59659 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759092Ab0HEN7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 09:59:41 -0400
Date: Thu, 5 Aug 2010 09:45:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?J=F3natan_Mu=F1oz?= <jmunoz@umh.es>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k]: Beaconing process in ad-hoc mode
Message-ID: <20100805134531.GA2779@tuxdriver.com>
References: <002c01cb3495$0ff49610$2fddc230$@es>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <002c01cb3495$0ff49610$2fddc230$@es>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 05, 2010 at 01:55:05PM +0200, Jónatan Muñoz wrote:
> Dear All,
> 
> I am working in a project where I need to modified the currently beaconing
> system for adhoc mode in ath9k, what I want to achieve is that each station
> in an adhoc network send periodically a beacon. As I know, when a station in
> the network receives a beacon before sending its own beacon, cancels the
> transmission, updates its hw tsf based on the received beacon and waits for
> a chance to send the beacon during next TBTT.
> 
> For my goal, I think that I should comment the part where the transmission
> of the beacon is cancelled. In this way, each station will send a beacon
> each 100TU (~100 ms). I know that this mean a increased traffic load on the
> network, but it is so much important for the project to obtain a beacon for
> each station each 100ms.
> 
> Right now, I am looking at the source code of ath9k, I am trying to modify
> the file beacon.c, but I don’t find the way to get my purpose. Could anyone
> help me to find the right place at the code that I have to modify? I am a
> bit lost and any help would be greatly appreciated.
> 
> Thanks in advance.
> 
> PD: Please excuse my poor English
> 
> John

I think you should be looking in net/mac80211/ibss.c.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
