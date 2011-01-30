Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54722 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1A3FiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 00:38:24 -0500
Received: from [71.112.48.101] (pool-71-112-48-101.sttlwa.dsl-w.verizon.net [71.112.48.101])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p0U5cNTj011453
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sat, 29 Jan 2011 21:38:24 -0800
Message-ID: <4D44F94F.8040707@candelatech.com>
Date: Sat, 29 Jan 2011 21:38:23 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Why is wmm_param required for HT40- in mlme.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried to set up hostapd to do HT40-, but for whatever reason,
it's not sending any wmm_param options, so the stations will not
associate with HT40- enabled due to the check below.

Is it really *reqired* that wmm_param exist to enable HT mode?

 From mlme.c:
	if (elems.ht_info_elem && elems.wmm_param &&
	    (sdata->local->hw.queues >= 4) &&
	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
					       cbss->bssid, ap_ht_cap_flags);

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
