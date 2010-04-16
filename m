Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:18959
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756331Ab0DPKsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 06:48:52 -0400
Date: Fri, 16 Apr 2010 12:48:50 +0200
From: Johan Hovold <johan.hovold@lundinova.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Tor Krill <tor@excito.com>
Subject: ath9k: corrupt frames forwarded to mac80211 as decrypted (was:
 ath9k: receive stops working in AP-mode and 802.11n)
Message-ID: <20100416104850.GA13329@lundinova.se>
References: <20100331191058.GD18913@lundinova.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100331191058.GD18913@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

I now know why 802.11n receive stalls; ath9k is passing corrupt frames to
mac80211.

The corrupt frames are marked as decrypted so the receive PN is updated to a
random number. Later non-corrupt frames with correct PNs are consequently
deemed out-of-sequence and are dropped. Connection is restored at re-keying as
this resets the queue PN.

I noted that some of the corrupt frames may be caught in the driver by closer
inspection of the associated rx status. By modifying the receive processing I
am able to catch most corrupt frames. Unfortunately, there are still some that
seem impossible to identify without actually looking at the actual frames.

An example of such a frame is:

	00000000: 88 41 30 00 00 80 48 68 08 0f 00 21 6a 56 2c 36
	00000010: 00 22 02 00 0b 63 20 52 00 00 20 21 21 05 00 20
	00000020: 8a 39 7b 1f 0f 11 07 9e bd 53 80 33 3b 8c 98 00
	00000030: ef 5f da 7c 9a d6 3d d7 59 ac e0 21 44 88 63 d7
	00000040: 21 34 b7 9a 89 8e cf 9e 46 1c ee d6 81 56 25 59
	00000050: d2 ec ac 33 e6 12 3d c5 02 61 2d 80 8d 30 44 1e
	00000060: 79 74 79 79 62 25 ba ec 04 4d 54 dc

with associated status

	rxstatus8 = 1e989103

Here nothing in the frame status indicates an error; the frame has no error
flags set, the frame-ok flag is set, and so on. Still the frame is indeed
corrupt; the last four octets of the CCMP-header (bytes 0x20..0x23) should
be {00,00,00,00} rather than {8a,39,7b,1f} as the correct PN is 0x0521 (not
0x1f7b398a0521).

The corrupt frames all seem to have the upper half of the CCMP-header, data
and MIC corrupted, whereas the FCS (last four bytes) seem to be correct in the
sense that they match what I see in the air (and is verified by wireshark).

One explanation for all of this could be that the corrupt packet is what the
hardware is expected to return should it's processing fail (e.g. due to
checksum error). Then the problem is merely that the status field sometimes
get corrupted (some frames with corrupt PN do indeed come with matching
rxstatus). Comments in the code concerning corrupt status fields also point in
this direction.

Another explanation could be that the status is actually correct but for some
reason the returned frame is corrupted. Perhaps it's a combination of both
corrupt status and frame.

Any ideas about what may be going on here?

As I mentioned above I can catch most corrupt frames with the following changes
to the rx processing:

  ath9k: clean up rx skb post-process logic
  ath9k: do not mark frames with RXKEY_IX_INVALID as decrypted
  ath9k: do not mark frames with RX_DECRYPT_BUSY as decrypted
  ath9k: do not mark frames with RX_KEY_MISS as decrypted
  ath9k: check error flags even if rx frame is marked ok
  ath9k: clear mic error flag on encrypted frames

 drivers/net/wireless/ath/ath9k/common.c |   16 ++++++++--------
 drivers/net/wireless/ath/ath9k/mac.c    |   26 +++++++++++++-------------
 drivers/net/wireless/ath/ath9k/mac.h    |    1 +
 3 files changed, 22 insertions(+), 21 deletions(-)

The last change reduces the number of false MIC-errors that leads hostapd to
trigger countermeasures.

I might be violating the semantics of the error flags with some of these
changes, but it does make sense if indeed the status flags are getting
corrupted. For instance, if the FrameOK flag is erroneously set the remaining
error flags would never be checked. My change make sure the error flags are
always checked. Of course this may also, if the error flags get set due to status
corruption, lead to occasional false negatives which would have to be resend,
but this is better than passing false positives to mac80211 which breaks
communication completely.

I'm responding to this mail with the aforementioned patches against linux-next
from 20100413.

I'm still using AR9280.

Thanks,
Johan Hovold

