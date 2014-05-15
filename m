Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57453 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaEOTcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 15:32:01 -0400
Message-ID: <53751630.2030501@candelatech.com> (sfid-20140515_213206_157675_CA7B847F)
Date: Thu, 15 May 2014 12:32:00 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>
CC: johannes@sipsolutions.net, jouni@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211/mac80211: Add support for Proxy ARP
References: <1400180784-26008-1-git-send-email-kyeyoonp@qca.qualcomm.com>
In-Reply-To: <1400180784-26008-1-git-send-email-kyeyoonp@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2014 12:06 PM, Kyeyoon Park wrote:
> Proxy ARP allows the AP devices to keep track of the hardware address
> to IP address mapping of the STA devices within the BSS. When a request
> for such information is made (i.e. ARP request, Neighbor Solicitation),
> the AP will respond on behalf of the STA device within the BSS. Such
> requests could originate from a device within the BSS or also from the
> bridge. In the process of the AP replying to the request (i.e. ARP
> reply, Neighbor Advertisement), the AP will drop the original request
> frame. The relevant STA will not even know that such information was
> ever requested.
> 
> This feature is a requirement for Hotspot 2.0. This feature is defined
> in IEEE Std 802.11-2012, 10.23.13. This particular commit will
> eventually be split into two separate commits (cfg80211 and mac80211
> separately). This commit implements one part of the feature, dynamic
> IPv4 addresses and ARP. Additional commits will be made to support
> static IPv4 addresses and IPv6.
> 
> Signed-off-by: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>

> +#define STA_IPV4_HASH_SIZE 32
> +#define STA_IPV4_HASH(ipv4) (((u8 *)&ipv4)[3] & 0x1F)

This should be a better hash I think.  Use an existing hash
method or at least mix in the higher bits manually?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

