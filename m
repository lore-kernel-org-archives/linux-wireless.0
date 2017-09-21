Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from store.laptop.org ([18.85.44.157]:40844 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752077AbdIUIHy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 04:07:54 -0400
Date: Thu, 21 Sep 2017 18:07:46 +1000
From: James Cameron <quozl@laptop.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: rtl8821ae keep alive not set, connection lost
Message-ID: <20170921080746.GL9210@us.netrek.org> (sfid-20170921_100806_187014_C3F7B61B)
References: <20170912220916.GB32211@us.netrek.org>
 <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net>
 <20170913214649.GC20283@us.netrek.org>
 <5f16881e-471b-4ffc-5e5e-93785bb999b6@lwfinger.net>
 <20170914092738.GG20283@us.netrek.org>
 <20170919094204.GR26927@us.netrek.org>
 <20170920093633.GO9946@us.netrek.org>
 <476b183f-5cc5-9a34-1a85-332dd5244b66@lwfinger.net>
 <20170920232228.GC9210@us.netrek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170920232228.GC9210@us.netrek.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 21, 2017 at 09:22:28AM +1000, James Cameron wrote:
> On Wed, Sep 20, 2017 at 04:48:23PM -0500, Larry Finger wrote:
> > On 09/20/2017 04:36 AM, James Cameron wrote:
> > >When the problem occurs, register 0x350 bit 25 is set, for which a
> > >comment in _rtl8821ae_check_pcie_dma_hang says means there is an RX
> > >hang.
> > >
> > >So perhaps driver should call _rtl8821ae_check_pcie_dma_hang
> > >and _rtl8821ae_reset_pcie_interface_dma.
> > >
> > >Any ideas where to do this?
> > 
> > Thanks for the extended debugging.
> > 
> > I was able to repeat your findings. With the 8-bit read of
> > REG_DBI_RDATA, I got poor connection stability. Reverting that part
> > made it stable again. For that reason, I pushed the partial
> > reversion of commit 40b368af4b75 ("rtlwifi: Fix alignment issues").
> 
> That's great you were able to reproduce, thanks!
> [...]
> I'm still pondering a few more theories;
> 
> - change write_readback, it is true now, and the while()/udelay in
>   _rtl8821ae_dbi_read seems a waste, it never executes,

My test kernel "-qb" was write_readback = false in sw.c, with 8-bit
read of REG_DBI_RDATA, and has been stable for four hours.  I'll focus
on some more testing of this one.  It is a surprise.

http://dev.laptop.org/~quozl/z/1dutXk.txt (dmesg)

Observe how REG_DBI_FLAG+0 is briefly seen as 1, which doesn't happen
with write_readback = true.

> - clearing REG_DBI_CTRL write enable bits at the end of
>   _rtl8821ae_dbi_write,

My test kernel "-qc" had reset of REG_DBI_ADDR as last step in both
_rtl8821ae_dbi_read and _rtl8821ae_dbi_write, and was very unstable,
not able to connect.

http://dev.laptop.org/~quozl/y/1dutbX.txt (git diff v4.13)
http://dev.laptop.org/~quozl/z/1dutuM.txt (dmesg)

My test kernel "-qd" had reset of REG_DBI_ADDR as last step in only
_rtl8821ae_dbi_write, and had poor connection stability.

http://dev.laptop.org/~quozl/y/1dutr3.txt (git diff v4.13)
http://dev.laptop.org/~quozl/z/1duuDc.txt (dmesg connection lost)

Based on the above two kernels, clearing REG_DBI_ADDR after a read is
a bad idea, and suggests there is some underlying asynchronicity about
the DBI access.  Almost as if some other condition should signal
completion rather than zero in REG_DBI_FLAG+0.

> - switching to 32-bit access as used by rtl8192de.

My test kernel "-qe" changed RED_DBI_RDATA read to 32-bit, then used a
union hack to pull out the desired byte, and had poor connection
stability.

http://dev.laptop.org/~quozl/y/1duvIC.txt (git diff v4.13)
http://dev.laptop.org/~quozl/z/1duwI1.txt (dmesg connection lost)

-- 
James Cameron
http://quozl.netrek.org/
