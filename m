Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40422 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSA2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 20:28:02 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r5J0S0kv017863
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2013 17:28:01 -0700
Message-ID: <51C0FB10.9020704@candelatech.com> (sfid-20130619_022806_291010_85602D70)
Date: Tue, 18 Jun 2013 17:28:00 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Association status 5 from Netgear
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm seeing association status code 5 coming from an over-loaded
netgear.

I'm guessing that the AP is buggy and is trying to use a reason-code for
a status-code?

A reason-code of 5 would make sense here:
"Disassociated because AP is unable to handle all currently associated STAs"

(per 802.11-2012, pages 442, 445)

# grep sta325 /tmp/iwlog.txt
sta325 (phy #3): scan started
sta325: new station c4:3d:c7:af:3c:7c
sta325 (phy #3): scan finished: 5745, ""
sta325 (phy #3): auth c4:3d:c7:af:3c:7c -> 00:1d:ea:be:ef:7c status: 0: Successful
sta325: del station c4:3d:c7:af:3c:7c
sta325 (phy #3): assoc c4:3d:c7:af:3c:7c -> 00:1d:ea:be:ef:7c status: 5: <unknown>
sta325 (phy #3): failed to connect to c4:3d:c7:af:3c:7c, status: 5: <unknown>

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

