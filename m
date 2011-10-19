Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:65343 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab1JSOkU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 10:40:20 -0400
Subject: Re: 3.1.0-rc9+ : wlan stops working w/o any error messages
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: David Rientjes <rientjes@google.com>, werner <w.landgraf@ru.ru>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <201110191301.03959.toralf.foerster@gmx.de>
References: <201110152119.58509.toralf.foerster@gmx.de>
	 <201110170952.43916.toralf.foerster@gmx.de>
	 <1318879847.17584.3.camel@wwguy-ubuntu>
	 <201110191301.03959.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 06:49:48 -0700
Message-ID: <1319032188.31823.66.camel@wwguy-huron> (sfid-20111019_164023_573060_1B58672B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-19 at 04:01 -0700, Toralf Förster wrote:
> wwguy wrote at 21:30:47
> > When the problem happen, could you please dump the tx_queue status in
> > debugfs and send us the information
> > 
> > In order to dump the the tx_queue, please do the following
> > 1. make sure you compile your kernel with CONFIG_IWLWIFI_DEBUGFS=y
> > 2. unload and reload the "iwlagn" module
> > 3. cd to /sys/kernel/debug/ieee80211/phyX/iwlwifi/debug (phX: "X" based
> > on your system)
> > 4. "$sudo cat tx_queue" to show the current tx queue status
> 
> There was an outage 15 min ago, however the network was automatically restarted, therefore not sure whether it is related to the initial reported problem 
> or not :
> 
> tfoerste@n22 ~/tmp $ sudo cat /sys/kernel/debug/ieee80211/phy0/iwlagn/debug/tx_queue 
> hwq 00: read=182 write=182 stop=0 swq_id=0x00 (ac 0/hwq 0)
>         stop-count: 0
> hwq 01: read=0 write=0 stop=0 swq_id=0x05 (ac 1/hwq 1)
>         stop-count: 0
> hwq 02: read=137 write=137 stop=0 swq_id=0x0a (ac 2/hwq 2)
>         stop-count: 0
> hwq 03: read=7 write=7 stop=0 swq_id=0x0f (ac 3/hwq 3)
>         stop-count: 0
> hwq 04: read=116 write=116 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 05: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 06: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 07: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 08: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 09: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 10: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 11: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 12: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 13: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 14: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 15: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 16: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 17: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 18: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 19: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)

hmm, all the queues looks ok, did you see the problem when you dump the
tx_queue?


> 
> /var/log/messages gave :
> 
> 2011-10-19T12:30:01.000+02:00 n22 cron[8068]: (root) CMD (/usr/lib/sa/sa2 -A >/dev/null)
> 2011-10-19T12:33:31.000+02:00 n22 dhcpcd[2755]: wlan0: carrier lost
> 2011-10-19T12:33:31.494+02:00 n22 kernel: cfg80211: Calling CRDA for country: DE
> 2011-10-19T12:33:31.000+02:00 n22 wpa_cli: interface wlan0 DISCONNECTED
> 2011-10-19T12:33:31.000+02:00 n22 wpa_cli: executing 'false /etc/init.d/net.wlan0 --quiet stop' failed
> 2011-10-19T12:33:33.000+02:00 n22 ntpd[2924]: Deleting interface #2 wlan0, 9.155.188.41#123, interface stats: received=103, sent=123, 
> dropped=0, active_time=2813 secs
> 2011-10-19T12:33:33.000+02:00 n22 ntpd[2924]: 213.154.229.24 interface 9.155.188.41 -> (none)
> 2011-10-19T12:33:33.000+02:00 n22 ntpd[2924]: 193.110.251.50 interface 9.155.188.41 -> (none)
> 2011-10-19T12:33:33.000+02:00 n22 ntpd[2924]: 95.140.150.140 interface 9.155.188.41 -> (none)
> 2011-10-19T12:33:33.000+02:00 n22 ntpd[2924]: 109.75.190.27 interface 9.155.188.41 -> (none)
> 2011-10-19T12:33:33.000+02:00 n22 ntpd[2924]: peers refreshed
> 2011-10-19T12:33:34.636+02:00 n22 kernel: wlan0: authenticate with 00:21:55:ac:8b:80 (try 1)
> 2011-10-19T12:33:34.637+02:00 n22 kernel: wlan0: authenticated
> 2011-10-19T12:33:34.639+02:00 n22 kernel: wlan0: waiting for beacon from 00:21:55:ac:8b:80
> 2011-10-19T12:33:34.685+02:00 n22 kernel: wlan0: beacon received
> 2011-10-19T12:33:34.689+02:00 n22 kernel: wlan0: associate with 00:21:55:ac:8b:80 (try 1)
> 2011-10-19T12:33:34.691+02:00 n22 kernel: wlan0: RX AssocResp from 00:21:55:ac:8b:80 (capab=0x431 status=0 aid=3)
> 2011-10-19T12:33:34.691+02:00 n22 kernel: wlan0: associated
> 2011-10-19T12:33:34.000+02:00 n22 dhcpcd[2755]: wlan0: carrier acquired
> 2011-10-19T12:33:34.000+02:00 n22 wpa_cli: interface wlan0 CONNECTED
> 2011-10-19T12:33:34.000+02:00 n22 wpa_cli: executing '/etc/init.d/net.wlan0 --quiet start' failed
> 2011-10-19T12:33:34.000+02:00 n22 dhcpcd[2755]: wlan0: rebinding lease of 9.155.188.41
> 2011-10-19T12:33:39.000+02:00 n22 dhcpcd[2755]: wlan0: acknowledged 9.155.188.41 from 9.64.163.10
> 2011-10-19T12:33:39.000+02:00 n22 dhcpcd[2755]: wlan0: checking for 9.155.188.41
> 2011-10-19T12:33:44.000+02:00 n22 dhcpcd[2755]: wlan0: leased 9.155.188.41 for 14400 seconds
> 2011-10-19T12:33:44.000+02:00 n22 dnsmasq[2334]: reading /etc/resolv.conf
> 2011-10-19T12:33:44.000+02:00 n22 dnsmasq[2334]: ignoring nameserver 127.0.0.1 - local interface
> 2011-10-19T12:33:46.000+02:00 n22 ntpd[2924]: Listen normally on 4 wlan0 9.155.188.41 UDP 123
> 2011-10-19T12:33:46.000+02:00 n22 ntpd[2924]: peers refreshed
> 2011-10-19T12:35:01.000+02:00 n22 cron[8662]: (root) CMD (/usr/lib/sa/sa1 60 5 >/dev/null)
> 2011-10-19T12:40:01.000+02:00 n22 cron[9141]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
> 2011-10-19T12:40:01.000+02:00 n22 cron[9142]: (root) CMD (/usr/lib/sa/sa1 60 5 >/dev/null)
> 2011-10-19T12:43:01.000+02:00 n22 dnsmasq[2334]: reading /etc/resolv.conf
> 2011-10-19T12:43:01.000+02:00 n22 dnsmasq[2334]: using nameserver 9.64.162.21#53
> 2011-10-19T12:43:01.000+02:00 n22 dnsmasq[2334]: using nameserver 9.64.163.21#53
> 2011-10-19T12:43:01.000+02:00 n22 dnsmasq[2334]: ignoring nameserver 127.0.0.1 - local interface
> 2011-10-19T12:45:01.000+02:00 n22 cron[9671]: (root) CMD (/usr/lib/sa/sa2 -A >/dev/null)
> 2011-10-19T12:45:01.000+02:00 n22 cron[9672]: (root) CMD (/usr/lib/sa/sa1 60 5 >/dev/null)
> 
> After rmmod and modprobe I restarted the network again, here's the output :
> 
> n22 ~ # cat /sys/kernel/debug/ieee80211/phy1/iwlagn/debug/tx_queue 
> hwq 00: read=2 write=2 stop=0 swq_id=0x00 (ac 0/hwq 0)
>         stop-count: 0
> hwq 01: read=0 write=0 stop=0 swq_id=0x05 (ac 1/hwq 1)
>         stop-count: 0
> hwq 02: read=6 write=6 stop=0 swq_id=0x0a (ac 2/hwq 2)
>         stop-count: 0
> hwq 03: read=0 write=0 stop=0 swq_id=0x0f (ac 3/hwq 3)
>         stop-count: 0
> hwq 04: read=76 write=76 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 05: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 06: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 07: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 08: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 09: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 10: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 11: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 12: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 13: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 14: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 15: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 16: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 17: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 18: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> hwq 19: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
> 
> 
also looks ok here

Thanks
Wey



