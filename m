Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58752 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515AbbBJAwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 19:52:24 -0500
Received: from [192.168.100.236] (unknown [50.251.239.81])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 45CF840EA73
	for <linux-wireless@vger.kernel.org>; Mon,  9 Feb 2015 16:52:24 -0800 (PST)
Message-ID: <54D95647.2000000@candelatech.com> (sfid-20150210_015227_624832_E592010E)
Date: Mon, 09 Feb 2015 16:52:23 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mac80211-hwsim and skb-orphan?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the mac80211_hwsim_tx_frame_nl, should be be orphaning the
skb after we send the unicast netlink message?

I'm seeing a case where I can send the first 13 or so ping frames,
but then sockets stop sending with ENOBUFS.  I'm getting ping responses
for the first 13 frames, so it appears it is properly going to the
netlink socket and user-space app.

If not this, any other ideas what I might be missing?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

