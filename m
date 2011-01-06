Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36479 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1AFTzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 14:55:18 -0500
Message-ID: <4D261E22.1090300@candelatech.com>
Date: Thu, 06 Jan 2011 11:55:14 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: ath9k ath_tx_complete_poll_work doesn't always run.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that the ath_tx_complete_poll_work method is supposed to
run every 1 second to check for stale xmit buffers.

However, I noticed that sometimes it is stopped, perhaps
because the mac80211 workqueue is flushed and ath9k
doesn't know to re-setup the work.

I am curious if anyone knows how this is *supposed* to
function?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

