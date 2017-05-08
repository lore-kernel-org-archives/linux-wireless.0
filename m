Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34497 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbdEHLSJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 07:18:09 -0400
Received: by mail-oi0-f42.google.com with SMTP id b204so46218279oii.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 May 2017 04:18:09 -0700 (PDT)
MIME-Version: 1.0
From: Maxime Vincent <maxime.vince@gmail.com>
Date: Mon, 8 May 2017 13:18:07 +0200
Message-ID: <CACBz14-1sf++sFT6gXawNdf87B6fsyETZu+SVcyVQA5KApwmrg@mail.gmail.com> (sfid-20170508_131813_463676_B170EB81)
Subject: mwifiex_pcie does not recover after suspend
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am running the latest linux-next wireless stack, backported on 4.4,
including the latest mwifiex patches that have been posted on this
mailing list. (thanks!)
Latest patch I applied is "mwifiex: pcie: add card_reset() support"
from Brian Norris.

I am running this kernel on a Microsoft Surface Pro 4.

After suspending (to disk) and resuming, the relevant dmesg output is:
[  158.094407] Restarting tasks ...
[  158.096470] usb 1-5: USB disconnect, device number 3
[  158.096515] done.
[  158.097137] ieee80211 phy0: sched_scan start : n_ssids=1 n_match_sets=1
[  158.097144] ieee80211 phy0: n_channels=41 interval=10 ie_len=126
[  168.118775] mwifiex_pcie 0000:02:00.0: mwifiex_cmd_timeout_func:
Timeout cmd id = 0x6b, act = 0x1
[  168.118797] mwifiex_pcie 0000:02:00.0: num_data_h2c_failure = 0
[  168.118804] mwifiex_pcie 0000:02:00.0: num_cmd_h2c_failure = 0
[  168.118810] mwifiex_pcie 0000:02:00.0: is_cmd_timedout = 1
[  168.118816] mwifiex_pcie 0000:02:00.0: num_tx_timeout = 0
[  168.118822] mwifiex_pcie 0000:02:00.0: last_cmd_index = 1
[  168.118829] mwifiex_pcie 0000:02:00.0: last_cmd_id: e5 00 6b 00 28
00 28 00 28 00
[  168.118835] mwifiex_pcie 0000:02:00.0: last_cmd_act: 01 00 01 00 13
00 13 00 13 00
[  168.118841] mwifiex_pcie 0000:02:00.0: last_cmd_resp_index = 0
[  168.118848] mwifiex_pcie 0000:02:00.0: last_cmd_resp_id: e5 80 28
80 28 80 28 80 28 80
[  168.118854] mwifiex_pcie 0000:02:00.0: last_event_index = 2
[  168.118860] mwifiex_pcie 0000:02:00.0: last_event: 0b 00 0a 00 0a
00 58 00 58 00
[  168.118866] mwifiex_pcie 0000:02:00.0: data_sent=0 cmd_sent=1
[  168.118873] mwifiex_pcie 0000:02:00.0: ps_mode=1 ps_state=0
[  168.120902] ieee80211 phy0: sched_scan start : n_ssids=1 n_match_sets=1
[  168.120914] ieee80211 phy0: n_channels=41 interval=10 ie_len=126
[  168.120925] mwifiex_pcie 0000:02:00.0: PREP_CMD: FW is in bad state
[  168.121770] mwifiex_pcie 0000:02:00.0: Ignore scan. Card removed or
firmware in bad state
[  168.121780] mwifiex_pcie 0000:02:00.0: scan failed: -14
[  168.125201] mwifiex_pcie 0000:02:00.0: ===mwifiex driverinfo dump start===
[  168.125278] mwifiex_pcie 0000:02:00.0: info: MWIFIEX VERSION:
mwifiex 1.0 (15.68.7.p77)
[  168.125288] mwifiex_pcie 0000:02:00.0: PCIE register dump start
[  168.125382] mwifiex_pcie 0000:02:00.0: pcie scratch register:
[  168.125392] mwifiex_pcie 0000:02:00.0: reg:0xcf0, value=0x0
               reg:0xcf8, value=0x0
               reg:0xcfc, value=0x0

[  168.125395] mwifiex_pcie 0000:02:00.0: PCIE register dump end
[  168.125433] mwifiex_pcie 0000:02:00.0: ===mwifiex driverinfo dump end===
[  168.125436] mwifiex_pcie 0000:02:00.0: == mwifiex firmware dump start ==
[  168.156435] mwifiex_pcie 0000:02:00.0: Fail to pull ctrl_data
[  168.156469] mwifiex_pcie 0000:02:00.0: == mwifiex dump information
to /sys/class/devcoredump start
[  168.156548] mwifiex_pcie 0000:02:00.0: == mwifiex dump information
to /sys/class/devcoredump end
[  168.156728] mwifiex_pcie 0000:02:00.0: info: shutdown mwifiex...
[  168.157429] mwifiex_pcie 0000:02:00.0: PREP_CMD: card is removed
[  168.157437] mwifiex_pcie 0000:02:00.0: PREP_CMD: card is removed
[  169.282762] mwifiex_pcie 0000:02:00.0: FW CRC error indicated by
the helper: len = 0x0011, txlen = 17
[  169.282784] mwifiex_pcie 0000:02:00.0: Invalid parameter in
mwifiex_pcie_send_boot_cmd <ffff8801506e0cc0. len 0>
[  169.282786] mwifiex_pcie 0000:02:00.0: Failed to send firmware
download command
[  169.282794] mwifiex_pcie 0000:02:00.0: prog_fw failed ret=0xffffffff
[  169.282801] mwifiex_pcie 0000:02:00.0: info: _mwifiex_fw_dpc:
unregister device


 I am willing to do some experiments, by modifying the driver myself,
but need some pointers on where to look, or what to try. Would
downloading the firmware to the controller again help?

Any help is welcome! Thanks.

Maxime Vincent
