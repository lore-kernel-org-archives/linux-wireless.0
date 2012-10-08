Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ferdi.naasa.net ([87.106.227.76]:49824 "EHLO ferdi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab2JHR7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 13:59:40 -0400
Message-ID: <50731228.6040507@naasa.net> (sfid-20121008_195943_554078_DC41A29E)
Date: Mon, 08 Oct 2012 19:49:28 +0200
From: Joerg Platte <jplatte@naasa.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rt61pci and group re-keying
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,

I'm using an Intel based computer with a network card supported by the 
rt61pci driver. This computer has a quite strange problem, sometimes it 
cannot be connected from other computers in the same network, sometimes 
it can. Today I have spent some time to debug this and it looks like the 
problem is caused by the group rekeying (rt61pci_config_shared_key). I'm 
using WPA2 with TKIP group key.

Here the problem. After first association everything works and it still 
works after the first re-keying. After the second one the computer no 
longer responds to pings (arp "who has" request gets no answer). Then, 
after the next re-keying it works again (and so on). So basically only 
the first, third, fifth and so on re-keing works. After adding some 
debug information to the driver I think that the driver is doing the 
right thing. In total two keys are marked as active and before the third 
re-keying the oldest one is deleted via DISABLE_KEY.

I solved the problem by setting only the new key as valid by changing
         if (crypto->cmd == SET_KEY)
                 reg |= mask;

to

         if (crypto->cmd == SET_KEY)
                 reg = mask;


However, the hardware seems to be able to support up to four keys. Do 
you have any idea why the card behaves wrongly? Kernel is 2.6.36.2, but 
according to git there are no important changes on recent kernels for 
this driver.

Best regards,
Joerg
