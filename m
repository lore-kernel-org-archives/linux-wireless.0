Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42027 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab1EBUZG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 16:25:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QGzg0-0008Dq-B3
	for linux-wireless@vger.kernel.org; Mon, 02 May 2011 22:25:04 +0200
Received: from 128.4.35.58 ([128.4.35.58])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 22:25:04 +0200
Received: from jonghyun by 128.4.35.58 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 22:25:04 +0200
To: linux-wireless@vger.kernel.org
From: Jonghyun Kim <jonghyun@udel.edu>
Subject: Re: looking for more details on BCM4329, access to 802.11 header
Date: Mon, 2 May 2011 20:17:42 +0000 (UTC)
Message-ID: <loom.20110502T221352-549@post.gmane.org> (sfid-20110502_222510_207731_82F3F8DE)
References: <AANLkTikwBUjSXJf+EUeM+kPhMg3PG0Y22S4BYKVVm8S2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I can answer the question about the per-packet RSSI.

Each frame consists of 
 HW header, SW header, BDC header, MAC header, and MSDU,
where HW is hareware and SW is software.

BDC header includes rssi as a member.
MAC header consists of DA, SA, and proto, 
where DA is the destination address and SA is the source address.

When proto is IP (0x0800) or ARP (0x0806), 
rssi in BDC header is greater than zero.
To obtain the correct value of rssi, 
you must subtract 256 (=0x100) from it.
For some other protocols, rssi in BDC header is zero,
meaning we cannot get
correct rssi for them.

The following kernel messages are the examples that I produced.
----------------
<2>[  477.763885] Jong: rssi=-54, SSID=Sender
<4>[  477.892425] Jong: HW  : 110 0 145 255
<4>[  477.893188] Jong: SW  : seq=185 chan=2 0 doff=14 0 
txmax=154 0 0 0 0
<4>[  477.893615] Jong: BDC : fl=16 pri=0 fl=0 rssi=202 --> -54 dBm
<4>[  477.894287] Jong: MAC : DA=ff ff ff ff ff ff 
SA=00 1f c6 d6 3 19 proto=0800 (IP)
<4>[  477.894744] Jong: MSDU: 45 0 0 4e 1d a5 0 0 80 11

<4>[  477.895782] Jong: HW  : 78 0 177 255
<4>[  477.896179] Jong: SW  : seq=186 chan=2 0 doff=14 0 
txmax=154 0 0 0 0
<4>[  477.896606] Jong: BDC : fl=16 pri=0 fl=0 rssi=202 --> -54 dBm
<4>[  477.897277] Jong: MAC : DA=ff ff ff ff ff ff 
SA=00 04 96 1d 80 a0 proto=0806 (ARP)
<4>[  477.897705] Jong: MSDU: 0 1 8 0 6 4 0 1 0 4
----------------

The code to produce the above kernel messages is as follows.
In dhdsdio_readframes() function,
add
        struct sk_buff *TmpPkt;
        uchar *HW_header_p;
and right before the comment
	/* Fill in packet len and prio, deliver upward */
add
	TmpPkt = (struct sk_buff *)pkt;
	HW_header_p = (uchar *)TmpPkt->data;	
and right before the comment
	/* Unlock during rx call */
add

{
    uchar *A = HW_header_p;  
    
    printk("Jong: HW   : %d %d %d %d\n", A[0], A[1], A[2], A[3]);
    printk("Jong: SW   : seq=%d chan=%d %d doff=%d %d 
           txmax=%d %d %d %d %d\n", 
A[4], A[5], A[6], A[7], A[8], A[9], A[10], A[11], A[12], A[13]);
    printk("Jong: BDC  : fl=%d pri=%d fl=%d rssi=%d\n", 
A[14], A[15], A[16], A[17]);
    printk("Jong: MAC  : DA=%02x %02x %02x %02x %02x %02x 
SA=%02x %02x %02x %02x %02x %02x proto=%02x%02x\n", 
              A[18], A[19], A[20], A[21], A[22], A[23],
              A[24], A[25], A[26], A[27], A[28], A[29],
A[30], A[31]);
printk("Jong: MSDU : %02x %02x %02x %02x %02x %02x %02x
 %02x %02x %02x\n",
A[32], A[33], A[34], A[35], A[36], A[37], A[38],
A[39], A[40], A[41]);
}



I have been tried to modify driver codes to get a monitor mode.
But it did not work since I guess that the firmware does not
support it. What I tried is follows.

In wl_iw_set_mode() function,
I addded
        int monitor = htod32(1);
	error = dev_wlc_ioctl(dev, WLC_SET_MONITOR,
         &monitor, sizeof(monitor));

The result of error is -95 that means EOPNOTSUPP 
(error operation not supported).

I hope that the developers of the firmware for bcm4329
release a new firmware providing monitor mode.





