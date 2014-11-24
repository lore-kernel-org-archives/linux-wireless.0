Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:34912 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbaKXLym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 06:54:42 -0500
Received: by mail-vc0-f178.google.com with SMTP id hq11so3565988vcb.9
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 03:54:41 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 24 Nov 2014 17:24:41 +0530
Message-ID: <CAJqpcCTAPcG4F5-oFxGa0mQhaHzDd=8b2BpTtyYvmX2vZHxYNA@mail.gmail.com> (sfid-20141124_130150_445579_27A38DB6)
Subject: Tx Status of multicast frames
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,
  We are noticing a issue in updating the multicast frame statistics.
Though mac80211 explicitly sets the IEEE80211_TX_CTL_NO_ACK, it checks
IEEE80211_TX_STAT_ACK to increment the frame count. So, for multicast
frames, is the driver expected to set this STAT_ACK if the frame is
successfully transmitted over the air?

The naming convention seems to be a bit confusing from unicast and
multicast frames perspectives:

For multicast, IEEE80211_TX_STAT_ACK can denote if a frame is
successfully transmitted over the air or failed to be transmitted.

In case of normal frames, IEEE80211_TX_STAT_ACK decides if the frame
is acked or not-acked/not-transmitted.

Do you think renaming this to something like STAT_SUCCESS would be a
better thing to do?

Vivek.

mac80211/status.c:
if (info->flags & IEEE80211_TX_STAT_ACK) {
                if (ieee80211_is_first_frag(hdr->seq_ctrl)) {
                        local->dot11TransmittedFrameCount++;
                        if (is_multicast_ether_addr(hdr->addr1))
                                local->dot11MulticastTransmittedFrameCount++;
                        if (retry_count > 0)
                                local->dot11RetryCount++;
                        if (retry_count > 1)
                                local->dot11MultipleRetryCount++;
                }

                /* This counter shall be incremented for an acknowledged MPDU
                 * with an individual address in the address 1 field or an MPDU
                 * with a multicast address in the address 1 field of type Data
                 * or Management. */
                if (!is_multicast_ether_addr(hdr->addr1) ||
                    ieee80211_is_data(fc) ||
                    ieee80211_is_mgmt(fc))
                        local->dot11TransmittedFragmentCount++;
        } else {
                if (ieee80211_is_first_frag(hdr->seq_ctrl))
                        local->dot11FailedCount++;
        }
