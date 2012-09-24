Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51288 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2IXWna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 18:43:30 -0400
Received: by pbbrr4 with SMTP id rr4so7951900pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2012 15:43:29 -0700 (PDT)
Date: Mon, 24 Sep 2012 15:43:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net
Subject: Re: Out of memory on 3.5 kernels
In-Reply-To: <20120921194931.GA732@schottelius.org>
Message-ID: <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com> (sfid-20120925_004334_215965_FC819CA2)
References: <505B1FA0.6030100@broadcom.com> <20120921194931.GA732@schottelius.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 21 Sep 2012, Nico Schottelius wrote:

>  Active / Total Objects (% used)    : 1165130 / 1198087 (97.2%)
>  Active / Total Slabs (% used)      : 81027 / 81027 (100.0%)
>  Active / Total Caches (% used)     : 69 / 101 (68.3%)
>  Active / Total Size (% used)       : 1237249.81K / 1246521.94K (99.3%)
>  Minimum / Average / Maximum Object : 0.01K / 1.04K / 15.23K
> 
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> 993607 993607 100%    1.21K  75358       26   2411456K jfs_ip

Well that doesn't look good.  100% of the inode cache for jfs are being 
used which either means

 - there's a memory leak, or

 - there's some sort of throttling issue in jfs.

And those objects are consuming ~2.3GB of slab on your 4GB machine and 
seems to only have occurred between v3.4.2 to v3.5.3.

It would be interesting to see what kmemleak would tell us.

Adding Dave Kleikamp to the cc.
