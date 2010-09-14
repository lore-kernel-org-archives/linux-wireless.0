Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61736 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0INTcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 15:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <20100914192738.GB21918@void.printf.net>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com>
 <1283858949-11073-8-git-send-email-ohad@wizery.com> <20100914192738.GB21918@void.printf.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 14 Sep 2010 21:32:01 +0200
Message-ID: <AANLkTikA+LXc4hq0WLEa6H146Rfib5iqGBKi-Cey41vt@mail.gmail.com>
Subject: Re: [PATCH v1 7/8] sdio: enable Runtime PM for SDIO functions
To: Chris Ball <cjb@laptop.org>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chris,

On Tue, Sep 14, 2010 at 9:27 PM, Chris Ball <cjb@laptop.org> wrote:
> On Tue, Sep 07, 2010 at 02:29:08PM +0300, Ohad Ben-Cohen wrote:
> > @@ -152,6 +173,11 @@ static int sdio_bus_remove(struct device *dev)
> >               sdio_release_host(func);
> >       }
> >
> > +     pm_runtime_put_noidle(dev);
> > +
> > +     /* Undo the runtime PM settings in sdio_bus_probe() */
> > +     pm_runtime_put_noidle(dev);
> > +
> >       return 0;
> >  }
> >
>
> Nit:  This makes sense in context, but stands out as a possible paste
> accident on first sight.  :)  I think it's worth adding a comment to
> the first call

Will do, thanks for the review!

Ohad.
