Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:48565 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbYHSIqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 04:46:55 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by toronto053.server4you.de (Postfix) with ESMTP id D467652FE0E
	for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2008 10:57:37 +0200 (CEST)
Received: from toronto053.server4you.de ([127.0.0.1])
	by localhost (toronto053.server4you.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S9r4Ugjviv5V for <linux-wireless@vger.kernel.org>;
	Tue, 19 Aug 2008 10:57:37 +0200 (CEST)
Received: from [129.132.248.95] (notlob-hch.ee.ethz.ch [129.132.248.95])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by toronto053.server4you.de (Postfix) with ESMTP id A5BD152C132
	for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2008 10:57:37 +0200 (CEST)
Message-ID: <48AA887D.5090307@monom.org> (sfid-20080819_104659_898057_E05A0AB9)
Date: Tue, 19 Aug 2008 10:46:53 +0200
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: QoS and DSCP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was playing a bit with DSCP and my wireless setup. I don't know what 
the expected result should be there I'd like to ask you here what
is the expected result.

Server <---(ethernet)--> d-link AP <---(wireless)---> Desktop
192.168.100.1                                         192.168.202.198

On the server I have an icecast stream running on port 8000.

server# iptables -t mangle -A OUTPUT -p tcp --sport 8000 -j DSCP --set-dscp-class EF

The packets send from the AP to the desktop have the QoS Control Field Priority set
to 5:

Frame 13 (1622 bytes on wire, 1622 bytes captured)
PPI version 0, 84 bytes
IEEE 802.11 QoS Data, Flags: ......F.C
    Type/Subtype: QoS Data (0x28)
    Frame Control: 0x0288 (Normal)
    Duration: 48
    Destination address: IntelCor_9e:db:5d (00:1d:e0:9e:db:5d)
    BSS Id: D-Link_f0:b1:3c (00:1b:11:f0:b1:3c)
    Source address: D-Link_f0:b1:3c (00:1b:11:f0:b1:3c)
    Fragment number: 0
    Sequence number: 83
    Frame check sequence: 0xa06a35af [correct]
    QoS Control
        Priority: 5 (Video) (Video)
        ...0 .... = EOSP: Service period
        Ack Policy: Normal Ack (0x00)
        Payload Type: MSDU
        QAP PS Buffer State: 0x0
Logical-Link Control
Internet Protocol, Src: 192.168.100.1 (192.168.100.1), Dst: 192.168.202.198 
(192.168.202.198)
Transmission Control Protocol, Src Port: irdmi (8000), Dst Port: 32983 (32983), Seq: 
1449, Ack: 1, Len: 1448
Data (1448 bytes)

Now I'd like to prioritize frames from the desktop to the server as well.

After playing around with iptables & tc for a long time, I started to look 
into the code and a way I found to get my desktop to set the QoS 
Priority field is to use following iptables command:

desktop# iptables -t mangle -A POSTROUTING -p tcp --dport 8000 -j CLASSIFY --set-class 0:103

PPI version 0, 32 bytes
IEEE 802.11 QoS Data, Flags: .......TC
    Type/Subtype: QoS Data (0x28)
    Frame Control: 0x0188 (Normal)
    Duration: 44
    BSS Id: D-Link_f0:b1:3c (00:1b:11:f0:b1:3c)
    Source address: IntelCor_9e:db:5d (00:1d:e0:9e:db:5d)
    Destination address: D-Link_f0:b1:3c (00:1b:11:f0:b1:3c)
    Fragment number: 0
    Sequence number: 124
    Frame check sequence: 0xd60fe864 [correct]
    QoS Control
        Priority: 3 (Excellent Effort) (Video)
        Ack Policy: Normal Ack (0x00)
        Payload Type: MSDU
        Transmit Opportunity (TXOP) Limit Requested: 0x00
Logical-Link Control
Internet Protocol, Src: 192.168.202.198 (192.168.202.198), Dst: 192.168.100.1 (192.168.100.1)
Transmission Control Protocol, Src Port: 32983 (32983), Dst Port: irdmi (8000), Seq: 1, Ack: 1449, Len: 0

The argument '--set-class 0:103' is of course not really intuitive though after reading the code
it is clear why: they are magic! :)

wme.c: classify_1d

	/* skb->priority values from 256->263 are magic values to
	 * directly indicate a specific 802.1d priority.  This is used
	 * to allow 802.1d priority to be passed directly in from VLAN
	 * tags, etc.
	 */
	if (skb->priority >= 256 && skb->priority <= 263)
		return skb->priority - 256;


Trying the same trick as on the server with DSCP I had no success:

desktop# iptables -t mangle -A OUTPUT -p tcp --dport 8000 -j DSCP --set-dscp-class EF

No frame from the desktop has the QoS Priority field set. There is some code
in classify_1d which does something with DSCP but I haven't figured it out
how it is suppose to work.

So my question is, is my approach with iptables and DSCP supposed to work?

thanks,
daniel

