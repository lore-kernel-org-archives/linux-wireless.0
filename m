Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:46820 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZFSRwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 13:52:47 -0400
Received: by ewy6 with SMTP id 6so2768355ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 10:52:48 -0700 (PDT)
Message-ID: <4A3BD06D.7080702@gmail.com>
Date: Fri, 19 Jun 2009 18:52:45 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 21/23] orinoco: convert scanning to cfg80211
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com> <1245363695-8289-22-git-send-email-kilroyd@googlemail.com> <20090619173541.GC2753@tuxdriver.com>
In-Reply-To: <20090619173541.GC2753@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Thu, Jun 18, 2009 at 11:21:33PM +0100, David Kilroy wrote:
>> This removes the custom scan cache used by orinoco.
>>
>> We also have to avoid calling cfg80211_scan_done from the hard
>> interrupt, so we offload the entirety of scan processing to a workqueue.
>>
>> This may behave strangely if you start scanning just prior to
>> suspending...
>>
>> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> 
> Hmmm...please do try to compile test patches before posting! :-)
> 
> John

Compile? I'm running it! (and sparse didn't complain either)

I'll go have a look see what's special on my end. I'm guessing no SMP or
something.

Would you like the series/patch reposted including this fix?


Thanks,

Dave.
