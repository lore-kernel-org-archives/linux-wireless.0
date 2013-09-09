Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38505 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3IISwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 14:52:25 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r89IqLPn008607
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 9 Sep 2013 11:52:22 -0700
Message-ID: <522E18E5.1020503@candelatech.com> (sfid-20130909_205235_097361_9D32CFA2)
Date: Mon, 09 Sep 2013 11:52:21 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Specifying priority for management frames?
References: <5228CAB6.5060308@candelatech.com>
In-Reply-To: <5228CAB6.5060308@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2013 11:17 AM, Ben Greear wrote:
> While debugging a problem with group-rekeys, we noticed that the sniffer (on external machine)
> reported management packets are sent in the best-effort QoS queue.
>
> It seems to me that these should be in the VO queue instead, or at least
> we should be able to specify the queue in supplicant when sending the frames?

This is a problem in supplicant/hostapd.  They were not setting the socket
priority to (256 + 7) as they should have been doing.  With that fix, packets
on the air show the proper 'VO' QoS queue.

I posted patches to fix supplicant/hostapd to the hostapd mailing list.
Hopefully they are proper patches...at least they seem to work for me.

At least the hostapd side of this seemed to slip in with the addition
of the new non-monitor eapol tx status feature.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

