Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36936 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1A1Wji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 17:39:38 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p0SMdaWt006486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 14:39:37 -0800
Message-ID: <4D4345A8.6060806@candelatech.com>
Date: Fri, 28 Jan 2011 14:39:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: hti->control_chan is 15??
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When testing with 60 stations, 30 against a netgear running HT40
and 30 against a cheap cisco AP, using HT20, I notice that the
stations on the netgear often choose NO_HT instead of HT40
for their channel type.

The root cause appears to be that the hti->control_chan is 15
in the ieee80211_enable_ht method.

Everything *should* be running on channel 11.

Is this just a bug with the AP, or could this be a local
issue?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

