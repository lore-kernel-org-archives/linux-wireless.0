Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38694 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbeITCMt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 22:12:49 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 7BDEC40A30A
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2018 13:33:11 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Problem with sending pkt on a monitor port
Message-ID: <76ce3d16-dbea-e882-63e7-2337fbc269c6@candelatech.com> (sfid-20180919_223316_460674_F032A088)
Date: Wed, 19 Sep 2018 13:33:11 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is with a modified 4.16.18+ kernel, though the code in question
is from 2011, so this is not new...

I am attempting to use radiotap packet injection on a monitor port.

In the ieee80211_monitor_start_xmit method, before this code below
runs, sdata is 'moni6a', my monitor port.  But, since I have a
station wlan1 with the same MAC address, then when this code is
completed, stdata becomes wlan1.

Ath10k has all sorts of issues transmitting raw frames, and sending on
the wrong vdev only makes it even more broken!

If user-space binds a socket to a monitor vdev and transmits a frame,
why would we want to change the vdev here?

	list_for_each_entry_rcu(tmp_sdata, &local->interfaces, list) {
		if (!ieee80211_sdata_running(tmp_sdata))
			continue;
		if (tmp_sdata->vif.type == NL80211_IFTYPE_MONITOR ||
		    tmp_sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
		    tmp_sdata->vif.type == NL80211_IFTYPE_WDS)
			continue;
		if (ether_addr_equal(tmp_sdata->vif.addr, hdr->addr2)) {
			sdata = tmp_sdata;
			break;
		}
	}

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
