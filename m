Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36390 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbeAZWxq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 17:53:46 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id C749F40A30A
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jan 2018 14:53:43 -0800 (PST)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: ath9k will not tx packets sometimes.
Message-ID: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com> (sfid-20180126_235351_078156_24BD2A13)
Date: Fri, 26 Jan 2018 14:53:43 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm doing a test with 200 virtual stations on each of 6 ath9k radios.

When I configure stations for DHCP, I see cases where stations on a particular
radio will not transmit anything sometimes.  I see no 'XMIT' logs that show indication of
frames being received in the driver from the upper stack, but if I use 'tshark' on
a station interface, it shows frames being 'transmitted'.

I do, however, see this, which looks like it might show
an issue.  It looks like whatever 'aqm' is, it has an ever expanding number
of backlog packets:

[root@2u-6n lanforge]# cat /debug/ieee80211/wiphy2/netdev\:sta30194/stations/00\:0e\:8e\:69\:b8\:f7/aqm
target 49999us interval 299999us ecn no
tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets
0 2 27616 440 9 0 0 0 428 998 7
1 3 0 0 0 0 0 0 0 0 0
2 3 0 0 0 0 0 0 0 0 0
3 2 0 0 0 0 0 0 0 0 0
4 1 0 0 0 0 0 0 0 0 0
5 1 0 0 0 0 0 0 0 0 0
6 0 0 0 1 0 0 0 0 390 1
7 0 0 0 637 0 0 0 792 22072 903
8 2 0 0 0 0 0 0 0 0 0
9 3 0 0 0 0 0 0 0 0 0
10 3 0 0 0 0 0 0 0 0 0
11 2 0 0 0 0 0 0 0 0 0
12 1 0 0 0 0 0 0 0 0 0
13 1 0 0 0 0 0 0 0 0 0
14 0 0 0 0 0 0 0 0 0 0
15 0 0 0 0 0 0 0 0 0 0


Anyone have any pointers as to whether this might be a real issue or not?  I'll go
digging in the meantime....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
