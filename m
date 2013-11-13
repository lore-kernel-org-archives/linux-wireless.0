Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46723 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759407Ab3KMR6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:58:15 -0500
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id rADHwEnV016938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 09:58:14 -0800
Message-ID: <5283BDB6.5020700@candelatech.com> (sfid-20131113_185828_317303_249B3536)
Date: Wed, 13 Nov 2013 09:58:14 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RFC:  Add precise timing to wifi association messages?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any interest in a patch looking similar to that below for the
5 or so messages related to association?  I found it useful for
tracking down why it was taking longer than expected to roam
to a new AP...


diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d2510c0..2e96813 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -908,6 +908,12 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
                memcpy(pos, assoc_data->ie + offset, noffset - offset);
        }

+       {
+               struct timeval tv;
+               do_gettimeofday(&tv);
+               sdata_info(sdata, "send_assoc, calling prepare_tx at: %lu.%lu\n",
+                          tv.tv_sec, tv.tv_usec);
+       }
        drv_mgd_prepare_tx(local, sdata);

        IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

