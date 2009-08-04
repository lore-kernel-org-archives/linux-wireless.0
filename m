Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56779 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260AbZHDU1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 16:27:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] remove wrong probe_resp_plcp write
Date: Tue, 4 Aug 2009 22:27:45 +0200
Cc: gregor kowski <gregor.kowski@gmail.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <83a869cd0907311335h3065547aqc736573a663b6d42@mail.gmail.com> <200907312238.15705.mb@bu3sch.de> <20090804160558.GC4995@tuxdriver.com>
In-Reply-To: <20090804160558.GC4995@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908042227.46237.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 August 2009 18:05:58 John W. Linville wrote:
> On Fri, Jul 31, 2009 at 10:38:14PM +0200, Michael Buesch wrote:
> > On Friday 31 July 2009 22:35:49 gregor kowski wrote:
> > > The tkip hw support uncovered a bug in b43_write_probe_resp_template : it is
> > > writing at the wrong shm offset, it is in the B43_SHM_SH_TKIPTSCTTAK zone. This
> > > patch comments these writes.
> > > 
> > > Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
>   CC [M]  drivers/net/wireless/b43/main.o
> drivers/net/wireless/b43/main.c:1432: warning: ‘b43_write_probe_resp_plcp’ defined but not used
> 
> Comment it out too?  Or are you going to fix the block that has been
> commented-out here?

No, please add
#if 0
void b43_write_probe_resp_plcp(...)
{
...
}
#endif /* 0 */

to comment out the function, too.
The probe response offload is currently not supported by mac80211.

-- 
Greetings, Michael.
