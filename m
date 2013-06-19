Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32512 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933862Ab3FSJ2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 05:28:34 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOM002PRVESDLA0@mailout2.w1.samsung.com> for
 linux-wireless@vger.kernel.org; Wed, 19 Jun 2013 10:28:31 +0100 (BST)
Received: from CAMNPWMFITZJOH ([106.1.222.14])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MOM00B9FVNG3410@eusync1.samsung.com> for
 linux-wireless@vger.kernel.org; Wed, 19 Jun 2013 10:28:31 +0100 (BST)
Reply-to: m.fitzjohn@samsung.com
From: Mark Fitzjohn <m.fitzjohn@samsung.com>
To: linux-wireless@vger.kernel.org
Subject: mac80211: impact of netif_carrier_off during roaming
Date: Wed, 19 Jun 2013 10:28:28 +0100
Message-id: <004401ce6ccf$5b69e620$123db260$%fitzjohn@samsung.com> (sfid-20130619_112839_840707_F89EB4D8)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I've noticed that during roaming triggered by detection of a significantly
better AP in wpa_supplicant that mac80211 calls netif_carrier_off and then
netif_carrier_on when associated with the new AP.

Does this have any detrimental impact on applications using the wifi
connection or is the assumption that as long as the roam happens in a
reasonable time then applications should tolerate it?

Just wondering if signalling the netif_carrier_off only when the current AP
is lost and there is no immediate alternative AP for the network available
was considered?

Thanks
Mark


