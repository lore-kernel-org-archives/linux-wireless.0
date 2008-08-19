Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:59702 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYHSLXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 07:23:30 -0400
Message-ID: <48AAAD30.2080207@monom.org> (sfid-20080819_132334_329388_B4FA862B)
Date: Tue, 19 Aug 2008 13:23:28 +0200
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: QoS and DSCP
References: <48AA887D.5090307@monom.org> <ee101a74bd16a9467853b5ac049c5da4.squirrel@secure.sipsolutions.net> <48AA8E2C.4060303@monom.org>
In-Reply-To: <48AA8E2C.4060303@monom.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Ok. I'll try to poke a bit around in this area. Maybe I find something 
> useful.

If I use --set-dscp with 0x18 (precedence level 3) instead of my orignial
--set-dscp-class EF (expedited forwarding) then I see the QoS Priority field
set to 3 (as with the CLASSIFY trick).

desktop# iptables -t mangle -A OUTPUT -p tcp --dport 8000 -j DSCP --set-dscp-class EF
-> no effect

desktop# iptables -t mangle -A OUTPUT -p tcp --dport 8000 -j DSCP --set-dscp 0x18
-> 
Frame 19 (174 bytes on wire, 174 bytes captured)
PPI version 0, 84 bytes
IEEE 802.11 QoS Data, Flags: .......TC
    Type/Subtype: QoS Data (0x28)
    Frame Control: 0x0188 (Normal)
    Duration: 44
    BSS Id: D-Link_f0:b1:3c (00:1b:11:f0:b1:3c)
    Source address: IntelCor_9e:db:5d (00:1d:e0:9e:db:5d)
    Destination address: D-Link_f0:b1:3c (00:1b:11:f0:b1:3c)
    Fragment number: 0
    Sequence number: 1224
    Frame check sequence: 0x321df371 [correct]
    QoS Control
        Priority: 3 (Excellent Effort) (Video)
        Ack Policy: Normal Ack (0x00)
        Payload Type: MSDU
        Transmit Opportunity (TXOP) Limit Requested: 0x00
Logical-Link Control
Internet Protocol, Src: 192.168.202.198 (192.168.202.198), Dst: 192.168.100.1 (192.168.100.1)
Transmission Control Protocol, Src Port: 46310 (46310), Dst Port: irdmi (8000), Seq: 1, Ack: 1449, Len: 0

Together with some printks I see that the code in wme.c classify_1d does
exactly the thing which it should. It returns the dscp value correctly.
Using --set-dscp 0x18 classify_1d returns 3 and with --set-dscp-class EF, 
classify_1d returns 5. That means there is a problem with mapping the result
of classify_1d to the correct QoS priority, right?

daniel

