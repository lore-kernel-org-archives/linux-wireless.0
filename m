Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934943Ab2JXSf7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 14:35:59 -0400
Date: Wed, 24 Oct 2012 20:35:26 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	David Herrmann <dh.herrmann@googlemail.com>,
	Stephen Boyd <bebarino@gmail.com>
Subject: Re: [PATCH] rt2x00: usb: fix reset resume
Message-ID: <20121024183525.GA4204@redhat.com> (sfid-20121024_203611_556375_8F3C7238)
References: <20121016123409.GA2274@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121016123409.GA2274@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 16, 2012 at 02:34:12PM +0200, Stanislaw Gruszka wrote:
> Patch fixes warnings like below happened on resume:
> 
> WARNING: at net/mac80211/driver-ops.h:12 check_sdata_in_driver+0x32/0x34()
> 
> Problem is that in __ieee80211_susped() we remove sdata (i.e wlan0
> interface) and then during resume we call usb_unbind_interface() ->
> ieee80211_unregister_hw() with sdata removed.
> 
> Patch fixes problem by adding .reset_resume calback, hence we do not
> unbind usb device on resume. This callback can be the same as normal
> .resume callback, sice we do all needed initalization during interface
> start, which is performed on resume [ ieee80211_resume() ->
> ieee80211_reconfig() -> rt2x00mac_start() -> rt2x00lib_start ].
> 
> Resolves:
> https://bugzilla.kernel.org/show_bug.cgi?id=48041
> 
> Reported-by: David Herrmann <dh.herrmann@googlemail.com>
> Reported-and-tested-by: Stephen Boyd <bebarino@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

NACK for this patch, Randomly I'm able to reproduce strange crashes
when suspending and transiting data, which seem to not happen without
this patch. Until I'll figure this out, let's not apply the patch.

Stanislaw
