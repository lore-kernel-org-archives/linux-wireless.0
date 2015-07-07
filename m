Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:35594 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbbGGJGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 05:06:48 -0400
Received: by ykfs198 with SMTP id s198so67190437ykf.2
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2015 02:06:48 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Jul 2015 11:06:47 +0200
Message-ID: <CALtMJEANXpsow_-MU4uEOJwj4Y0pts=6vb7AA9q=HZyGL+vBxw@mail.gmail.com> (sfid-20150707_110654_299335_E36F0EF4)
Subject: mwifiex: cmd timeout during suspend
From: Andreas Fenkart <afenkart@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Observed FW reset during suspend. This is harmful since during suspend,
driver shall not reset and reload the FW.

Problem has been observed on kernel 4.0 / 39a88044. I've already seen this
upstream patch:
1ebd221f88397 mwifiex: stop command path in suspend handle

Since the issue is a bit hard to reproduce, I'm wondering, if that patch
already fixes the problem or if it's a new issue.

[  164.668498] PM: Syncing filesystems ... done.
[  164.691406] Freezing user space processes ... (elapsed 0.003 seconds)
done.
[  164.702717] Freezing remaining freezable tasks ... (elapsed 0.002
seconds) done.
[  174.587750] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout
cmd id = 0x6, act = 0x3
[  174.596872] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
[  174.602970] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
[  174.608975] mwifiex_sdio mmc0:0001:1: is_cmd_timedout = 1
[  174.614620] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
[  174.620171] mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
[  174.625725] mwifiex_sdio mmc0:0001:1: last_cmd_id: 06 00 06 00 06 00 06
00 06 00
[  174.633453] mwifiex_sdio mmc0:0001:1: last_cmd_act: 03 00 03 00 03 00 03
00 03 00
[  174.641271] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 2
[  174.647276] mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 06 80 06 80 06
80 06 80 06 80
[  174.655456] mwifiex_sdio mmc0:0001:1: last_event_index = 0
[  174.661189] mwifiex_sdio mmc0:0001:1: last_event: 0a 00 17 00 2b 00 0a
00 0b 00
[  174.668826] mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=0
[  174.674743] mwifiex_sdio mmc0:0001:1: ps_mode=1 ps_state=0
[  174.681867] mwifiex_sdio mmc0:0001:1: cmd timeout
[  174.689400] mwifiex_sdio mmc0:0001:1: === DRIVER INFO DUMP START===
[  174.696670] mwifiex_sdio mmc0:0001:1: SDIO register DUMP START
[  174.717782] mwifiex_sdio mmc0:0001:1: None of the WOWLAN triggers enabled
[  174.726453] mwifiex_sdio: Resetting card...
[  184.727059] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout
cmd id = 0x28, act = 0x13
[  184.736357] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
[  184.742456] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
[  184.748461] mwifiex_sdio mmc0:0001:1: is_cmd_timedout = 1
[  184.754103] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
[  184.759654] mwifiex_sdio mmc0:0001:1: last_cmd_index = 1
[  184.765209] mwifiex_sdio mmc0:0001:1: last_cmd_id: 28 00 28 00 06 00 06
00 24 00
[  184.772937] mwifiex_sdio mmc0:0001:1: last_cmd_act: 13 00 13 00 03 00 03
00 24 65
[  184.780754] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 4
[  184.786760] mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 06 80 06 80 06
80 24 80 28 80
[  184.794940] mwifiex_sdio mmc0:0001:1: last_event_index = 0
[  184.800672] mwifiex_sdio mmc0:0001:1: last_event: 0a 00 17 00 2b 00 0a
00 0b 00
[  184.808310] mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=1
[  184.814225] mwifiex_sdio mmc0:0001:1: ps_mode=1 ps_state=0
[  184.819988] mwifiex_sdio mmc0:0001:1: cmd timeout
[  184.825005] ieee80211 phy0: deleting the crypto keys
