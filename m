Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28308.mail.ukl.yahoo.com ([87.248.110.127]:26281 "HELO
	web28308.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753159AbZIKI2c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 04:28:32 -0400
Message-ID: <759014.23228.qm@web28308.mail.ukl.yahoo.com>
Date: Fri, 11 Sep 2009 08:28:34 +0000 (GMT)
From: Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] sdio: pass unknown cis tuples to sdio drivers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090911010102.4c7840b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- El vie, 11/9/09, Andrew Morton <akpm@linux-foundation.org> escribió:
> > > 
> > > ret == -EINVAL
> > > 
> > 
> > At this point ret is not -EINVAL.
> 
> Yes it is.  We just did
> 
>     ret = -EINVAL;
> 
> 
> If that assignment happens, we leak `this'.
> 

Hi Andrew,

I misunderstood you. I thought that you were trying to imply on your original comment that retval was _already_ -EINVAL at that point.

Now I see the issue. `this' should be freed if successfully parsed (!ret) or if invalid and not going to be passed to a SDIO driver (ret == -EINVAL).

Thanks for catching that. I'll send an updated patch.

Cheers,
Albert



      
