Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:2612 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbXGENcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 09:32:08 -0400
Received: by wa-out-1112.google.com with SMTP id v27so3610876wah
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2007 06:32:07 -0700 (PDT)
Message-ID: <9e4733910707050632m794944b5nb9ac9393b05dfa75@mail.gmail.com>
Date: Thu, 5 Jul 2007 09:32:07 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Multiple interfaces in mac80211
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <200707042305.40944.flamingice@sourmilk.net>
	 <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/5/07, Tomas Winkler <tomasw@gmail.com> wrote:
> Does anybody have/ think of a patch that removes the master interface
> from the sub_if_list. It slows down the receive path. Second problem
> with this is that the code becomes incorrect when opening receive path
> for control packets.  Meanwhile as a workaround I've changed iw_mode
> of the master interface  to invalid value instead of default
> IEEE80211_IF_TYPE_AP.

I'm debugging this because I've been trying for two days without
success to get monitor mode to work. I have the adapter in promisc
mode and the interface in monitor mode.  I can see directed and
broadcast traffic with tcpdump, but not directed traffic for other
nodes.

I've added debug printk to mac80211 and the non-directed packets are
making it to
ieee80211_rx_monitor and onto netif_rx. But they don't come out the
tcpdump interface. I don't have iptables loaded. What's eating these
packets in the higher layers?

>
>
> On 7/5/07, Michael Wu <flamingice@sourmilk.net> wrote:
> > On Wednesday 04 July 2007 17:23, Jon Smirl wrote:
> > > I added some debugging code to __ieee80211_rx() and I noticed in this loop:
> > >               list_for_each_entry(sdata, &local->sub_if_list, list) {
> > >
> > sub_if_list includes the master interface.
> >
> > -Michael Wu
> >
> >
>


-- 
Jon Smirl
jonsmirl@gmail.com
