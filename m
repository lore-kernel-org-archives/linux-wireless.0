Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from civicrm.laptop.org ([18.85.44.157]:41046 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751623AbdITJgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 05:36:42 -0400
Date: Wed, 20 Sep 2017 19:36:33 +1000
From: James Cameron <quozl@laptop.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: rtl8821ae keep alive not set, connection lost
Message-ID: <20170920093633.GO9946@us.netrek.org> (sfid-20170920_113651_121808_C2710399)
References: <20170912220916.GB32211@us.netrek.org>
 <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net>
 <20170913214649.GC20283@us.netrek.org>
 <5f16881e-471b-4ffc-5e5e-93785bb999b6@lwfinger.net>
 <20170914092738.GG20283@us.netrek.org>
 <20170919094204.GR26927@us.netrek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170919094204.GR26927@us.netrek.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 19, 2017 at 07:42:04PM +1000, James Cameron wrote:
> On Thu, Sep 14, 2017 at 07:27:39PM +1000, James Cameron wrote:
> > On Wed, Sep 13, 2017 at 07:39:35PM -0500, Larry Finger wrote:
> > > On 09/13/2017 04:46 PM, James Cameron wrote:
> > > >
> > > >I'll give it some more testing and let you know, but it seems as
> > > >capable of keeping a connection as 4.13 plus my earlier revert.
> > > >
> > 
> > Testing went well; removing the call to enable ASPM was as good as
> > changing the DBI read back to 16-bit width.
> > 
> > > The change I sent earlier should be as good as reverting the change
> > > to write_byte in your reversion.
> > 
> > Yes, that would be the hope.
> > 
> > But with the 16-bit DBI read, the register REG_DBI_CTRL+0 is being
> > read as well, in the first read in _rtl8821ae_enable_aspm_back_door,
> > so perhaps reading that register has an unexpected side-effect.
> > 
> 
> I've ruled that out after testing for several days different kernels
> based on v4.13;
> 
> - add an rtl_read_byte of REG_DBI_CTRL+0 in rtl8821ae_hw_init just
>   after the call to enable_aspm; does not solve problem,
> 
> - add an rtl_read_byte of REG_DBI_CTRL+0 at the start of
>   _rtl8821ae_check_pcie_dma_hang; does not solve problem,

When the problem occurs, register 0x350 bit 25 is set, for which a
comment in _rtl8821ae_check_pcie_dma_hang says means there is an RX
hang.

So perhaps driver should call _rtl8821ae_check_pcie_dma_hang
and _rtl8821ae_reset_pcie_interface_dma.

Any ideas where to do this?

> [...]

-- 
James Cameron
http://quozl.netrek.org/
