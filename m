Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:35759 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYKEU1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 15:27:38 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mA5KQwfH006038
	for <linux-wireless@vger.kernel.org>; Wed, 5 Nov 2008 14:27:36 -0600
Received: from tikku (essapo-nirac253251.europe.nokia.com [10.162.253.251])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mA5KRUOH029904
	for <linux-wireless@vger.kernel.org>; Wed, 5 Nov 2008 22:27:31 +0200
To: linux-wireless@vger.kernel.org
Subject: Thoughts about mac80211 client PS implementation
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 05 Nov 2008 22:27:30 +0200
Message-ID: <87k5bhkjf1.fsf@nokia.com> (sfid-20081105_212743_302957_1CBD059B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm working on implementing the "dynamic Power Save" (ie. PS enabled
after an idle period) feature to mac80211. Here are my current
thoughts:

First of all, I think we should enable CONF_PS only when associated.
So instead of directly calling hw_config() from
ieee80211_ioctl_siwpower() we should do that only when associated.
Otherwise we change it only after association or disassociation. This
means that we have to add a separate bit/variable for storing what
user has requested.

PS should be disabled while associated and running software scan, and
naturally re-enabled after the scan has finished. I assume hardware
scanning implementations are clever enough to disable PS when scanning
and we don't have to worry about that case.

The dynamic PS implementation is still a bit open issue for me. I have
been thinking something like that in tx.c frames will be queued if PS
is enabled, PS will be disabled in a workqueue by calling
ieee80211_hw_config() and only after that the queued frames are
transfered. So something similar as sta->ps_tx_buf does in AP mode. No
idea if this is feasible or not.

Any comments before I'll start writing code?

-- 
Kalle Valo
