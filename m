Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52200 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaIWXRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 19:17:24 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id C41DA409E87
	for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 16:17:22 -0700 (PDT)
Message-ID: <5421FF7F.2080109@candelatech.com> (sfid-20140924_011732_769644_FC54B9EC)
Date: Tue, 23 Sep 2014 16:17:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: How are ht-caps changes propagated after ieee80211_register_hw?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ath9k, when you set the chainmask to 2x2 on a 3x3 NIC,
the ht-caps appear as 2-streams in station association requests.

But, in ath10k, they still appear as 3x3.  I don't see any obvious way
that ath9k notifies the mac80211 stack that it changed the
ht-caps, but it must be working somehow.

Anyone know the proper way this information should make it
into the mac80211 layer?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

