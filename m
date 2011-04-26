Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:54905 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424Ab1DZIyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 04:54:47 -0400
Received: by mail-yi0-f41.google.com with SMTP id 18so170579yib.28
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 01:54:46 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] wl12xx: consider encryption when configuring
 auto arp template
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTinN2jZdqeCPi6R+tCoF=318UJ_qyQ@mail.gmail.com>
References: <1302774475-2977-1-git-send-email-eliad@wizery.com>
	 <1303800793.2336.25.camel@cumari>
	 <BANLkTinN2jZdqeCPi6R+tCoF=318UJ_qyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 11:54:41 +0300
Message-ID: <1303808081.2172.0.camel@pimenta> (sfid-20110426_105450_918973_2EF38429)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-26 at 11:39 +0300, Eliad Peller wrote:
> >> @@ -2749,8 +2764,10 @@ static void
> wl1271_bss_info_changed_sta(struct wl1271 *wl,
> >>                       ret = wl1271_acx_arp_ip_filter(wl,
> >>                               ACX_ARP_FILTER_ARP_FILTERING,
> >>                               addr);
> >> -             } else
> >> +             } else {
> >> +                     wl->ip_addr = 0;
> >>                       ret = wl1271_acx_arp_ip_filter(wl, 0, addr);
> >> +             }
> >
> > This is not important at all, but maybe it's a bit cleaner: you
> could
> > remove the addr argument in wl1271_acx_arp_ip_filter() and always
> use
> > wl->ip_addr instead? You could then also get rid of the local addr
> here.
> >
> in fact, since we are going toward multi-role fw, i do try to avoid
> using the global wl struct as much as possible.
> anyway, i didn't change this function, so i don't think it's the right
> patch to change it.
> (we should probably change a lot of functions after we'll have a
> per-interface data) 

Agreed. :)

-- 
Cheers,
Luca.

