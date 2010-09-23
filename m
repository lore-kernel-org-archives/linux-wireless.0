Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-mx06.nokia.com ([192.100.122.233]:18218 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab0IWHr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 03:47:28 -0400
Subject: Re: [PATCH] wl1271: Fix overflow in wl1271_boot_upload_nvs
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ido Yariv <ido@wizery.com>,
	John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Katila Tuomas.2 (EXT-Ixonos/Tampere)"
	<ext-tuomas.2.katila@nokia.com>
In-Reply-To: <1285151082.22517.8.camel@chilepepper>
References: <1285141993-3772-1-git-send-email-ido@wizery.com>
	 <1285151082.22517.8.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 10:46:33 +0300
Message-ID: <1285227993.3231.19.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 12:24 +0200, Luciano Coelho wrote:
> On Wed, 2010-09-22 at 09:53 +0200, ext Ido Yariv wrote:
> > Due to miscalculation of nvs_len, excessive data was sent to the
> > firmware.
> > Fix this by first setting nvs_ptr to point to the first NVS table,
> > and computing the total size of all NVS tables accordingly.
> > 
> > Signed-off-by: Ido Yariv <ido@wizery.com>
> > ---
> 
> This looks reasonable, thanks!
> 
> But I still want to have it briefly tested before I accept it.  Our
> tester will try it out today or tomorrow and, if everything is okay,
> I'll ack it.
> 

Okay, Tuomas has run some basic tests with this patch and didn't
observer any degradation in RF (which would signal possible problems
with the NVS uploading).

Thanks, Ido!

Tested-By: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

John, please apply this patch, since my tree is not ready yet.

-- 
Cheers,
Luca.

