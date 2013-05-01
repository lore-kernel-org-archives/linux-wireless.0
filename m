Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49887 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab3EAVAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 17:00:53 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r41L0qO9009236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 1 May 2013 14:00:52 -0700
Message-ID: <51818284.8010304@candelatech.com> (sfid-20130501_230057_856221_5553E007)
Date: Wed, 01 May 2013 14:00:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: How to find sdata's frequency?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For ath9k, the code below finds a chanctx_conf (and channel), but for ath9k_htc
it does not.  Any idea for how to find the current operating
channel for ath9k_htc?

	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
	if (chanctx_conf)
		channel = chanctx_conf->def.chan;
	else
		channel = NULL;

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

