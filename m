Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from store.laptop.org ([18.85.44.157]:60262 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751794AbdIVFgF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Sep 2017 01:36:05 -0400
Date: Fri, 22 Sep 2017 15:35:58 +1000
From: James Cameron <quozl@laptop.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: rtl8821ae keep alive not set, connection lost
Message-ID: <20170922053558.GK12195@us.netrek.org> (sfid-20170922_073608_537033_F760A9BC)
References: <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net>
 <20170913214649.GC20283@us.netrek.org>
 <5f16881e-471b-4ffc-5e5e-93785bb999b6@lwfinger.net>
 <20170914092738.GG20283@us.netrek.org>
 <20170919094204.GR26927@us.netrek.org>
 <20170920093633.GO9946@us.netrek.org>
 <476b183f-5cc5-9a34-1a85-332dd5244b66@lwfinger.net>
 <20170920232228.GC9210@us.netrek.org>
 <20170921080746.GL9210@us.netrek.org>
 <abff13d3-4115-4935-6546-b0fd8c860124@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <abff13d3-4115-4935-6546-b0fd8c860124@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 21, 2017 at 09:40:14AM -0500, Larry Finger wrote:
> On 09/21/2017 03:07 AM, James Cameron wrote:
> >My test kernel "-qb" was write_readback = false in sw.c, with 8-bit
> >read of REG_DBI_RDATA, and has been stable for four hours.  I'll
> >focus on some more testing of this one.  It is a surprise.
> >
> >http://dev.laptop.org/~quozl/z/1dutXk.txt  (dmesg)
> >
> >Observe how REG_DBI_FLAG+0 is briefly seen as 1, which doesn't
> >happen with write_readback = true.
> 
> Again, thanks for your efforts.
> 
> At this point, my system has been up over 17 hours without a single
> drop. As a result, I will leave the reversion of commit 40b368af4b75
> in place. It seems safer than turning off write_readback. After we
> get more testing, that could still be an option.

Thanks for the reversion commit, I'll point others to it.

My apologies for sloppy work, the test kernel features got swapped!
"-qb" above was with write_readback off, and 16-bit read of
REG_DBI_RDATA, not 8-bit.  Verified with objdump.  It has run for 24
hours without a drop.

So at conclusion;

- the 16-bit read is good with or without write_readback.

- the 8-bit read is bad with or without write_readback, and tends to
  lose connection much quicker without write_readback.

Been a pleasure working with you.  Back to lurk mode.

-- 
James Cameron
http://quozl.netrek.org/
