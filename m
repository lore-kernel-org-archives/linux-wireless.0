Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:53344 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3CKUMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 16:12:09 -0400
Received: by mail-qc0-f179.google.com with SMTP id b40so1717911qcq.10
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2013 13:12:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9D9C1608@SC-VEXCH1.marvell.com>
References: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE6CD@SC-VEXCH1.marvell.com>
	<CAMLZHHRmd+Yfr_72HdfNd+knPJg8KvuAA2WrC0TC0wQ8pOeMeA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE95B@SC-VEXCH1.marvell.com>
	<CAMLZHHR+OCQd_2J8NkmK0CND9vo6VaT73L+rJKJRk7bUknh7Qw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CEC9D@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D9C1608@SC-VEXCH1.marvell.com>
Date: Mon, 11 Mar 2013 14:12:07 -0600
Message-ID: <CAMLZHHQyTDHD8q=Q-edSew+KnpaGWOaVwxiK_fjABG9ZC9g-Qg@mail.gmail.com> (sfid-20130311_211214_067632_6235B429)
Subject: Re: mwifiex crash when removing interface while scanning
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Mar 7, 2013 at 11:00 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Running your test script on my XO-4 with 3.8 kernel does reproduce command timeout.
> Although the timeout happens at different path than yours they could have the same cause.
>
> Attached please find two patches that seems fix the FUNC_SHUTDOWN timeout on my XO-4.
> Hope it helps.

Thanks, this seems like an improvement.
With NetworkManager disabled, I can now run the original test script
in a loop, and after a few minutes it is still running.

I still see this message:
    mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0, cmd_pending=-1
(cmd_pending is sometimes -2 as well).
Does this suggest a leak?

Even after these patches it still seems easy to confuse this driver
with just a trivial setup. Here's one example:

NetworkManager enabled again, clean reboot, using test.sh from the
first mail, the following failure seems 100% reproducible:

# bash test.sh
[   17.129827] lis3lv02d_i2c 4-0019: Failed to get supply 'Vdd': -517
[   17.136003] i2c 4-0019: Driver lis3lv02d_i2c requests probe deferral
[   17.915844] mwifiex_sdio mmc0:0001:1: WLAN FW is active
eth0: ERROR while getting interface flags: No such device
eth0      Interface doesn't support scanning.
[   18.407286] mwifiex_sdio mmc0:0001:1: ignoring F/W country code US
[   18.430167] mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0
(14.66.9.p96)
[   18.510658] systemd-udevd[235]: renamed network interface mlan0 to eth0

Oops - seems like my script doesn't wait long enough for the network
interface rename to happen, so that wasn't a complete test. This seems
to happen frequently on first run, but subsequent runs work better.
Lets run it again:

# bash test.sh
[   21.653722] mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
[   21.662303] lis3lv02d_i2c 4-0019: Failed to get supply 'Vdd': -517
[   21.673173] i2c 4-0019: Driver lis3lv02d_i2c requests probe deferral
[   21.681210] mwifiex_sdio mmc0:0001:1: WLAN FW is active
[   21.794164] mwifiex_sdio mmc0:0001:1: ignoring F/W country code US
[   21.807990] mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0
(14.66.9.p96)
[   21.893378] systemd-udevd[235]: renamed network interface mlan0 to eth0
[   21.984014] ieee80211 phy1: uap0: changing to 2 not supported
[   22.054609] ieee80211 phy1: uap0: changing to 2 not supported
[   22.095906] ieee80211 phy1: uap0: changing to 2 not supported
[   22.115854] ieee80211 phy1: uap0: changing to 2 not supported
[   22.146579] ieee80211 phy1: uap0: changing to 2 not supported
eth0      Interface doesn't support scanning : Device or resource busy
[   24.092789] mwifiex_sdio mmc0:0001:1: DNLD_CMD: FW in reset state,
ignore cmd 0x6
[   24.101801] mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0,
cmd_pending=-2

I guess the scan did not succeed there because NetworkManager was
scanning. No problem, things look OK (apart from the last 2 messages
which seem a little concerning).

Now lets load the module manually and do a scan:

# insmod mwifiex_sdio.ko
[   26.639096] lis3lv02d_i2c 4-0019: Failed to get supply 'Vdd': -517
[   26.645260] i2c 4-0019: Driver lis3lv02d_i2c requests probe deferral
[   26.656082] mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
[   26.666128] mwifiex_sdio mmc0:0001:1: WLAN FW is active
[   26.777635] mwifiex_sdio mmc0:0001:1: ignoring F/W country code US
[   26.798631] mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0
(14.66.9.p96)
[   26.862487] systemd-udevd[235]: renamed network interface mlan0 to eth0
[   27.129054] ieee80211 phy2: uap0: changing to 2 not supported
[   27.168360] ieee80211 phy2: uap0: changing to 2 not supported
[   27.196832] ieee80211 phy2: uap0: changing to 2 not supported
[   27.216715] ieee80211 phy2: uap0: changing to 2 not supported
[   27.239068] ieee80211 phy2: uap0: changing to 2 not supported

# iwlist eth0 scan
eth0      Interface doesn't support scanning : Device or resource busy

OK, NetworkManager is scanning. I keep trying this every few seconds:

# iwlist eth0 scan
eth0      Interface doesn't support scanning : Device or resource busy
# iwlist eth0 scan
eth0      Interface doesn't support scanning : Device or resource busy
# iwlist eth0 scan
eth0      Interface doesn't support scanning : Device or resource busy
# iwlist eth0 scan
[   49.567711] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func:
Timeout cmd id (49.555599) = 0x6, act = 0x3
[   49.577420] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
[   49.583240] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
[   49.588986] mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
[   49.588986] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
[   49.599612] mwifiex_sdio mmc0:0001:1: last_cmd_index = 0
[   49.604892] mwifiex_sdio mmc0:0001:1: last_cmd_id: 06 00 71 00 06
00 06 00 5e 00
[   49.612243] mwifiex_sdio mmc0:0001:1: last_cmd_act: 03 00 00 00 03
00 03 00 01 00
[   49.619683] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 4
[   49.619693] mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 12 80 71 80
06 80 06 80 5e 80
[   49.633176] mwifiex_sdio mmc0:0001:1: last_event_index = 3
[   49.638627] mwifiex_sdio mmc0:0001:1: last_event: 17 00 0a 00 08 00
17 00 17 00
[   49.645883] mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=1
[   49.651499] mwifiex_sdio mmc0:0001:1: ps_mode=1 ps_state=0
[   49.656950] mwifiex_sdio mmc0:0001:1: cmd timeout
[   49.661697] mwifiex_sdio: Resetting card...
[   49.676122] mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0,
cmd_pending=-4
[   49.683632] ieee80211 phy2: crypto keys added
[   49.689716] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
eth0      Interface doesn't support scanning : No such device
[   49.717762] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
[   49.808245] mmc0: card 0001 removed

...and the device doesn't come back.

Daniel
