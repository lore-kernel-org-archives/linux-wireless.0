Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34525 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3CMWRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 18:17:04 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r2DMH3FO022751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 15:17:03 -0700
Message-ID: <5140FADF.9060307@candelatech.com> (sfid-20130313_232505_542751_F9862093)
Date: Wed, 13 Mar 2013 15:17:03 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: question on beacon-loss messages
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am wondering, should the rssi_notify() call only be made if 'beacon' is
true?

I'm seeing lots of beacon-miss events, but when I print out the beacon-loss counters,
they are zero (or much smaller than the number of events I see come out of 'iw').



static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
				   bool beacon)
{
	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
	bool already = false;

	if (!ieee80211_sdata_running(sdata))
		return;

	mutex_lock(&ifmgd->mtx);

	if (!ifmgd->associated)
		goto out;

	mutex_lock(&sdata->local->mtx);

	if (sdata->local->tmp_channel || sdata->local->scanning) {
		mutex_unlock(&sdata->local->mtx);
		goto out;
	}

	if (beacon)
		mlme_dbg_ratelimited(sdata,
				     "detected beacon loss from AP - probing\n");

	ieee80211_cqm_rssi_notify(&sdata->vif,
		NL80211_CQM_RSSI_BEACON_LOSS_EVENT, GFP_KERNEL);


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

