Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:33254 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755245Ab3CMDGX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 23:06:23 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 12 Mar 2013 20:04:30 -0700
Subject: RE: mwifiex crash when removing interface while scanning
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D9C2199@SC-VEXCH1.marvell.com> (sfid-20130313_040628_225081_FE726C18)
References: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE6CD@SC-VEXCH1.marvell.com>
	<CAMLZHHRmd+Yfr_72HdfNd+knPJg8KvuAA2WrC0TC0wQ8pOeMeA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE95B@SC-VEXCH1.marvell.com>
	<CAMLZHHR+OCQd_2J8NkmK0CND9vo6VaT73L+rJKJRk7bUknh7Qw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CEC9D@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D9C1608@SC-VEXCH1.marvell.com>
 <CAMLZHHQyTDHD8q=Q-edSew+KnpaGWOaVwxiK_fjABG9ZC9g-Qg@mail.gmail.com>
In-Reply-To: <CAMLZHHQyTDHD8q=Q-edSew+KnpaGWOaVwxiK_fjABG9ZC9g-Qg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> Hi,
> 
> On Thu, Mar 7, 2013 at 11:00 PM, Bing Zhao <bzhao@marvell.com> wrote:
> > Running your test script on my XO-4 with 3.8 kernel does reproduce command timeout.
> > Although the timeout happens at different path than yours they could have the same cause.
> >
> > Attached please find two patches that seems fix the FUNC_SHUTDOWN timeout on my XO-4.
> > Hope it helps.
> 
> Thanks, this seems like an improvement.
> With NetworkManager disabled, I can now run the original test script
> in a loop, and after a few minutes it is still running.

Good to know it improves.

> 
> I still see this message:
>     mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0, cmd_pending=-1
> (cmd_pending is sometimes -2 as well).
> Does this suggest a leak?

Yeah, I also noticed this. I will check.

> 
> Even after these patches it still seems easy to confuse this driver
> with just a trivial setup. Here's one example:
> 
> NetworkManager enabled again, clean reboot, using test.sh from the
> first mail, the following failure seems 100% reproducible:
> 

[...]

> [   24.092789] mwifiex_sdio mmc0:0001:1: DNLD_CMD: FW in reset state,
> ignore cmd 0x6
> [   24.101801] mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0,
> cmd_pending=-2
> 
> I guess the scan did not succeed there because NetworkManager was
> scanning. No problem, things look OK (apart from the last 2 messages
> which seem a little concerning).

The "FW in reset state, ignore cmd 0x06" message is correct. During driver/firmware shutdown process we must skip these commands.

> 
> Now lets load the module manually and do a scan:
> 
> # insmod mwifiex_sdio.ko
> [   26.639096] lis3lv02d_i2c 4-0019: Failed to get supply 'Vdd': -517
> [   26.645260] i2c 4-0019: Driver lis3lv02d_i2c requests probe deferral
> [   26.656082] mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
> [   26.666128] mwifiex_sdio mmc0:0001:1: WLAN FW is active
> [   26.777635] mwifiex_sdio mmc0:0001:1: ignoring F/W country code US
> [   26.798631] mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0
> (14.66.9.p96)
> [   26.862487] systemd-udevd[235]: renamed network interface mlan0 to eth0
> [   27.129054] ieee80211 phy2: uap0: changing to 2 not supported
> [   27.168360] ieee80211 phy2: uap0: changing to 2 not supported
> [   27.196832] ieee80211 phy2: uap0: changing to 2 not supported
> [   27.216715] ieee80211 phy2: uap0: changing to 2 not supported
> [   27.239068] ieee80211 phy2: uap0: changing to 2 not supported
> 
> # iwlist eth0 scan
> eth0      Interface doesn't support scanning : Device or resource busy
> 
> OK, NetworkManager is scanning. I keep trying this every few seconds:
> 
> # iwlist eth0 scan
> eth0      Interface doesn't support scanning : Device or resource busy
> # iwlist eth0 scan
> eth0      Interface doesn't support scanning : Device or resource busy
> # iwlist eth0 scan
> eth0      Interface doesn't support scanning : Device or resource busy
> # iwlist eth0 scan
> [   49.567711] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func:
> Timeout cmd id (49.555599) = 0x6, act = 0x3

Tim Shepard reported a scan timeout issue back in kernel 3.5 when NetworkManager is enabled, and he had a HACK workaround for that. I wonder if this is the same issue in 3.8.
Could you please try that workaround again?

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifie
index 121443a..a451d18 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -364,6 +364,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware
                goto err_add_intf;
        }

+#if 0
        /* Create AP interface by default */
        if (!mwifiex_add_virtual_intf(adapter->wiphy, "uap%d",
                                      NL80211_IFTYPE_AP, NULL, NULL)) {
@@ -377,6 +378,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware
                dev_err(adapter->dev, "cannot create default P2P interface\n")
                goto err_add_intf;
        }
+#endif
        rtnl_unlock();

        mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);

Thanks,
Bing

