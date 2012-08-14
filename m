Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57501 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2HNTNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 15:13:25 -0400
Received: by ggdk6 with SMTP id k6so847642ggd.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2012 12:13:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A3190138F360@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A3190138F360@sbs2003.acksys.local>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 14 Aug 2012 12:13:03 -0700
Message-ID: <CAG6hwVMir23S-v0p=r=vkDn5Cu7fOSSEXaAU5jtSrVsC-Bp4ow@mail.gmail.com> (sfid-20120814_211328_788803_E42C9EBA)
Subject: Re: Mesh addressing issue
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cedric,

On Tue, Aug 14, 2012 at 9:25 AM, Cedric VONCKEN
<cedric.voncken@acksys.fr> wrote:
> I think I found an issue in mesh addressing.
> I used the compat-2012-06-14.
>
> My network topology for the test is :
> -----------------      -------------------   Wired LAN       -----------------
> |MP1              |   |MP2                   |------------------| Computer      |
> |192.168.4.1|    |192.168.4.253|                            |192.168.4.90 |
> -----------------     -------------------                               ---------------
>
> The MP1 is not bridged with any wired interface (The ip address is set directly on WLAN0 interface)
> The MP2 is bridged with eth0 to offer link with a wired network (My computer is connected with the wired network).
>
> If I try to ping from Computer to MP1.
>       The ICMP request sent on WiFi (from MP2 to MP1) is a broadcast frame using a strange address format (3 address in 802.11 header + 1 address in mesh extension) .
>       The ICMP reply sent on wifi (from MP1 to MP2) is unicast frame using 6 addresses format.
>
> Why the ICMP request is sent with address 1 set to broadcast (It was not the case for older compat-2011-08-25)?
>
> If in MP1 I move the WLAN0 to a bridge with brctl (with no other interface), ICMP request are still sent with broadcast,
> But
>  If I change the mac address of bridge interface, the ICMP request is now sent in unicast  format (using the 6 addresses formats) !

Based on the information you've provided, none of this immediately
sounds wrong. Can you please link to a capture file we can
investigate?

Thanks,
Thomas
