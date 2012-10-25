Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab2JYNEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 09:04:08 -0400
Date: Thu, 25 Oct 2012 15:03:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	David Herrmann <dh.herrmann@googlemail.com>,
	Stephen Boyd <bebarino@gmail.com>
Subject: Re: [PATCH] rt2x00: usb: fix reset resume
Message-ID: <20121025130332.GA5202@redhat.com> (sfid-20121025_150411_938122_37331224)
References: <20121016123409.GA2274@redhat.com>
 <20121024183525.GA4204@redhat.com>
 <20121024214455.GA12728@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121024214455.GA12728@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 24, 2012 at 05:44:55PM -0400, John W. Linville wrote:
> On Wed, Oct 24, 2012 at 08:35:26PM +0200, Stanislaw Gruszka wrote:
> > On Tue, Oct 16, 2012 at 02:34:12PM +0200, Stanislaw Gruszka wrote:
> > > Patch fixes warnings like below happened on resume:
> > > 
> > > WARNING: at net/mac80211/driver-ops.h:12 check_sdata_in_driver+0x32/0x34()
> > > 
> > > Problem is that in __ieee80211_susped() we remove sdata (i.e wlan0
> > > interface) and then during resume we call usb_unbind_interface() ->
> > > ieee80211_unregister_hw() with sdata removed.
> > > 
> > > Patch fixes problem by adding .reset_resume calback, hence we do not
> > > unbind usb device on resume. This callback can be the same as normal
> > > .resume callback, sice we do all needed initalization during interface
> > > start, which is performed on resume [ ieee80211_resume() ->
> > > ieee80211_reconfig() -> rt2x00mac_start() -> rt2x00lib_start ].
> > > 
> > > Resolves:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=48041
> > > 
> > > Reported-by: David Herrmann <dh.herrmann@googlemail.com>
> > > Reported-and-tested-by: Stephen Boyd <bebarino@gmail.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > 
> > NACK for this patch, Randomly I'm able to reproduce strange crashes
> > when suspending and transiting data, which seem to not happen without
> > this patch. Until I'll figure this out, let's not apply the patch.
> 
> Of course, I just applied this today...any chance for a fixup?

This problem is tricky, I'm not expecting fix soon. However I can not
reproduce it on 3.7 and can on 3.6. So I think patch can go to 3.7 .
Could you remove cc stable from it? If not, I'll NACK backported patch,
when GregKH will send information about the backport.

Stanislaw 
