Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr00133.outbound.protection.outlook.com ([40.107.0.133]:16032
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751267AbeA0INe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 03:13:34 -0500
To: linux-wireless@vger.kernel.org
Cc: Jes.Sorensen@gmail.com
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: rtl8723bs: rtnl_is_locked() misuse
Message-ID: <d7f3ff15-ee89-7d1f-5939-ee71fa472c57@virtuozzo.com> (sfid-20180127_091338_545882_A0ED2B4D)
Date: Sat, 27 Jan 2018 11:13:28 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm reporting you about misuse of rtnl_is_locked() in rtw_change_ifname() function.
Note, that rtnl_is_locked() *does not mean* rtnl is locked on the *current cpu*.
This primitive returns true in case of rtnl is locked somewhere in the system.
So, it can't be used in the below code:

if (!rtnl_is_locked())
                unregister_netdev(cur_pnetdev);
        else
                unregister_netdevice(cur_pnetdev);

Kirill
