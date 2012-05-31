Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36480 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2EaOqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 10:46:48 -0400
Date: Thu, 31 May 2012 09:46:42 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 4/8] brcm80211: smac: inform mac80211 of the X2
 regulatory domain
Message-ID: <20120531144642.GB32179@thinkpad-t410> (sfid-20120531_164651_664582_A14B8E39)
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-5-git-send-email-seth.forshee@canonical.com>
 <4FC008AB.4080107@broadcom.com>
 <20120526171800.GC11759@ubuntu-mba>
 <4FC21B3F.6090903@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC21B3F.6090903@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 27, 2012 at 02:17:03PM +0200, Arend van Spriel wrote:
> >> can this be moved in brcms_c_channel_mgr_attach()?
> > 
> > Not without rearranging the initialization, as brcms_c_regd_init() must
> > be called after wiphy->bands has been set up. I don't see any reason why
> > setting up the bands couldn't be moved to before channel_mgr_attach()
> > though, and in that case regd_init() could be moved into
> > channel_mgr_attach().
> 
> Please do. I prefer to keep regd_init() local to channel.c.

Further inspection revealed dependencies here that I missed the first
time. ieee_hw_rate_init() relies on a couple of things done in
brcms_c_attach(), which is calling the channel_mgr_attach() function. As
far as I can tell we could still run ieee_hw_init() before
channel_mgr_attach(), but we need the first half of brcms_c_attach() to
run first.

So our options seem to be either calling ieee_hw_init() from
brcms_c_attach() or breaking up brcms_c_attach() into two parts and
calling ieee_hw_init() in the middle. Or else calling
brcms_c_regd_init() from brcms_attach() as I have it now. What's your
preference?

Thanks,
Seth

