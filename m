Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46362 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZL1Ra3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 12:30:29 -0500
Date: Mon, 28 Dec 2009 12:23:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
Message-ID: <20091228172317.GB5354@tuxdriver.com>
References: <83a869cd0908211513k2e14ba40k251aa8a1e7393a77@mail.gmail.com> <1250927141.23605.3.camel@johannes.local> <83a869cd0911071010g32c798c6pfecd875a1bf484e0@mail.gmail.com> <1257621757.29454.48.camel@johannes.local> <83a869cd0911161353p5ea44472s8e6f146929ff6c65@mail.gmail.com> <1258408565.32159.42.camel@johannes.local> <83a869cd0912071306y4a56953fm8248b6d030b311ae@mail.gmail.com> <83a869cd0912091421s62b704f6wae023c61cab85e92@mail.gmail.com> <83a869cd0912091425h4c1f2815m71c9b4fa6f0954df@mail.gmail.com> <83a869cd0912280846r5caccfc8s764148f8939be469@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <83a869cd0912280846r5caccfc8s764148f8939be469@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 28, 2009 at 05:46:46PM +0100, gregor kowski wrote:
> Hi,
> 
> On 12/9/09, gregor kowski <gregor.kowski@gmail.com> wrote:
> > The mac80211 tkip code won't call update_tkip_key, if rx packets
> > are received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
> > first packet because the hardware key stuff is called asynchronously with
> > todo workqueue.
> >
> > This patch workaround that by tracking if we sent the key to the driver.
> >
> What's the status of this patch ?

commit ca99861d5421c91f5a8fd3a77acb4b7be14f119d
Author: gregor kowski <gregor.kowski@gmail.com>
Date:   Wed Dec 9 23:25:05 2009 +0100

    mac80211 : fix a race with update_tkip_key
    
    The mac80211 tkip code won't call update_tkip_key, if rx packets
    are received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
    first packet because the hardware key stuff is called asynchronously with
    todo workqueue.
    
    This patch workaround that by tracking if we sent the key to the driver.
    
    Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
