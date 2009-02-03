Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:61182 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZBCIN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 03:13:59 -0500
Received: by yx-out-2324.google.com with SMTP id 8so676805yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 00:13:57 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 3 Feb 2009 10:13:57 +0200
Message-ID: <55c333c0902030013w2853ba22tc84db8594356d662@mail.gmail.com> (sfid-20090203_091403_287089_1EC99842)
Subject: A short question about scanning using mac80211 kernel stack
From: Kevin Wilson <wkevils@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I perform scan from my machine and I get 3 results of APs in the network.
As far as I understand, scanning means sending probe requests;
as an answer to these probe requests I should get probe responses from the APs
in the area.

However, I added some printk messages in the code: and I saw that I do indeed
call ieee80211_send_probe_req() when scanning. But I do ***not*** get into
ieee80211_rx_mgmt_probe_resp(), the method which handles probe
response management
packets (IEEE80211_STYPE_PROBE_RESP).

I am using the last wireless-testing git tree.

Why is it so ?
and for what is ieee80211_rx_mgmt_probe_resp() if not for handling
scan responses?

Regards,
Kevin
