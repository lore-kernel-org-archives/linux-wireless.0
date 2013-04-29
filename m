Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mundo.umh.es ([193.147.144.26]:47620 "EHLO mundo.umh.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab3D2Jhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 05:37:43 -0400
Received: from bcoll (unknown [10.1.60.57])
	by mundo.umh.es (Postfix) with ESMTP id B06C2205B6E
	for <linux-wireless@vger.kernel.org>; Mon, 29 Apr 2013 11:37:42 +0200 (CEST)
From: "Coll Perales, Baldomero" <bcoll@umh.es>
To: <linux-wireless@vger.kernel.org>
Subject: Pause and restart 802.11 ad-hoc communication
Date: Mon, 29 Apr 2013 11:37:47 +0200
Message-ID: <002801ce44bd$358d3f40$a0a7bdc0$@es> (sfid-20130429_113746_852925_890CAA91)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good morning everybody,
I am doing research on 802.11 ad-hoc wireless networks. Currently I am
working on how to pause and restart the communication process between two
802.11 nodes. I am looking for the best solution to this problem and I found
two possible implementations:
1) Implementing a NIC (Network Interface Card) that should be able to manage
the interface between the kernel and the network card.
2)  Changing the source code that implements the TCP/IP stack inside the
Linux Kernel. I am trying to do this changing the source code of
“net/mac80211/tx.c” and “net/mac80211/rx.c”. 

This pause and restart process should stop the queue of data packets that
will be passed to the network card and store them until one event happens.
This solution should not interfere to the automatic works of the network
card such as the sensing of the channel or the reception of other packets
(for example beacons).

The main problem is that I do not know which is the best option or, maybe if
another one exists. I am so worried about the problems that can cause this
pause in the other processes that are working in the kernel.
Nowadays I am working with the 2.6.24 version of Linux kernel (because I am
following a book that explains how drivers works in Linux) but my intention
is to do this implementation in the newest versions of Linux.
Thanks you very much for your attention,
Alejandro Moraleda

