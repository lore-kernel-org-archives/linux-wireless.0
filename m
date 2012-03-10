Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:54698 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630Ab2CJEjN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 23:39:13 -0500
From: Bing Zhao <bzhao@marvell.com>
To: harvey yang <harvey.huawei.yang@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>
Date: Fri, 9 Mar 2012 20:35:45 -0800
Subject: RE: [PROBLEM] linux-3.2.7:mwifiex:when associating with ap ,there
 are some strange warning
Message-ID: <477F20668A386D41ADCC57781B1F70430836908BEF@SC-VEXCH1.marvell.com> (sfid-20120310_053937_618906_E3D76763)
References: <477F20668A386D41ADCC57781B1F70430836908BE9@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430836908BE9@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Harvey,

I probably lost your original Cc list because I accidentally erased the original e-mail forwarded by the vger.kernel.org.

I re-constructed this e-mail by copy-n-paste the contents from
http://marc.info/?l=linux-wireless&m=133117474214802


> From: harvey yang
> Message-ID: CAFCUKTSFuOzywY3F8TLUx67P776T_jhjhUEMb3MQ679yeyTnJw () mail ! gmail ! com
> 
> 
> Hi, all
> I compiled linux-3.2.7 with mwifiex as a module. When associating with
> ap, the process is slow with some strange output . Afte that
> "iwconfig" hangs up with no return .The fowllowing is my operation and
> console ouput.
> 
> [root@FriendlyARM /home]# wpa_supplicant -B -Dwext -imlan0 -c ./wpa_supplicant_W
> PAPSKCCMP.conf

mwifiex driver doesn't support Wireless Extensions. It supports CFG80211/NL80211 interface only.

Could you please try with "-Dnl80211"?

> mwifiex_sdio mmc1:0001:1: assoc: requested bss not found in scan results
> ioctl[SIOCSIWESSID]: Bad address

Supposedly all SIOCSIW* ioctls should fail with error "Operation not supported".
What version of wpa_supplicant are you using?

> [root@FriendlyARM /home]# mwifiex_sdio mmc1:0001:1: assoc: requested bss not fos
> cfg80211: Calling CRDA to update world regulatory domain
> 
> [root@FriendlyARM /home]# iwconfig

iwconfig should return something like:

mlan0	no wireless extensions.

> mwifiex_sdio mmc1:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id (995.180008)0
> mwifiex_sdio mmc1:0001:1: num_data_h2c_failure = 0
> mwifiex_sdio mmc1:0001:1: num_cmd_h2c_failure = 0
> mwifiex_sdio mmc1:0001:1: num_cmd_timeout = 1
> mwifiex_sdio mmc1:0001:1: num_tx_timeout = 0
> mwifiex_sdio mmc1:0001:1: last_cmd_index = 1
> mwifiex_sdio mmc1:0001:1: last_cmd_resp_index = 0
> mwifiex_sdio mmc1:0001:1: last_event_index = 4
> mwifiex_sdio mmc1:0001:1: data_sent=0 cmd_sent=0
> mwifiex_sdio mmc1:0001:1: ps_mode=1 ps_state=0

One driver command timed out here. We need to debug to find out the cause.

Could you please enable dynamic debug and collect some debug log to me?

In kernel .config file:
CONFIG_DYNAMIC_DEBUG=y

Re-compile the whole kernel tree, install and reboot. Before running wpa_supplicant, turn on debug:

mkdir /tmp/debug
mount -t debugfs debugfs /tmp/debug
echo "module mwifiex +p" > /tmp/debug/dynamic_debug/control
echo "module mwifiex_sdio +p" > /tmp/debug/dynamic_debug/control

cat /tmp/debug/mwifiex/mlan0/info

After command timeout happens,

cat /tmp/debug/mwifiex/mlan0/debug

Thanks,
Bing

> 
> This is my wpa_supplicant_WPAPSKCCMP.conf.
> ctrl_interface=/var/run/wpa_supplicant
> 
> network={
>     ssid="sherry"
>     key_mgmt=WPA-PSK
>     proto=WPA2
>     pairwise=CCMP
>     group=CCMP
>     psk="010203040506"
> }
> 
> What is the problem? any help will be appreciated.
> 
> Best Regards
> 
> harvey
