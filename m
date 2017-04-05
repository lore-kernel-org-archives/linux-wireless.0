Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kw04.serverdomain.org ([89.107.189.121]:36232 "EHLO
        kw04.serverdomain.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753790AbdDEH1F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:27:05 -0400
Received: from mscv2.viasyshc.eu (unknown [62.157.178.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: ww4216p1)
        by kw04.serverdomain.org (kw04.serverdomain.org) with ESMTPSA id E7F3888125B29
        for <linux-wireless@vger.kernel.org>; Wed,  5 Apr 2017 09:27:02 +0200 (CEST)
From: Thomas Thielemann <thomas@th-thielemann.de>
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: How to use netlink to determine wifi protection WEP
Message-Id: <163FFAFB-1BA3-42A1-9F84-0EAEDFEBE5AE@th-thielemann.de> (sfid-20170405_092709_199390_F022E1F6)
Date: Wed, 5 Apr 2017 09:27:03 +0200
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I need a solution to determine whether a WiFi is using WEP. I know there is a protection flag within MAC frame but do not know how to access.

To detect whether a WiFi i protected by WPA2 I found the following solution: 

Scan with

nl_sock* socket = nl_socket_alloc();
genl_connect(socket);
struct nl_msg* msg = nlmsg_alloc();
int driverId = genl_ctrl_resolve(socket, "nl80211"); 
genlmsg_put(msg, 0, 0, driverId, 0, 0, NL80211_CMD_TRIGGER_SCAN, 0);

and fetch with

genlmsg_put(msg, 0, 0, driverId, 0, NLM_F_DUMP, NL80211_CMD_GET_SCAN, 0);

Read the received structure using nl80211_bss:: NL80211_BSS_INFORMATION_ELEMENTS from nl80211.h and

examine the field RSN(id=48) (see IEEE802.11-2012.pdf, chapter 8.4.2 Information elements)

Which netlink command gives me the related data? Is it NL80211_CMD_GET_BEACON?

Regards,
Thomas

E-Mail: th-thielemann@web.de
