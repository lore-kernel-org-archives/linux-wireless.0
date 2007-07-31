Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:43818 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759684AbXGaOHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 10:07:34 -0400
Received: by fk-out-0910.google.com with SMTP id z23so415716fkz
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 07:07:32 -0700 (PDT)
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
Date: Tue, 31 Jul 2007 16:11:26 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <20070731115446.5717.37617.stgit@localhost> <200707311458.40936.IvDoorn@gmail.com> <46AF3AAE.4010908@warmcat.com>
In-Reply-To: <46AF3AAE.4010908@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707311611.26683.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > At which rate should the other box be sending the frames?
> 
> 54Mbps, I am a couple of metres from the AP.

Ok. That means we can at least assume several frames should
be send with higher rates then 1 Mbs. ;)

> >> # while [ 1 ] ; do ls -l / ; done
> >>
> >> over an ssh link which is being carried on another wireless device on
> >> the same box associated on to channel 6...
> > 
> > Could you enable debugfs and do inside the "rt73usb" folder within the
> > mac80211 debugfs entry do:
> > 
> > echo 16 > csr_offset
> > cat csr_value
> > 
> > This will read the TXRX_CSR0 register of rt73usb which controls the filtering
> > of the frames. That will help determining if the missing frames have been
> > droppen in the hardware or not.
> 
> I have to add debugfs in my .config for that, it is rebuilding.

Thanks.

> However, I added the following debug line inside the loop at
> rt2x00_dev.c function
> void rt2x00lib_rxdone(struct data_entry *entry, char *data,
> 	const int size, const int signal, const int rssi, const int ofdm)
> 
> 		printk("signal=%d, ofdm=%d, rate->val=%d, val=%d\n", signal, ofdm,
> rate->val, val);
> 
> and ran tcpdump at the same time.  What I see is that even though
> tcpdump on ch 6 is only willing to show 1Mbps packets, packets with
> other rates passed through here, eg,
> 
> signal=20, ofdm=0, rate->val=4106, val=10
> signal=20, ofdm=0, rate->val=16789524, val=20
> signal=110, ofdm=0, rate->val=4106, val=10
> signal=110, ofdm=0, rate->val=16789524, val=20
> signal=110, ofdm=0, rate->val=33583159, val=55
> signal=110, ofdm=0, rate->val=50393198, val=110
> 
> but ALWAYS ofdm is 0, ie, it only sees CCK packets.
> 
> If I look over on channel 11, my neighbour has an 80211b device
> apparently, I see data packets at 11Mbps, again CCK.

I think I have an idea why mac80211 always reports 1 MBs,
rt2x00 checks if PREAMBLE was enabled or not. If that is the case it sets
the rate value to rate->val2
Mac80211 in turn only compares the value against rate->val which
means that it won't find the rate and assume the lowest possible rate.
I'll fix this by always setting the rate->val value instead (It isn't really
important for mac80211 to know if the preamble bit was set anyway).

> after the echo, catting that spews
> 
> 0x007eb162
> 
> repeatedly to the console.

And here is a big problem..
This register is defined as:

#define TXRX_CSR0_DROP_CRC				FIELD32(0x00020000)
#define TXRX_CSR0_DROP_PHYSICAL			FIELD32(0x00040000)
#define TXRX_CSR0_DROP_CONTROL			FIELD32(0x00080000)
#define TXRX_CSR0_DROP_NOT_TO_ME		FIELD32(0x00100000)
#define TXRX_CSR0_DROP_TO_DS				FIELD32(0x00200000)
#define TXRX_CSR0_DROP_VERSION_ERROR	FIELD32(0x00400000)
#define TXRX_CSR0_DROP_MULTICAST			FIELD32(0x00800000)
#define TXRX_CSR0_DROP_BORADCAST		FIELD32(0x01000000)
#define TXRX_CSR0_DROP_ACK_CTS			FIELD32(0x02000000)

Which means it will only pass multicast, broadcast and ACK_CTS frames. :S
Always dropping CRC errors is correct, since enabling that will greatly upset
any monitoring tool listening to the interface.

To see if it helps try:

echo 16 > csr_offset
echo 0x0002b162 > csr_value

This will disable all DROP bits (except for the CRC error) and thus should
trigger more frames to be received by your interface. In the mean time I'll search
why those bits weren't cleared when enabling the interface in monitor mode.

Which version are you using?
wireless-dev
rt2x00.git
rt2x00 cvs

Ivo
