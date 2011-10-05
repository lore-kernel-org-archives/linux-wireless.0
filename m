Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab1JEO4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 10:56:46 -0400
Subject: Re: [PATCH v3] move brcm80211 drivers to mainline
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Alwin Beukers <alwin@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>
In-Reply-To: <4E8C64EF.3070203@broadcom.com> (sfid-20111005_160911_496386_985D7509)
References: <4E8C64EF.3070203@broadcom.com>
	 (sfid-20111005_160911_496386_985D7509)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 16:56:42 +0200
Message-ID: <1317826602.4839.46.camel@jlt3.sipsolutions.net> (sfid-20111005_165649_310818_3DB408A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-05 at 16:08 +0200, Arend van Spriel wrote:
With number of cleanup patch series merged in by Greg KH, I'd like to
> once again propose moving brcm80211 out of staging and into mainline.
> 
> I've put together a patch to add a copy of the current sources from
> staging-next into drivers/net/wireless/brcm80211 of the wireless-next
> repository.
> 
> The patch is somewhat large, so I've posted the patch at:
> 
> http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=view&target=0001-net-wireless-add-brcm80211-drivers-v3.patch

Some comments.

I sort of understand your fascination with "generic utils" but they're
wasteful if they're in a single driver only. They should either be made
more generic (for all drivers) or dissolved, so:

 * You can get rid of BRCMS_BITSCNT and brcmu_bitcount, they're no
   longer used at all.
 * brcmu_mhz2channel isn't used anywhere either
 * neither is brcmu_chspec_ctlchan
 * brcmu_mw_to_qdbm is used only in a single file,
   it can move there to save the export etc.
 * same for brcmu_qdbm_to_mw, brcmu_chipname, brcmu_parse_tlvs,
   brcmu_chspec_malformed
 * brcmu_mkiovar is used only in fmac, so you can move it there
   to save the export
 * brcmu_format_flags is used only in smac, so same
 * same for brcmu_format_flags

After all the above, bcmutils are left with only the pktq and pktbuf
stuff, which hopefully will be either more generic or dissolved at some
point in the future since it should really just be a few skb queues.

Now the drivers :-)

FMAC:
 * A whole bunch of things in dhd.h still seem to lack endian
   annotations, which I wouldn't be too worried about, if it didn't
   also seem to lack conversions. For example brcmf_pkt_filter_enable,
   brcmf_pkt_filter, brcmf_pkt_filter_pattern.
 * These, along with others like brcmf_bss_info, also seem to lack
   __packed annotations. I thought you fixed all this, what am I
   missing?
 * bss_info[1]; and similar should just be [] I think?
 * some very odd indentation on line 1172 of wl_cfg80211.c

SMAC:
 * do you really want to be 40MHz intolerant all the time? not
   supporting 40 MHz is one thing, but being intolerant?
 * brcms_ops_stop doesn't seem right -- this should really power down
   the device, this shouldn't be done per interface since the monitor
   case will want to RX/TX even when no interface is there; also, you'll
   want multi-vif support soon :-)
 * locking tx() is inefficient, you should be able to go with a lock per
   HW queue
 * brcms_ops_sta_add is strange -- it shouldn't be modifying the station
   parameters, why would it do that? seems like a bug to me, especially
   always assuming the peer can do greenfield etc. This data should
   already be set by mac80211, if not that's a bug, not something to
   "fix" in the driver
 * I still think things like brcms_msleep() are guaranteed to create
   subtle locking bugs that are almost impossible to find since it drops
   the spinlock and if somebody calls the function somewhere they won't
   necessarily keep that in mind. There are a whole bunch of functions
   behaving like that.


Anyway, the code is now readable to me, I see no glaring mac80211 or
cfg80211 interfacing errors, so I guess you can work the rest in
mainline.

johannes

