Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:43789
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756585Ab0CaTka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 15:40:30 -0400
Date: Wed, 31 Mar 2010 21:10:58 +0200
From: Johan Hovold <johan.hovold@lundinova.se>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org
Subject: ath9k: receive stops working in AP-mode and 802.11n
Message-ID: <20100331191058.GD18913@lundinova.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

I'm having a problem with ath9k running in AP-mode where receive seems to stop
working during large transfers. When this happen I can, for example, see
ping requests from the AP and replies from STA in the air but the
replies seem to get lost somewhere in the AP (I see the frames being
acked). Disconnecting and reconnecting from the STA brings the
connection back up. A group-rekeying event is also sufficient restore
the connection.

Note also that while the connection is stalled, I can still associate using a
second STA and everything works fine.

The problem is easily reproducible in my test setup with an x86-based STA using
iwlagn (5300) and a 2.6.33.1 kernel, and a powerpc-based AP running 2.6.32.10
and ath9k (AR9280) from a recent compat-wireless (e.g. 2010-03-23).

My customer Excito producing the AP has noted similar problems with STAs using
Intel 5100-chipsets under Windows. I have also been able to reproduce it (once)
with an STA running ath9k (AR5008) from 2.6.33.1 on x86. Perhaps more
importantly, I can also trigger the same behaviour when I run the latter system
in AP-mode.

The x86-AP uses hostapd 0.7.1 and the powerpc-AP a git-build from somewhere
between 0.7.0 and 0.7.1.

In my test setup the problem is triggered by running iperf as a client on the
AP and thus _sending_ a lot of data to the STA. Reversing this relation does
not seem to trigger the problem (as easily). Also, everything seem to work
fine in 802.11g (in both directions).

Some observations:

  - Normally only takes a few seconds at 30-40Mbits/s to trigger, but can
    sometimes take longer.
  - Seems to be related to throughput:
    - takes longer to trigger when using many small writes (e.g. 1MB a time).
    - takes longer to trigger when when competing for bandwidth with a second
      connection or when the transfer is CPU-bound in the AP.
  - Possibly triggers faster the second time after having disconnected and
    re-associated without restarting hostapd (but this is more a feeling
    I've got).
  - I have seen occasional crashes in iwlagn in the STA, but can't say for sure
    that it is related.

When the connection has stalled I can see TCP and ARP traffic in the air which
seem to indicate that the problem is in AP receive:

  - AP (running iperf client) retransmits a TCP packet over and over, although
    the STA is acking
  - ping sent from AP is answered by STA, but answer seems to get lost in AP
    (frame is acked)
  - ping sent from STA is not answered by AP
  - AP sending repeated ARP-requests even though STA is answering them 
  - STA sending unanswered ARP-requests

The corresponding frames sent by the STA are all acked by the AP. There are
also management frames being sent and answered (delete and add block acks).

As I mentioned above, I can associate using a second STA and establish a
TCP-connection while the first one is stalled. I can also have two connected
STAs and trigger the stall on one of them without it affecting the other.  

Any ideas about what may be the problem here or suggestion on further steps
that can be taken to identify it?

Thanks,
Johan Hovold
Lundinova AB

