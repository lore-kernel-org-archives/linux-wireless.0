Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:53852 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbXK3HS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 02:18:28 -0500
Received: from localhost (localhost [127.0.0.1])
	by hiems2.ing.unibs.it (Postfix) with ESMTP id 785DC182672A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2007 08:18:26 +0100 (CET)
Received: from hiems2.ing.unibs.it ([127.0.0.1])
	by localhost (hiems1.ing.unibs.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7ky94W8Q0oJk for <linux-wireless@vger.kernel.org>;
	Fri, 30 Nov 2007 08:18:26 +0100 (CET)
Mime-Version: 1.0 (Apple Message framework v752.3)
In-Reply-To: <43e72e890711291338j3fb7876fp49b7489764fe2d1a@mail.gmail.com>
References: <0D869D0B-A5CF-4AE4-B986-DB168917296B@ing.unibs.it> <43e72e890711291338j3fb7876fp49b7489764fe2d1a@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4FE7E8BF-13D5-450C-A629-60689066B2DD@ing.unibs.it> (sfid-20071130_071832_026019_22E829C9)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: ath5k: filter patch
Date: Fri, 30 Nov 2007 08:18:31 +0100
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

yes, the problem was there also with iface configured in monitor mode  
to capture its own traffic and set to promisc to catch also ucast  
traffic to other STAs (and their related control traffic). That  
happened because rx filters were never set up (or changed) during  
ioctls due to

ifconfig wlan0 promisc

or

iwconfig wlan0 mode monitor

Only mcast filters were set up by ath5k_configure_filters. Probably  
sometime in the past the line to set up rx_filters in this function  
disappeared from the code, I debugged all the base.c and hw.c to see  
if there were other parts in the code to set up rx filters during  
ioctls but there are not.

I repeat, this depends on the fact the there are no lines of code  
supposed to change rx_filters during ioctls.

By the way, again, has someone noticed that ath5k driver is not  
properly setting up rts procedure when asked?

Best regards,
FG

On Nov 29, 2007, at 22:38, Luis R. Rodriguez wrote:

> On Nov 29, 2007 10:53 AM, Francesco Gringoli
> <francesco.gringoli@ing.unibs.it> wrote:
>> Hello everybody,
>>
>> I discovered that playing with iface promiscuity to capture traffic
>> (including control, promisc and all other stuff) is not working on
>> ath5k as rx_filters are never refreshed. To make things going I added
>> a single ath5k_hw_set_rx_filters(ah,rfilt) at the end of
>> ath5k_configure_filter(). I attach the simple patch. Now tcpdump
>> captures everything in monitor mode when iface is set to promisc.
>
> Are you using monitor or promisc? Promiscous is just supposed to sniff
> what you would sniff as if you were on Ethernet -- stuff destined to
> your BSSID if STA. Monitor is 'catch it all'. Under this definition,
> is it still "misbehaving"? For now you can get a real "monitor"
> interface by using iw:
>
> http://git.sipsolutions.net/iw.git
>
> However this requires you to have libnl-1.0 pre8. The libnl URL is
> down, in fact Thomas's home dir is not even working right now.. hmm,
> CC'ing him. You can find pre8 here:
>
> git://git.kernel.org/pub/scm/libs/netlink/libnl.git
>
>   Luis

%%%%%%%%%%%%%%%%%%%%%

Francesco Gringoli, PhD - Assistant Professor
Dept. of Electrical Engineering for Automation
University of Brescia
via Branze, 38
25123 Brescia
ITALY

Ph:  ++39.030.3715843
FAX: ++39.030.380014
WWW: http://www.ing.unibs.it/~gringoli

%%%%%%%%%%%%%%%%%%%%%


