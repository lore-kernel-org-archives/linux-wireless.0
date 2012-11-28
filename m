Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.legal.de ([46.38.240.131]:56144 "EHLO mail.legal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab2K1OWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 09:22:24 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.legal.de (Postfix) with ESMTP id 6AE8C6060F3B
	for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 14:15:19 +0000 (UTC)
Received: from mail.legal.de ([127.0.0.1])
	by localhost (mail.legal.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z5tf6R4+4DMf for <linux-wireless@vger.kernel.org>;
	Wed, 28 Nov 2012 14:15:13 +0000 (UTC)
Received: from [134.91.54.94] (unknown [134.91.54.94])
	by mail.legal.de (Postfix) with ESMTPSA id C21346060F36
	for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 14:15:13 +0000 (UTC)
Message-ID: <50B61C71.6060007@schwarze-allianz.de> (sfid-20121128_152227_935873_AFE02FFF)
Date: Wed, 28 Nov 2012 15:15:13 +0100
From: Jens Kapitza <j.kapitza@schwarze-allianz.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwlwifi hibernate / suspend issue
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,
i've a big problem with the iwlwifi driver.

the good think everythink works gerade as long as you do not suspend the 
laptop


the bad issue:
~$ rfkill list
0: hci0: Bluetooth
     Soft blocked: no
     Hard blocked: no
1: phy0: Wireless LAN
     Soft blocked: no
     Hard blocked: no


after suspend phy0: tells Hard blocked: yes

but there is no switch on the laptop.
(just a Fn-F2 key) softblocking the antenna [after reboot all works again]

any starting points?  i've looked at the main.c of iwlwifi there is an 
wakup call but
can someone tell me how the driver works?

which call is done after suspend and why can i unload the driver and 
reload it again
root@jens-S4216:/home/jens# modprobe -r iwlwifi
root@jens-S4216:/home/jens# modprobe  iwlwifi
and everythink works?

is it a firmware issue (is it possible to force a firmware reload after 
suspend)



i've wrote a sleep.d script in /etc/pm/...
that unloads the driver but it seems to has somethink todo with the 
internal (uefi/bios) on the card?
it seems to be in a wrong state after wakeup


hope my english is not a disaster and someone can give me a hint where 
to start or is there a patch working at this issue current kernel 3.7 
rc? [yesterday] have not solved the problem


Jens Kapitza
