Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40512 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab1JaWe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 18:34:56 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p9VMYtZJ001698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 15:34:55 -0700
Message-ID: <4EAF228F.6030104@candelatech.com> (sfid-20111031_233459_465667_F36C4610)
Date: Mon, 31 Oct 2011 15:34:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: problem clearing bit-rates with 'iw'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the help, it seems I should be able to pass no rates and
have it clear the mask.  But, it seems that is not actually working:

[root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw dev sta4 set bitrates legacy-2.4
command failed: Invalid argument (-22)
[root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw dev sta4 set bitrates legacy-2.4 ""
Usage:	./local/sbin/iw [options] dev <devname> set bitrates [legacy-<2.4|5> <legacy rate in Mbps>*]

Sets up the specified rate masks.
Not passing any arguments would clear the existing mask (if any).

Options:
	--debug		enable netlink debugging
[root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw dev sta4 set bitrates
command failed: Invalid argument (-22)


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

