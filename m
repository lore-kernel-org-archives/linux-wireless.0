Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from civicrm.laptop.org ([18.85.44.157]:53310 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751810AbdITXWf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 19:22:35 -0400
Date: Thu, 21 Sep 2017 09:22:28 +1000
From: James Cameron <quozl@laptop.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: rtl8821ae keep alive not set, connection lost
Message-ID: <20170920232228.GC9210@us.netrek.org> (sfid-20170921_012241_945708_B6181C84)
References: <20170912220916.GB32211@us.netrek.org>
 <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net>
 <20170913214649.GC20283@us.netrek.org>
 <5f16881e-471b-4ffc-5e5e-93785bb999b6@lwfinger.net>
 <20170914092738.GG20283@us.netrek.org>
 <20170919094204.GR26927@us.netrek.org>
 <20170920093633.GO9946@us.netrek.org>
 <476b183f-5cc5-9a34-1a85-332dd5244b66@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <476b183f-5cc5-9a34-1a85-332dd5244b66@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 20, 2017 at 04:48:23PM -0500, Larry Finger wrote:
> On 09/20/2017 04:36 AM, James Cameron wrote:
> >When the problem occurs, register 0x350 bit 25 is set, for which a
> >comment in _rtl8821ae_check_pcie_dma_hang says means there is an RX
> >hang.
> >
> >So perhaps driver should call _rtl8821ae_check_pcie_dma_hang
> >and _rtl8821ae_reset_pcie_interface_dma.
> >
> >Any ideas where to do this?
> 
> Thanks for the extended debugging.
> 
> I was able to repeat your findings. With the 8-bit read of
> REG_DBI_RDATA, I got poor connection stability. Reverting that part
> made it stable again. For that reason, I pushed the partial
> reversion of commit 40b368af4b75 ("rtlwifi: Fix alignment issues").

That's great you were able to reproduce, thanks!

> Where did you detect that bit 25 of register 0x350 was set?

In _rtl8821ae_check_pcie_dma_hang on link up.

REG_DBI_FLAG (0x350 bits 16-31) is observed as;

- 0x0000 on entry to function after warm boot,

- 0x0400 on exit from function; debug bit 23 is set by the function,

- 0x0400 on entry to function on link up when the problem has not
  happened,

- 0x0600 on entry to function on link up when the problem has
  happened.

But I don't know if 0x0600 is useful to detect earlier, or if it is
only a symptom of link down while device active.  Either way, if it
truly does signal an RX hang or firmware RX queue full, it's useful.

My "-q9" and "-qa" test kernels dump REG_DBI_CTRL and REG_DBI_FLAG.

"-q9" is with 8-bit read of REG_DBI_RDATA.

"-qa" is with 16-bit read of REG_DBI_DATA.

My "-qa" test kernel;
http://dev.laptop.org/~quozl/y/1dunwN.txt (git diff v4.13)
http://dev.laptop.org/~quozl/z/1dubX7.txt (dmesg)

REG_DBI_CTRL+3 used by _rtl8821ae_check_pcie_dma_hang is effectively
REG_DBI_FLAG+1 (0x353).

REG_DBI_CTRL is REG_DBI_ADDR; a duplicate register definition.

I'm still pondering a few more theories;

- change write_readback, it is true now, and the while()/udelay in
  _rtl8821ae_dbi_read seems a waste, it never executes,

- clearing REG_DBI_CTRL write enable bits at the end of
  _rtl8821ae_dbi_write,

- switching to 32-bit access as used by rtl8192de.

And a giggle from reviewing the code,
_rtl8821ae_wowlan_initialize_adapter says "Patch Pcie Rx DMA hang
after S3/S4 several times.  The root cause has not be found."
... I've learned that root causes that aren't found tend to cause
further problems later.  ;-)

Given this, my gut feel is firmware or silicon problem; RX DMA ceases,
the driver does not detect it, the connection is lost.

-- 
James Cameron
http://quozl.netrek.org/
