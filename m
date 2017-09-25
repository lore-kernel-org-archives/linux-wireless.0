Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:49431 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932120AbdIYHBh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 03:01:37 -0400
Received: by mail-wr0-f179.google.com with SMTP id u96so5970736wrb.6
        for <linux-wireless@vger.kernel.org>; Mon, 25 Sep 2017 00:01:37 -0700 (PDT)
MIME-Version: 1.0
From: Belisko Marek <marek.belisko@gmail.com>
Date: Mon, 25 Sep 2017 09:01:35 +0200
Message-ID: <CAAfyv34TsmjqHi+Pr1UrfXmPe=vWvt3-ZkaqcY01pBurbc8nfA@mail.gmail.com> (sfid-20170925_095440_716139_A7D5AA8A)
Subject: mwifiex: Firmware wakeup failed in 4.1 kernel
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: amitkarwar@gmail.com, nishants@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using 4.1 stock kernel on imx cpu and 8897 wifi chip connected
over pcie to cpu. I did stress test by disabling AP in loop when wifi
card is connected to perform scanning and reconnect. After 25 attempts
I'll get following and after that wifi is unusable:

mwifiex_pcie 0000:01:00.0: Firmware wakeup failed
 mwifiex_pcie 0000:01:00.0: failed to get signal information
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 mwifiex_pcie 0000:01:00.0: failed to get signal information
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 mwifiex_pcie 0000:01:00.0: failed to get signal information
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 mwifiex_pcie 0000:01:00.0: failed to get signal information
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 mwifiex_pcie 0000:01:00.0: failed to get signal information
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 mwifiex_pcie 0000:01:00.0: failed to get signal information
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 ieee80211 phy0: deleting the crypto keys
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 ieee80211 phy0: deleting the crypto keys
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 ieee80211 phy0: deleting the crypto keys
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 ieee80211 phy0: deleting the crypto keys
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 ieee80211 phy0: deleting the crypto keys
 mwifiex_pcie 0000:01:00.0: PREP_CMD: FW in reset state
 ieee80211 phy0: deleting the crypto keys

I did look to some new patches and found following patch [0] but it
didn't help. Is there anything else I can try to fix this issue?
Thanks a lot.

[0] - https://patchwork.kernel.org/patch/9516615/

BR,

marek
-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
