Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.iad.emailsrvr.com ([207.97.245.116]:41290 "EHLO
	smtp116.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760810AbXGXXEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2007 19:04:30 -0400
Received: by relay1.r1.iad.emailsrvr.com (Authenticated sender: ddrake-AT-brontes3d.com) with ESMTP id BD91744C042
	for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2007 19:04:29 -0400 (EDT)
Message-ID: <46A68525.9080906@gentoo.org>
Date: Tue, 24 Jul 2007 19:03:01 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211 and net_device_stats
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Netdevs have a get_stats method which is used to return a 
net_device_stats struct up to the stack.

The old ieee80211 stack provides a net_device_stats to the drivers, and 
handles the get_stats internally. zd1211rw-softmac then manipulates the 
following fields directly:
	tx_dropped
	tx_retry_limit_exceeded
	rx_dropped
	rx_errors
	rx_missed_errors
	rx_fifo_errors
	rx_crc_errors
	rx_length_errors

I'm interested in porting this functionality over to zd1211rw-mac80211 
but this looks like a bigger task than it sounds.

mac80211 does implement a get_stats internally (per-interface) but 
doesn't expose the net_device_stats structure passed back to drivers.

So, how do we expose this?

One idea is to pass a pointer to the net_device_stats structure to the 
TX handler, so the driver can manipulate it in the TX handler:
2 problems here though:

  1. doesn't cover the RX error reporting part
  2. not all TX failures are reported from the TX handler
(e.g. the excessive retry one comes a long time later, based on an 
interrupt from a different endpoint)

Another idea: add an error field to the ieee80211_tx_status structure, 
with values like TX_ERROR_EXCESSIVE_RETRIES, TX_ERROR_OTHER. Make the 
ieee80211_tx_status() function interpret these values and update the 
net_device_stats accordingly. Additionally, add an error field to 
ieee80211_rx_status, and add more logic to ieee80211_rx_status().
Issues here:

  1. ieee80211_tx_status() doesn't know which interface is being 
reported about, so it wouldn't know which net_device_stats to update.
  2. ieee80211_rx_status() semantics would change. Currently, if we 
discard a RX frame, we don't call that function at all. We'd have to 
make it accept a NULL skb if the error field in the ieee80211_rx_status 
structure is set, or something like that.

For (1), we could pass the if_id to the TX handler. But then comes the 
issue where zd1211rw wants to report TX errors from outside the TX 
handler. I'd have to store the if_id in a structure somewhere, based on 
the knowledge that we'll only ever have one STA interface.

Thoughts?

Thanks,
Daniel
