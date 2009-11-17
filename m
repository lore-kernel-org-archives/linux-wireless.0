Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbZKQUlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 15:41:49 -0500
Subject: Re: [RFC] mac80211: disallow bridging managed/adhoc interfaces
From: Dan Williams <dcbw@redhat.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <20091117090420.0434edc3@nehalam>
References: <1258465585.3682.7.camel@johannes.local>
	 <200911171504.54170.mb@bu3sch.de> <1258466868.3682.13.camel@johannes.local>
	 <20091117083741.1b165274@nehalam> <1258476223.21197.0.camel@johannes.local>
	 <20091117090420.0434edc3@nehalam>
Content-Type: text/plain
Date: Tue, 17 Nov 2009 12:41:08 -0800
Message-Id: <1258490468.4447.23.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-11-17 at 09:04 -0800, Stephen Hemminger wrote:
> On Tue, 17 Nov 2009 17:43:43 +0100
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > On Tue, 2009-11-17 at 08:37 -0800, Stephen Hemminger wrote:
> > 
> > > But there are people bridging wireless, and hostap even has a mode for
> > > that. 
> > 
> > But that's the AP side, which this patch doesn't attempt to prevent. It
> > just makes no sense to bridge when connected to an AP or part of an
> > IBSS.
> > 
> 
> Then how does this work now? And will your change break it?
> 
>                              kvm1
>                             /
>      ====> wlan0  --- bridge-- kvm2
>                             \
>                              kvm3

Are you sure 'bridge' isn't NAT-ed to wlan0 like libvirt/etc do by
default?  That's about the only way it can possibly work correctly with
wifi.

Dan


