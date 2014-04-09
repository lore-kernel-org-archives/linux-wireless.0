Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60049 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481AbaDIVqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 17:46:47 -0400
Message-ID: <5345BFA8.7040500@candelatech.com> (sfid-20140409_234651_410548_886F11B2)
Date: Wed, 09 Apr 2014 14:46:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [RFTv2 0/5] ath10k: ath10k: fix flushing and tx stalls
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com> <1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's another log snippet with these 5 patches (and lots more
mostly non ath10k patches of my own) applied:

No (significant) user traffic was running.

sta215: authenticated at: 1397076587.913186
sta215: associate with 04:f0:21:03:38:99 (try 1/3), at: 1397076587.915143
ath10k: mac flushing peer 04:f0:21:03:38:99 on vdev 16 mgmt tid for unicast mgmt (204 msecs)
sta215: RX AssocResp from 04:f0:21:03:38:99 (capab=0x1 status=0 aid=17) at: 1397076588.120218
ath10k: mac vdev 16 dtim_period 2
ath10k: mac vdev 16 slot_time 2
ath10k: mac ht peer 04:f0:21:03:38:99 mcs cnt 24 nss 3
ath10k: mac vht peer 04:f0:21:03:38:99 max_mpdu 65535 flags 0x6003001
ath10k: mac peer 04:f0:21:03:38:99 phymode 11ac-vht80
ath10k: mac vdev 16 up (associated) bssid 04:f0:21:03:38:99 aid 17
sta215: associated at: 1397076588.122484
IPv6: ADDRCONF(NETDEV_CHANGE): sta215: link becomes ready
sta216: authenticate with 04:f0:21:03:38:99 at: 1397076588.124830
ath10k: mac vdev 17 beacon_interval 100
ath10k: mac vdev 17 create peer 04:f0:21:03:38:99
ath10k: mac vdev 17 start 04:f0:21:03:38:99
ath10k: mac vdev 17 start center_freq 5180 phymode 11ac-vht80
sta216: send auth to 04:f0:21:03:38:99 (try 1/3) at: 1397076588.125811
ath10k: mac flushing peer 04:f0:21:03:38:99 on vdev 17 mgmt tid for unicast mgmt (204 msecs)
sta216: send auth to 04:f0:21:03:38:99 (try 2/3) at: 1397076588.431144
ath10k: failed to transmit management frame via WMI: -11
sta216: send auth to 04:f0:21:03:38:99 (try 3/3) at: 1397076591.431376
ath10k: failed to wait for tx to flush: -110, forcing
ath10k: failed to request peer 04:f0:21:03:38:99 on vdev 17 to flush ffffffff: -11
ath10k: failed to flush all peer tids: -11
sta216: deauthenticating from 04:f0:21:03:38:99 by local choice (reason=3)
ath10k: failed to wait for tx to flush: -110, forcing
ath10k: failed to request peer 04:f0:21:03:38:99 on vdev 17 to flush ffffffff: -11
ath10k: failed to flush all peer tids: -11
ath10k: mac vdev 17 peer delete 04:f0:21:03:38:99 (sta gone)
ath10k: failed to request wmi peer 04:f0:21:03:38:99 on vdev 17 removal: -11
ath10k: removing peer 04:f0:21:03:38:99 on vdev 17 still being mapped in firmware
ath10k: mac vdev 17 stop (disassociated
ath10k: failed to stop WMI vdev 17: -11
ath10k: mac vdev 17 down
ath10k: failed to wait for tx to flush: -110, forcing
ath10k: failed to request peer 04:f0:21:03:38:99 on vdev 16 to flush ffffffff: -11
ath10k: failed to flush all peer tids: -11
ath10k: failed to wait for tx to flush: -110, forcing
ath10k: failed to request peer 04:f0:21:03:38:99 on vdev 16 to flush ffffffff: -11
ath10k: failed to flush all peer tids: -11
sta218: authenticate with 04:f0:21:03:38:99 at: 1397076616.431328
ath10k: failed to wait for tx to flush: -110, forcing
ath10k: failed to request peer 04:f0:21:03:38:99 on vdev 16 to flush ffffffff: -11
ath10k: failed to flush all peer tids: -11
ath10k: mac vdev 19 beacon_interval 100
ath10k: failed to set beacon interval for vdev 19: -11
ath10k: mac vdev 19 create peer 04:f0:21:03:38:99
ath10k: failed to create wmi peer 04:f0:21:03:38:99 on vdev 19: -11
ath10k: failed to add peer 04:f0:21:03:38:99 for vdev 19 when changing bssid: -11
ath10k: mac vdev 19 start 04:f0:21:03:38:99
ath10k: mac vdev 19 start center_freq 5180 phymode 11ac-vht80


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

