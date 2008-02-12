Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from root-server.richard-scherping.de ([217.160.107.144]:50192 "EHLO
	p15125984.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbYBLXG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 18:06:58 -0500
Message-ID: <47B2268D.7060205@scherping.de> (sfid-20080212_230704_097356_19E9468E)
Date: Wed, 13 Feb 2008 00:06:53 +0100
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
References: <47B1F422.4060501@scherping.de> <D936D925018D154694D8A362EEB0892003A461BF@orsmsx416.amr.corp.intel.com>
In-Reply-To: <D936D925018D154694D8A362EEB0892003A461BF@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chatre, Reinette schrieb:

> We have not done ad-hoc testing in the recent code. Any debugging you
> can do will be greatly appreciated (anything interesting in your logs?).
> Just to confirm the monitor mode is ok, can you confirm that your
> monitoring machine can see data between a host and AP? We have seen some
> problems with monitoring in iwlwifi so I would like to make sure.

The monitoring (as well as the counterpart for ad-hoc operation) was done with madwifi 0.9.3.3 on a different machine with kernel 2.6.22 - a setup that has proven to work for me already.

> Please load the driver with debugging (debug=0x43fff) and send us what
> you see during data transmission. It may be useful to open a bug at
> bughost.org at this point for us to keep track of the problem.

Looking at the debugging output helped a bit:

Feb 12 23:27:37 merom kernel: iwl4965: I iwl4965_mac_tx enter
Feb 12 23:27:37 merom kernel: iwl4965: I iwl4965_tx_skb Dropping - !iwl4965_is_associated
Feb 12 23:27:37 merom kernel: iwl4965: I iwl4965_mac_tx leave

I changed that output to be more verbose:

iwl4965: I iwl4965_tx_skb Dropping - !iwl4965_is_associated: iwl4965_is_associated(priv)=1; priv->assoc_id=0; priv->assoc_station_added=1

This is in line with the following output:

Feb 12 23:44:08 merom kernel: iwl4965: U iwl4965_bg_post_associate Associated as 0 to: 2a:20:22:f0:4f:f0

The full log is available at http://www.scherping.de/misc/iwl4965-2625rc1.txt
What I did is:

merom:/home/richard# uname -a
Linux merom 2.6.25-rc1 #1 SMP Mon Feb 11 08:18:47 CET 2008 x86_64 GNU/Linux
merom:/home/richard# modprobe iwl4965 debug=0x43fff
merom:/home/richard# iwconfig wlan0 mode ad-hoc
merom:/home/richard# ifconfig wlan0 10.0.0.1 up
merom:/home/richard# iwconfig wlan0 channel 1
merom:/home/richard# iwconfig wlan0 essid test
merom:/home/richard# iwconfig wlan0
wlan0     IEEE 802.11g  ESSID:"test"  
          Mode:Ad-Hoc  Frequency:2.412 GHz  Cell: 2A:20:22:F0:4F:F0   
          Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Encryption key:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

merom:/home/richard# ping 10.0.0.2
PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
>From 10.0.0.1 icmp_seq=1 Destination Host Unreachable
>From 10.0.0.1 icmp_seq=2 Destination Host Unreachable
>From 10.0.0.1 icmp_seq=3 Destination Host Unreachable
^C
--- 10.0.0.2 ping statistics ---
5 packets transmitted, 0 received, +3 errors, 100% packet loss, time 4016ms
, pipe 3
merom:/home/richard# 

The same thing worked with 2.6.24 - 10.0.0.2 is the other ad-hoc station (MadWifi-based).

Thanks for your help!

Richard
