Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49757 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908Ab2CFK5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 05:57:48 -0500
Date: Tue, 6 Mar 2012 13:57:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: ashok@cozybit.com
Cc: linux-wireless@vger.kernel.org
Subject: re: {nl,cfg,mac}80211: Implement RSSI threshold for mesh peering
Message-ID: <20120306105737.GA2038@elgon.mountain> (sfid-20120306_115751_740483_8FD575D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ashok Nagarajan,

This is a semi-automatic email about new static checker warnings.

The patch 5533513784a8: "{nl,cfg,mac}80211: Implement RSSI threshold 
for mesh peering" from Feb 28, 2012, leads to the following Smatch 
complaint:

net/mac80211/mesh_plink.c:542 mesh_rx_plink_frame()
	 error: we previously assumed 'sta' could be null (see line 534)

net/mac80211/mesh_plink.c
   533		sta = sta_info_get(sdata, mgmt->sa);
   534		if (!sta && ftype != WLAN_SP_MESH_PEERING_OPEN) {
                    ^^^^
old check.

   535			mpl_dbg("Mesh plink: cls or cnf from unknown peer\n");
   536			rcu_read_unlock();
   537			return;
   538		}
   539	
   540		if (ftype == WLAN_SP_MESH_PEERING_OPEN &&
   541		    !sta_meets_rssi_threshold(sta, sdata)) {
                     ^^^^^^^^^^^^^^^^^^^^^^^^
new dereference.

   542			mpl_dbg("Mesh plink: %pM does not meet rssi threshold\n",
   543				sta->sta.addr);
                                ^^^^^
new dereference.
   544			rcu_read_unlock();

regards,
dan carpenter

