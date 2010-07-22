Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58124 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab0GVNaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 09:30:12 -0400
Date: Thu, 22 Jul 2010 09:21:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
Message-ID: <20100722132150.GB18742@tuxdriver.com>
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
 <1279780458.2322.25.camel@powerslave>
 <4C47F706.4060102@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C47F706.4060102@iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 09:45:10AM +0200, Kalle Valo wrote:
> On 07/22/2010 08:34 AM, Luciano Coelho wrote:

> >> @@ -467,7 +467,7 @@ static int wl1251_boot_upload_nvs(struct wl1251 *wl)
> >>  		val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
> >>  		       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
> >>  
> >> -		val = cpu_to_le32(val);
> >> +		val = (u32 __force) cpu_to_le32(val);
> > 
> > This will work, but such casts always make me a bit suspicious.  I think
> > this is fine for now
> 
> This line was very suspicious already from beginning, I can't remember
> why it was added and I don't see why it's needed here.

It certainly is a bit strange, and rather ugly as well.  I agree that
the write should probably just take the le32 instead, but I was more
interested in silencing sparse than in rewriting a driver for which
I have not hardware. :-)

I could drop that hunk for the time being?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
