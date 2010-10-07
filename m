Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50984 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0JGENP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 00:13:15 -0400
Received: from [71.117.12.23] (pool-71-117-12-23.sttlwa.dsl-w.verizon.net [71.117.12.23])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o974DE0V001341
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 6 Oct 2010 21:13:15 -0700
Message-ID: <4CAD48DA.9010208@candelatech.com>
Date: Wed, 06 Oct 2010 21:13:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Latest wireless-testing has broken scan locking.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unless I really screwed up a merge in a strange way, the
ieee80211_scan_work is broken.

It calls mutex_unlock(&local->mtx) too many times when it hits
this code:

		case SCAN_DECISION:
			/* if no more bands/channels left, complete scan */
			if (local->scan_channel_idx >= local->scan_req->n_channels) {
				aborted = false;
				goto out_complete;
			}


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
