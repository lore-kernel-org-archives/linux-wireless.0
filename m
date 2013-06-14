Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58504 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3FNXed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 19:34:33 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r5ENYWtF024484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2013 16:34:32 -0700
Message-ID: <51BBA888.7030309@candelatech.com> (sfid-20130615_013436_943608_0F86F43A)
Date: Fri, 14 Jun 2013 16:34:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Double 'put' of bss in mac80211/mlme.c?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like an easy way to leak ies would be to mess up the
ref counting on bss objects.

While looking at such code, I found this in mac80211/mlme.c

The destroy_assoc_data does a put_bss, and then it is put again
directly.  Is this on purpose, or would this effectively cause
a double-free?

		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
			/* oops -- internal error -- send timeout for now */
			ieee80211_destroy_assoc_data(sdata, false);
			cfg80211_put_bss(sdata->local->hw.wiphy, *bss);
			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
		}

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

