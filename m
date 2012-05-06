Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s10.blu0.hotmail.com ([65.55.111.85]:1056 "EHLO
	blu0-omc2-s10.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754616Ab2EFSHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 14:07:43 -0400
Message-ID: <BLU0-SMTP115782BC51E012F1967E169AC120@phx.gbl> (sfid-20120506_200747_850956_E3EFCB4F)
Subject: Re: [PATCH v3 6/6] bcma: Add flush for BCMA_RESET_CTL write
From: Nathan Hintz <nlhintz@hotmail.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Date: Sun, 6 May 2012 11:07:31 -0700
In-Reply-To: <4FA5902E.8080308@broadcom.com>
References: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
	 <BLU0-SMTP198AA334D9A1CD0C329E1A5AC2D0@phx.gbl>
	 <4FA4C2CA.8000401@broadcom.com>
	 <BLU0-SMTP3963C1457D4A5496FC3C3A3AC2D0@phx.gbl>
	 <4FA51FFE.4070100@hauke-m.de> <4FA5902E.8080308@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-05-05 at 22:40 +0200, Arend van Spriel wrote:
> On 05/05/2012 02:41 PM, Hauke Mehrtens wrote:
> > On 05/05/2012 09:50 AM, Nathan Hintz wrote:
> >> On Sat, 2012-05-05 at 08:03 +0200, Arend van Spriel wrote:
> >>> On 05/05/2012 06:56 AM, Nathan Hintz wrote:
> >>>> Adds a missing read to flush the previous write (per the Broadcom SDK).
> >>>>
> >>>> Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
> >>>> ---
> >>>>  drivers/bcma/core.c |    1 +
> >>>>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>>>
> >>>> diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
> >>>> index 893f6e0..c4e6deb 100644
> >>>> --- a/drivers/bcma/core.c
> >>>> +++ b/drivers/bcma/core.c
> >>>> @@ -30,6 +30,7 @@ void bcma_core_disable(struct bcma_device *core, u32 flags)
> >>>>  	udelay(10);
> >>>>  
> >>>>  	bcma_awrite32(core, BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
> >>>> +	bcma_aread32(core, BCMA_RESET_CTL);
> >>>>  	udelay(1);
> >>>>  }
> >>>>  EXPORT_SYMBOL_GPL(bcma_core_disable);
> >>>
> >>> Hi Nathan,
> >>>
> >>> The read after write is only needed on (certain) SoCs. As bcma is not
> >>> being used just for these SoCs I suggest to make the flush conditional.
> >>> In brcmsmac we introduced "flushed write" function, which does the read
> >>> only for those SoCs.
> >>>
> >>> Gr. AvS
> >>>
> >>>
> >> There are several other occurrences in core.c that are the same
> >> implementation as what was added in this patch.  Is there a reason
> >> why the existing code isn't the way you have suggested already?
> >> Would it be better to submit your suggestion as a separate patch, or
> >> just roll it all into this one?
> >>
> >> Nathan
> > 
> > In some older versions of the Broadcom SDK (e.g. version with wl
> > 5.10.147.0 and the version brcmsmac seams to be based on) this read is
> > not included in ai_core_disable(), but in more recent versions (e.g.
> > version including wl 5.100.138.9) this read is included unconditionally.
> > 
> > @Arend For what SoCs should we read after this write?
> > When you are speaking of (certain) SoCs are you talking about this code
> > and comment from brcmsmac?
> > 
> > #ifdef CONFIG_BCM47XX
> > /*
> >  * bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
> >  * transactions. As a fix, a read after write is performed on certain places
> >  * in the code. Older chips and the newer 5357 family don't require this
> > fix.
> >  */
> > #define bcma_wflush16(c, o, v) \
> > 	({ bcma_write16(c, o, v); (void)bcma_read16(c, o); })
> > 
> > 
> > Hauke
> > 
> 
> Yes, Those are indeed the SoCs I meant. I was being to lazy to look it
> up, so thanks for making the effort ;-)
> 
> Gr. AvS
> 
> 
Is there a reason why a similar 'flush write' function was not applied
to all of the writes to 'objaddr' in 'brcmsmac/main.c', or are these
flushes not '4716/4717/4718/4706' specific?  For example:

static void brcms_b_set_cwmin(struct brcms_hardware *wlc_hw, u16 newmin)
{
	wlc_hw->band->CWmin = newmin;

	bcma_write32(wlc_hw->d11core, D11REGOFFS(objaddr),
		     OBJADDR_SCR_SEL | S_DOT11_CWMIN);
	(void)bcma_read32(wlc_hw->d11core, D11REGOFFS(objaddr));
	bcma_write32(wlc_hw->d11core, D11REGOFFS(objdata), newmin);
}

Nathan

