Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbYIBTal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 15:30:41 -0400
Date: Tue, 2 Sep 2008 12:29:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: bugme-daemon@bugzilla.kernel.org, karthikg@deccantechnosoft.com
Subject: Re: [Bugme-new] [Bug 11483] New: Raw socket tx/rx program for
 "ath0" shows "sending: : No buffer space available"
Message-Id: <20080902122938.f3858d6d.akpm@linux-foundation.org> (sfid-20080902_213052_726990_87D4F3CC)
In-Reply-To: <bug-11483-10286@http.bugzilla.kernel.org/>
References: <bug-11483-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

I assume this is an atheros driver problem, not a core networking
problem..

On Tue,  2 Sep 2008 12:07:51 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11483
> 
>            Summary: Raw socket tx/rx program for "ath0" shows "sending: : No
>                     buffer space available"
>            Product: Networking
>            Version: 2.5
>      KernelVersion: Linux 2.6.26.3 armv5teb
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: IPV4
>         AssignedTo: shemminger@linux-foundation.org
>         ReportedBy: karthikg@deccantechnosoft.com
> 
> 
> Latest working kernel version:Linux 2.6.26.3 armv5teb
> Earliest failing kernel version:Linux 2.6.26.3 armv5teb

That is contradictory.  What we're asking is "is this a regression?  If
so, when did we break it?" I don't think the atheros driver is old
enough to have regressed.


> Distribution:OpenWrt Kamikaze 7.09, madwifi
> Hardware Environment: GW2348-4 board with ARM (IXP425 processor) + Ubiquiti SR5
> radios at miniPCI slots
> Software Environment:Socket programming with Iperf
> Problem Description:
> Message, "sending: : No buffer space available", is shown when bulk IP traffic
> is transmitted or received, using raw socket transmission program
> 
> Also, some kernel network module crash message is displayed. Please find the
> attached crash message encountered
> 
> Steps to reproduce:
> 1. start the User level socket program for routing custom IP packets, (by using
> raw transmission and reception socket) in "ath0" interface.
> 2. Now start the testing using Iperf for testing routing of the user program
> 
> 
> --
> Also refer to the attachment
> 

: in mcmp_snmp_smtx function 
: 
:  SNMP Packets sending..........
:  SNMP Packets sending. over.........NETDEV WATCHDOG: wifi1: transmit timed out
: ------------[ cut here ]------------
: WARNING: at net/sched/sch_generic.c:223 ()
: Modules linked in: prism54 orinoco_plx orinoco_pci ipw2200 ipw2100 orinoco hermes ath_pci wlan_xauth wlan_wep wlan_tkip wlan_ccmp wlan_acl ath_rate_minstrel ath_hal(P) wlan_scan_ap wlan nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_TTL xt_MARK ipt_ECN xt_CLASSIFY ipt_ttl xt_time ipt_time xt_tcpmss xt_statistic xt_mark xt_mac xt_length ipt_ecn xt_DSCP xt_dscp ipt_LOG xt_CHAOS xt_DELUDE xt_TARPIT xt_quota xt_portscan xt_pkttype xt_physdev iptable_raw ip6t_REJECT ip6t_mh ip6t_ah ip6table_raw ip6_queue ip6table_filter ip6_tables nf_conntrack_ipv6 ppp_async ppp_generic slhc crc_ccitt ath9k usbcore mac80211 cfg80211 ipv6 ieee80211_crypt_ccmp ieee80211_crypt_tkip ieee80211_crypt_wep ieee80211 ieee80211_crypt michael_mic arc4 aes_generic deflate ecb cbc crypto_blkcipher crypto_hash cryptomgr crypto_algapi [last unloaded: wlan_scan_sta]
: Function entered at [<c0025890>] from [<c0032128>]
: Function entered at [<c00320e4>] from [<c0152c00>]
:  r6:c0221aa0 r5:c3090000 r4:c022c45c
: Function entered at [<c0152b54>] from [<c003b13c>]
:  r5:c0152b54 r4:00000100
: Function entered at [<c003aff4>] from [<c0036ff4>]
:  r8:0001cea8 r7:c0206058 r6:0000000a r5:c02218ac r4:00000001
: Function entered at [<c0036f98>] from [<c0037380>]
:  r6:00000000 r5:c020fc8c r4:00000005
: Function entered at [<c003733c>] from [<c0021048>]
: Function entered at [<c0021000>] from [<c0021664>]
: Exception stack(0xc0203f64 to 0xc0203fac)
: 3f60:          c3d48000 c3c1a8a0 a0000013 60000013 c0022ae4 c0202000 c001eef8 
: 3f80: c0206058 0001cea8 690541c2 0001cd3c c0203fc0 c0203fac c0203fac c00229a8 
: 3fa0: c00229a8 60000013 ffffffff                                              
:  r6:00000020 r5:0000001f r4:ffffffff
: Function entered at [<c0022970>] from [<c01bb3a4>]
:  r5:c021c230 r4:c0224310
: Function entered at [<c01bb350>] from [<c0008b80>]
: Function entered at [<c00088fc>] from [<00008034>]
: ---[ end trace 9e368de2b60a35e4 ]---
: 

I suspect that testing 2.6.27-rc5 would be useful - quite a few fixes
are flowing into that driver.

Thanks.


