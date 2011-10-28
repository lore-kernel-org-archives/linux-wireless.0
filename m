Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44579 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1J1FPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 01:15:06 -0400
Received: from [50.54.196.61] (50-54-196-61.evrt.wa.frontiernet.net [50.54.196.61])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p9S5F5CD028262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 22:15:06 -0700
Message-ID: <4EAA3A59.5080801@candelatech.com> (sfid-20111028_071511_642148_0F581C0A)
Date: Thu, 27 Oct 2011 22:15:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2011 10:11 PM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> This allows a user to configure a wifi station interface
> to disable 802.11n, even if the AP and NIC supports it.
>
> The additional netlink bits is to allow this patch to work on 3.0
> and should not be included in the final patch.

I have the wpa_supplicant patches for this series tested as well,
but I figured it best to make sure these kernel patches are acceptable
before posting the hostap patches....

Tested this on ath9k.  According to the rate output seen by
iwconfig and the debug stuff in
cat /debug/ieee80211/wiphy0/netdev\:sta2/stations/00\:88\:99\:88\:99\:01/ht_capa
I think I have this working pretty well.

I have not yet tried verifying things with a sniffer...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
