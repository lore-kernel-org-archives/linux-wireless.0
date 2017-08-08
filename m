Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:41890 "EHLO
        resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752066AbdHHTQN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 15:16:13 -0400
From: James Feeney <james@nurealm.net>
Subject: wireless drivers fail to report link speed?
Reply-To: james@nurealm.net
To: linux-wireless@vger.kernel.org
Message-ID: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net> (sfid-20170808_211628_289451_F0894C89)
Date: Tue, 8 Aug 2017 13:07:17 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All

Would you please look at kernel bug report "Since 4.12 - bonding module not
working with wireless drivers", and tell me if you know why the kernel ethtool
does not receive a speed report from the wireless drivers?

 https://bugzilla.kernel.org/show_bug.cgi?id=196547

It seems that Mahesh Bandewar became annoyed that some network drivers do not
report speed and duplex to the bonding module properly, so that it becomes
impossible to make "best connection" decisions.  A patch was applied to the
bonding module in linux 4.12 which now disables any network interface that does
not successfully report its speed and duplex.  In practice, this seems to
include every wireless network driver I've tried, the ath5k, ath9k, the
rtl8192ce and RTL8188CUS.  Of course, this new behavior breaks wireless bonding!

Do you know if there is some general reason why the wireless drivers do not work
with the kernel ethtool?  Is this something that can be fixed?  Can you tell if
this reporting failure would be the fault of the kernel ethtool?  Or the
wireless driver?  Or the bonding module?

Thanks
James
