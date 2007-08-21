Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2691 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXHUUpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 16:45:12 -0400
Date: Tue, 21 Aug 2007 16:13:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [patch 6/6] b43: New firmware file format
Message-ID: <20070821201336.GA5313@tuxdriver.com>
References: <20070818234833.623623000@bu3sch.de> <20070818234836.401097000@bu3sch.de> <1187711200.4218.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187711200.4218.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 21, 2007 at 05:46:40PM +0200, Johannes Berg wrote:
> On Sun, 2007-08-19 at 01:48 +0200, Michael Buesch wrote:
> 
> > @@ -1598,8 +1601,29 @@ static int do_request_fw(struct b43_wlde
> >  		b43err(dev->wl, "Firmware file \"%s\" not found "
> >  		       "or load failed.\n", path);
> 
> +		return err;
> 
> >  	}
> > +	if ((*fw)->size < sizeof(struct b43_fw_header))
> > +		goto err_format;
> 
> otherwise it oopses when the file can't be loaded.

ACK...here is a patch, in case you are lazy... :-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index dcf7edc..d8693cf 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1600,6 +1600,7 @@ static int do_request_fw(struct b43_wldev *dev,
 	if (err) {
 		b43err(dev->wl, "Firmware file \"%s\" not found "
 		       "or load failed.\n", path);
+		return err;
 	}
 	if ((*fw)->size < sizeof(struct b43_fw_header))
 		goto err_format;
-- 
John W. Linville
linville@tuxdriver.com
