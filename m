Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40815 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1BBEfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 23:35:14 -0500
Received: from [71.112.48.101] (pool-71-112-48-101.sttlwa.dsl-w.verizon.net [71.112.48.101])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p124ZD6f005992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 1 Feb 2011 20:35:13 -0800
Message-ID: <4D48DF01.1010401@candelatech.com>
Date: Tue, 01 Feb 2011 20:35:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rfkill API
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I was looking at using one rfkill socket in wpa_supplicant, instead
of one per vif.

Current wpa_supplicant code seems to treat the API as if there is only
as single rfkill object for the entire kernel.  I would assume that
instead different NICs could have different rfkill status.

Is there any way to coorelate a netdevice (or devices)
to the rfkill->idx in the

struct rfkill_event {
	u32 idx;
	u8 type;
	u8 op;
	u8 soft;
	u8 hard;
} STRUCT_PACKED;


?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
