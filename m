Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44612 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2LEFqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 00:46:21 -0500
Received: from [50.54.136.152] (50-54-136-152.evrt.wa.frontiernet.net [50.54.136.152])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id qB55kKDC010014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 4 Dec 2012 21:46:20 -0800
Message-ID: <50BEDFAC.9020206@candelatech.com> (sfid-20121205_064623_854842_08444775)
Date: Tue, 04 Dec 2012 21:46:20 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ethtool stats for wifi devices broken in 3.7.0-rc8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think the problem is that the code that assigns dev->ethtool_ops
in net/wireless/core.c checks for existence of ops first..

But, net/core/dev.c assigns a default ethtool_ops in the alloc_netdev_mqs
method.

Maybe cfg80211 should just always assign the value?

Thanks,
Ben
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

