Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2199 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966059AbXFHCnW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 22:43:22 -0400
Subject: Re: IEEE802.11e/WMM TS management and DLS support
From: Zhu Yi <yi.zhu@intel.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: jketreno <jketreno@linux.intel.com>, Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200706071540.41665.flamingice@sourmilk.net>
References: <20070606082152.GA28639@mail.intel.com>
	 <200706071412.54918.flamingice@sourmilk.net>
	 <4668DE0F.7060302@linux.intel.com>
	 <200706071540.41665.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 10:42:39 +0800
Message-Id: <1181270559.3039.119.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-06-07 at 15:40 -0700, Michael Wu wrote:
> Sure. But frankly, this code sucks. The original patch that I reviewed had 
> problems that indicated a total lack of testing.. and that was just for a 
> subset of the patch series that I actually reviewed in detail. Even the 
> design of the entire patch series is questionable even if we weren't trying 
> to move to a userspace MLME (and we need to, because kernel space MLME is a 
> *dead end*).

user space MLME is good, I'd also agree to move to it if it is ready.
But the key point for the patch series is not dealing with MLME. They
are about the TS managment and DLS. Please concentrate on the key point.
Did you ever read IEEE 802.11e or WMM specs?

>  The patch series also introduced sparse errors.

$ cd wireless-dev.git
$ touch net/mac80211/*.[ch]
$ make modules C=1

Sparse does generate a lot of errors. But there is only one from my
patches (because I define int dls_sta:1 which is followed the int
assoc_ap:1 defined already there).

> Do I need to go on? Make the code suck less and we won't have to go through 
> this again. It's that simple. It's not about being aggressive or offensive. 
> It's about having some standards.
> 
> Now of course, this also happened because Linville didn't see much and assumed 
> it was okay. If a patch needs review (and a patch series of this size *needs* 
> review), go ahead and ask for a review (or remind me I need to do one!). I 
> don't have much time this summer for writing code, but I will make sure I 
> have time to review code, especially if Jiri Benc is not around.

I have addressed all your comments in this series, right? And you are in
the cc list. You have more, just speak out!

-yi
