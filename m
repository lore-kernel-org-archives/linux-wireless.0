Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42510 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062Ab1ALBCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 20:02:50 -0500
Message-ID: <4D2CFDB8.3010907@candelatech.com>
Date: Tue, 11 Jan 2011 17:02:48 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: NetDev <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: TCP connections stall when station re-associates.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We're seeing something funny while testing ath9k and ath5k with
multiple VIFs.  We are using send-to-self routing rules
and have a TCP connection going between two station interfaces
connected to the same AP.  Kernel is ~2.6.37 (wireless-testing from
a few days ago, plus some local patches).  We tried commercial
APs and ath9k/ath5k APs running 2.6.37 kernel and hostap with
similar results.

The problem is that when the stations loose association and
re-associate (and maybe other times as well), the TCP connections
often hang.  I see buffers in the sendq in netstat, and retransmits
on the wire, but it seems to make no progress.

Here's a pair of sockets with one side in the state:

tcp        0   7312 7.7.1.54:33513              7.7.1.56:33514              ESTABLISHED
tcp        0      0 7.7.1.56:33514              7.7.1.54:33513              ESTABLISHED

Here's a brief snippet from the interface with 7.7.1.56 on it:

  51.517954     7.7.1.56 -> 7.7.1.54     TCP 33514 > 33513 [PSH, ACK] Seq=64229 Ack=1 Win=63 Len=12 TSV=8209159 TSER=7621148
  51.521719     7.7.1.54 -> 7.7.1.56     TCP 33513 > 33514 [ACK] Seq=13 Ack=64241 Win=377 Len=0 TSV=8209162 TSER=8209159
  52.279788     7.7.1.54 -> 7.7.1.56     TCP [TCP Retransmission] 33513 > 33514 [PSH, ACK] Seq=1 Ack=64241 Win=377 Len=12 TSV=8209920 TSER=8209159

The TCP connection is trying to run at 9.6kbps, sending 1460 bytes
per 'send' call.

If I start a UDP connection on the same pair of ports it
runs fine, even while the TCP connection is hung.

I am curious if anyone has any suggestions for debugging
this further, for instance, some way to see why the
TCP connection is not making forward progress.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

