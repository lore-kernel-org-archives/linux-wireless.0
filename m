Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43291 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1JUELe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 00:11:34 -0400
Message-ID: <4EA0F0F2.6020506@candelatech.com> (sfid-20111021_061141_822855_272DA3FB)
Date: Thu, 20 Oct 2011 21:11:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Question on channel 44 and HT40+
References: <4EA09874.3010006@candelatech.com>
In-Reply-To: <4EA09874.3010006@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/20/2011 02:53 PM, Ben Greear wrote:
>
> I configured hostapd for channel 44, and gave it option for HT40+
> That seems to work fine:
>
> [root@ct520-6157 ]# cat /debug/ieee80211/wiphy0/ath9k/wiphy
> wiphy0 (chan=44  center-freq: 5220 MHz  channel-type: 3 (ht40+))
> addr: 00:0e:8e:32:12:cf
> addrmask: ff:79:e8:45:74:31
> rfilt: 0x4497 UCAST MCAST BCAST BEACON PROBEREQ COMP_BAR PSPOLL
> [root@ct520-6157 ]#

Gah, user-error.  The client NIC had country-code of AM (Armenia..really??)
and I had forgotten to enable the over-ride.

Once I force the NIC's country-code to 0 then it will do HT-40+- just
fine.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
