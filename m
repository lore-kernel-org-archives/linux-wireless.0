Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:24991 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZAVSk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 13:40:56 -0500
Received: by nf-out-0910.google.com with SMTP id d3so720617nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 10:40:54 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 20:40:54 +0200
Message-ID: <147a89290901221040o510820c6re226b386748da706@mail.gmail.com> (sfid-20090122_194102_882964_49A1EEA8)
Subject: PS Poll
From: Andy Johnson <johnsonzjo@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@iki.fi
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I had encountered the recent PS-POLL patches from
Kalle Valo and  I have three questions about PS-Poll mechanism. I hope
that I did not miss something.
In fact, the first question, which is about the design of this
mechanism, seems to me the most important.


As I understand, when a station in power save mode (dozed) gets a
beacon TIM from its AP which tells it
that the AP has kept unicast packets for it, that station wakes up and
starts sending PS-Poll frames. It sends PS-POLL one by one; each such
packet, which is received in the AP, will cause it to send an skb from
its buffer (ps_tx_buf skb queue, in sta_info struct). This packet has
a MOREDATA flag set.

The stations send PS Poll packets one by one, until the ps_tx_buf is
emptied; when the last skb from ps_tx_buf is sent from the AP, it does
not have the MOREDATA flag set, as opposed to all the previous
sk_buffs which were retrieved from the ps_tx_buf.

(I believe that it should be the IEEE80211_FCTL_MOREDATA flag, not sure).

In the period from when the first skb is retrieved to when the last
skb, the station must not got to sleep. After the last one is
received, it may go to sleep or stay awake (I wonder on what this
depends).


My questions are:


1) Why not send **one** PS-POLL which will signal the AP to start
sending sk_buffs from the ps_tx_buf until is it emptied ? why do we
send PS Poll packets
one by one ? Sending only one PS poll, as suggested, will reduce
traffic (take in accordance that we have ACKs also).

2) In the sceario depicted above, when sending PS polls one by one,
what happens if there are packets sent to that station from the same
source as packets
that were kept in the buffer - will they be received in the
destination (the client that awoke)? don't we loose here the order of
the packets?

3) should the station send ACK to the AP  for each skb it receives (as
a response to PS Poll) using this mechanism?

Regards,
Andy
