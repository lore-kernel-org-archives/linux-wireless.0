Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0117.outbound.protection.outlook.com ([104.47.1.117]:56300
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751267AbeA0IId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 03:08:33 -0500
To: linux-wireless@vger.kernel.org
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: wilc1000: rtnl_is_locked() misuse
Message-ID: <0fe3c986-7411-fc77-c00c-e2e887375cb4@virtuozzo.com> (sfid-20180127_090837_719774_A0393BB1)
Date: Sat, 27 Jan 2018 11:08:21 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm reporting you about misuse of rtnl_is_locked() in WILC_WFI_deinit_mon_interface() function.
Note, that rtnl_is_locked() *does not mean* rtnl is locked on the *current cpu*. This primitive
returns true in case of rtnl is locked somewhere in the system. So, it can't be used in the below
code:

int WILC_WFI_deinit_mon_interface(void)
{
        bool rollback_lock = false;

        if (wilc_wfi_mon) {
                if (rtnl_is_locked()) {			<------Mistake
                        rtnl_unlock();
                        rollback_lock = true;
                }
                unregister_netdev(wilc_wfi_mon);

                if (rollback_lock) {
                        rtnl_lock();
                        rollback_lock = false;
                }
                wilc_wfi_mon = NULL;
        }
        return 0;
}

Kirill
