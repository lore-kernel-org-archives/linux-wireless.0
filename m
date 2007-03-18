Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:35023 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbXCRKMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2007 06:12:32 -0400
Message-ID: <45FD108C.10108@warmcat.com>
Date: Sun, 18 Mar 2007 10:12:28 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
References: <20070317105800.659633351@warmcat.com> <200703171751.50898.flamingice@sourmilk.net> <45FC6727.3090008@warmcat.com> <200703171920.37469.flamingice@sourmilk.net> <45FC7924.8050501@warmcat.com> <45FCFFA5.5070801@warmcat.com>
In-Reply-To: <45FCFFA5.5070801@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:

> However when I went on to look at leveraging that to find out if the 
> originating interface was in Monitor mode, it seems that it might be a 
> little bit more expensive to do that -- and it would have to be done for 
> every tx packet in order to find out if it was injected.  By contrast 
> with the currently proposed staged system at each level the information 
> is always available without processing, and the overhead for the common 
> case where the packet was not injected is just testing if the if type 
> was monitor, and then later testing a bit in flags that are already 
> available.
> 
>  From looking around the existing code, it seems something like this is 
> called for to use the ifindex instead:

Ha, ignore this, Michael's method works just with what is to hand.  Try 
#3 coming up.

-Andy
