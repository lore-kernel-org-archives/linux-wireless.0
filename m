Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:62474 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYGERHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 13:07:35 -0400
Received: by fk-out-0910.google.com with SMTP id 18so995849fkq.5
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2008 10:07:33 -0700 (PDT)
Message-ID: <486FAA4D.2080601@gmail.com> (sfid-20080705_190750_083585_E6F90CDB)
Date: Sat, 05 Jul 2008 18:07:25 +0100
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: [Fwd: airo with WPA support merge]
References: <4807C194.4040108@free.fr> <486F46A7.4020105@free.fr>
In-Reply-To: <486F46A7.4020105@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

matthieu castet wrote:
>> [2]
>> http://svn.gna.org/viewcvs/airo-wpa/branches/kernel-merge/
>>
>> [3]
>> Dan Williams :
>> One problem I have is that after setting the TKIP key, I always get a
>> sequence of 3 bad MICs, and then the MAC sends a status of 0x8117 which
>> causes the driver to send a disconnection event to userspace, which
>> makes wpa_supplicant fail the connection.  If I comment out the 'goto
>> badrx;' in the interrupt handler where the WPA mic is checked,
>> everything works great and I can complete the 4-way handshake.  It needs
>> more investigation, but do you have any thoughts on what might be going
>> on here?

I had a quick look at [2].

The WPA support is similar to that posted for the orinoco driver last weekend. The driver calculates the MIC using the current software keys and appends it to the packet to be transmitted; the firmware/hardware encrypts the packet with the keys set in hardware.

For orinoco the TKIP changing code waits until the card has finished transmitting queued packets before changing the keys [4]. This prevents the software keys from getting out of step with the hardware keys. Orinoco makes use of a RID to determine if there's anything in the TX queue, but I don't think this is necessary.

Might a similar change work for the airo driver?

Regards,

Dave.

[4] <http://marc.info/?l=linux-wireless&m=121467838917394&w=4>
