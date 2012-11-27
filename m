Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35547 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320Ab2K0KWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 05:22:52 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so6601986lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 02:22:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D1367C74B@SC-VEXCH1.marvell.com>
References: <1351820654-24433-1-git-send-email-bzhao@marvell.com>
	<CAMXE1-ptP5hEK_Bn4wU5jykcXxcpKf9uj4tR8gz5Cfp873iHvQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D1367C74B@SC-VEXCH1.marvell.com>
Date: Tue, 27 Nov 2012 12:22:49 +0200
Message-ID: <CAMXE1-rML8AkR17pqj8Z862R6BEu+Eq0EQLeNV3PanykR0Q03g@mail.gmail.com> (sfid-20121127_112302_918939_E23558A1)
Subject: Re: [PATCH] mwifiex: add support for SDIO card reset
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Tim Shepard <shep@laptop.org>, Daniel Drake <dsd@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On Tue, Nov 27, 2012 at 3:09 AM, Bing Zhao <bzhao@marvell.com> wrote:
>> On Fri, Nov 2, 2012 at 3:44 AM, Bing Zhao <bzhao@marvell.com> wrote:
>> > From: Amitkumar Karwar <akarwar@marvell.com>
>> >
>> > When command timeout happens due to a bug in firmware/hardware,
>> > the timeout handler just prints some debug information. User is
>> > unable to reload the driver in this case.
>> >
>> > Inspired by 9a821f5 "libertas: add sd8686 reset_card support",
>> > this patch adds card reset support for SDIO interface when
>> > command timeout happens. If the SDIO host contoller supports
>> > MMC_POWER_OFF|UP|ON operations, the chip will be reset and the
>> > firmware will be re-downloaded.
>>
>> After this patch my board started to reset itself frequently. Before I have seen
>> warnings but it was working (somehow).
>
> Are the command timeout warnings the same with and without this patch applied?
> Could you please revert this patch and generate a log with the warnings shown but still working?

I actually reverted the patch and I see warnings but the board seems
to be working
(at least Bluetooth + WIFI AMP). I see following messages:

<lots of wifi regulatory spam here >
.....
[ 5554.082703] mwifiex_sdio mmc0:0001:1: ignoring F/W country code US
[ 5554.096694] mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0
(14.66.9.p96)
[ 5554.353287] ieee80211 phy1: uap0: changing to 2 not supported
[ 5554.354125] ieee80211 phy1: uap0: changing to 2 not supported
[ 5554.355429] ieee80211 phy1: uap0: changing to 2 not supported
[ 5554.355492] ieee80211 phy1: uap0: changing to 2 not supported
[ 5554.356275] ieee80211 phy1: uap0: changing to 2 not supported
[ 5556.932508] cfg80211: Found new beacon on frequency: 2472 MHz (Ch 13) on phy1
[ 5559.907548] cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on phy1
[ 5560.403407] cfg80211: Found new beacon on frequency: 5220 MHz (Ch 44) on phy1
[ 5567.407174] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[ 5567.407178] Bluetooth: BNEP filters: protocol multicast
[ 5567.407209] Bluetooth: BNEP socket layer initialized
[ 5697.022102] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func:
Timeout cmd id (1354009998.573301) = 0x6, act = 0x3
[ 5697.022116] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
[ 5697.022122] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
[ 5697.022127] mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
[ 5697.022132] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
[ 5697.022137] mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
[ 5697.022144] mwifiex_sdio mmc0:0001:1: last_cmd_id: 06 00 06 00 06
00 06 00 06 00
[ 5697.022149] mwifiex_sdio mmc0:0001:1: last_cmd_act: 03 00 03 00 03
00 03 00 03 00
[ 5697.022154] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 2
[ 5697.022159] mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 06 80 06 80
06 80 06 80 06 80
[ 5697.022164] mwifiex_sdio mmc0:0001:1: last_event_index = 2
[ 5697.022169] mwifiex_sdio mmc0:0001:1: last_event: 0a 00 0b 00 0a 00
0a 00 0b 00
[ 5697.022175] mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=1
[ 5697.022180] mwifiex_sdio mmc0:0001:1: ps_mode=1 ps_state=0
....
[ 6381.253112] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func:
Timeout cmd id (1354010683.21145) = 0x6, act = 0x3
[ 6381.253125] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
[ 6381.253131] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
[ 6381.253136] mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 2
[ 6381.253141] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
[ 6381.253146] mwifiex_sdio mmc0:0001:1: last_cmd_index = 4
[ 6381.253152] mwifiex_sdio mmc0:0001:1: last_cmd_id: 06 00 06 00 06
00 06 00 06 00
[ 6381.253157] mwifiex_sdio mmc0:0001:1: last_cmd_act: 03 00 03 00 03
00 03 00 03 00
[ 6381.253162] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 3
[ 6381.253167] mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 06 80 06 80
06 80 06 80 06 80
[ 6381.253173] mwifiex_sdio mmc0:0001:1: last_event_index = 3
[ 6381.253178] mwifiex_sdio mmc0:0001:1: last_event: 0a 00 0b 00 0a 00
0b 00 0b 00
[ 6381.253183] mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=0
[ 6381.253189] mwifiex_sdio mmc0:0001:1: ps_mode=1 ps_state=1
[ 6408.880560] mwifiex_sdio mmc0:0001:1: CMD_RESP: cmd 0x6 error, result=0x4
...

>> [ 7402.431601] ieee80211 phy12: uap0: changing to 2 not supported
>> [ 7402.432234] Bluetooth: Skip incorrect packet: hdrlen 3077 buffer 64
>> [ 7412.436879] Bluetooth: hci1 command tx timeout
>> [ 7412.468830] Bluetooth: hci0 command tx timeout
>
> Here the Bluetooth driver btmrvl timed out before WLAN driver got the timeout.
> Since the patch takes effect only after mwifiex times out, I assume that btmrvl timeout also happens without this patch.
>
> I only tested the patch with the timeout triggered by mwifiex driver. I will try to reproduce the btmrvl driver timeout on my setup. If you have a way to recreate btmrvl timeout quickly please let me know.

Just insert the board and wait some time or make "hcitool scan".

Regards,
Andrei
