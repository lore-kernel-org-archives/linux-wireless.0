Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:50683 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758856AbXGaNfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 09:35:45 -0400
Message-ID: <46AF3AAE.4010908@warmcat.com>
Date: Tue, 31 Jul 2007 14:35:42 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
References: <20070731115446.5717.37617.stgit@localhost> <200707311427.58948.IvDoorn@gmail.com> <46AF2D5C.6090803@warmcat.com> <200707311458.40936.IvDoorn@gmail.com>
In-Reply-To: <200707311458.40936.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

>> Are there known problems with the monitor mode?  It seems incomplete
>> even with one virtual interface, eg
> 
> Sounds awfully familiar. :(

Don't feel bad, monitor mode is not in a coherent state all over the
drivers at the moment.  I would really like to see it become trustable
in all cases.

> At which rate should the other box be sending the frames?

54Mbps, I am a couple of metres from the AP.

>> # while [ 1 ] ; do ls -l / ; done
>>
>> over an ssh link which is being carried on another wireless device on
>> the same box associated on to channel 6...
> 
> Could you enable debugfs and do inside the "rt73usb" folder within the
> mac80211 debugfs entry do:
> 
> echo 16 > csr_offset
> cat csr_value
> 
> This will read the TXRX_CSR0 register of rt73usb which controls the filtering
> of the frames. That will help determining if the missing frames have been
> droppen in the hardware or not.

I have to add debugfs in my .config for that, it is rebuilding.

However, I added the following debug line inside the loop at
rt2x00_dev.c function
void rt2x00lib_rxdone(struct data_entry *entry, char *data,
	const int size, const int signal, const int rssi, const int ofdm)

		printk("signal=%d, ofdm=%d, rate->val=%d, val=%d\n", signal, ofdm,
rate->val, val);

and ran tcpdump at the same time.  What I see is that even though
tcpdump on ch 6 is only willing to show 1Mbps packets, packets with
other rates passed through here, eg,

signal=20, ofdm=0, rate->val=4106, val=10
signal=20, ofdm=0, rate->val=16789524, val=20
signal=110, ofdm=0, rate->val=4106, val=10
signal=110, ofdm=0, rate->val=16789524, val=20
signal=110, ofdm=0, rate->val=33583159, val=55
signal=110, ofdm=0, rate->val=50393198, val=110

but ALWAYS ofdm is 0, ie, it only sees CCK packets.

If I look over on channel 11, my neighbour has an 80211b device
apparently, I see data packets at 11Mbps, again CCK.

-Andy
