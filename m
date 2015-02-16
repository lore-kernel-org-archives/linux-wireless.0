Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:59466 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbbBPQ5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 11:57:34 -0500
Received: by mail-ob0-f169.google.com with SMTP id wp4so44136822obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2015 08:57:34 -0800 (PST)
Message-ID: <54E22177.6050105@lwfinger.net> (sfid-20150216_175738_295295_C72C2005)
Date: Mon, 16 Feb 2015 10:57:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alan Fisher <acf@unixcube.org>, linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: rtlwifi drops most IPv6 packets
References: <54E19DD6.9050704@unixcube.org>
In-Reply-To: <54E19DD6.9050704@unixcube.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/16/2015 01:35 AM, Alan Fisher wrote:
> Hello!
>
> I have a machine with a Realtek RTL8188 wireless card. This card is handled by
> the rtl8192 driver. The driver in kernel 3.16.0-4 causes most sent ARP packets
> to be dropped. ARP packets appear to get through with the driver in kernel 3.19,
> but IPv6 packets suffer instead. I have reproduced this when connected to
> multiple access points.
>
> I think I have traced this issue to some code in the rtlwifi driver that does
> special handling on "special" packets. The function rtl_is_special_data() in
> base.c determines whether a packet is considered special. In the 3.16 kernel,
> this includes ARP packets, wireless encryption packets, and DHCP/BOOTP packets.
> IPv6 appears to have been added to this list as of kernel 3.19.
>
> It seems the idea is that certain important packets should be transmitted at the
> lowest possible 802.11 rate. The rtl_is_special_data() function is used to
> determine which packets to handle this way. Not treating any packets as special,
> by adding a "return false;" at the beginning of rtl_is_special_data(), seems to
> fix the problems with lost packets with both kernels.
>
> I would guess that some good reason exists for this special handling, but I
> can't determine what it is. I couldn't find anything similar in iwlwifi. Either
> way, it seems like a bug to send all IPv6 traffic at the lowest possible rate,
> successful or not.

When you specify a card number, please include the letters after the numbers. 
You say you have an RTL8188, but there are RTL8188EE, RTL8188CU, and RTL8188CE 
devices. There are drivers rtl8192cu, and rtl8192ce, as well as rtl8192de, 
rtl8192ee, and rtl8192se. I am guessing that you have an RTL8188CE, which uses 
rtl8192ce. If this is wrong, please let me know.

The purpose of rtl_is_special_data() is to ensure that management packets have 
the highest probability of being successfully transmitted by sending them at a 
low rate. This routine should never cause any packets to be dropped, only force 
them to be transmitted slowly. Obviously, there is a problem with the current 
implementation, and I will need to consult with the Realtek engineers. It also 
occurs to me that mac80211 probably handles this function, and that it may be 
possible to remove this routine, which is essentially what your workaround does.


Larry

