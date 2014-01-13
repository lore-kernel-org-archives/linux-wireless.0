Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:24207 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbaAMOht (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 09:37:49 -0500
Message-ID: <52D3F962.1010302@neratec.com> (sfid-20140113_153803_177619_C34CF924)
Date: Mon, 13 Jan 2014 15:34:10 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>	<1384665016-12022-5-git-send-email-sujith@msujith.org>	<52CE934D.1020400@neratec.com>	<21198.40916.260973.48444@gargle.gargle.HOWL>	<52CEA5A3.2040308@neratec.com> <21198.43395.235654.597422@gargle.gargle.HOWL> <52CEAB24.5090700@neratec.com>
In-Reply-To: <52CEAB24.5090700@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2014 02:59 PM, Wojciech Dubowik wrote:
> On 01/09/2014 02:52 PM, Sujith Manoharan wrote:
>> Wojciech Dubowik wrote:
>>> AR9590 running on powerpc with latest openwrt i.e.
>>> compat-wireless-2013-11-05 backported with
>>> your changes for split pci/soc IQ calibration.
>>>
>>> I could try to reproduce it on my host with latest wireless testing if
>>> you think
>> It would also be good to know if this is a regression from this patch,
>> so checking an older version of the driver without this patch would 
>> help.
> It will take some time but I am on it.
I have done some tests with latest wireless testing and our own rf card. 
It seems
that 13-15dB is the difference between nominal NF(-115) and measured -101.
When device goes scanning and it returns back to the channel it 
"forgets" about
old noise histogram and sets it to default. Then all the packets will 
have wrong
rssi until next noise floor calibration occurs.
Below I have a log with custom printk to show the problem.

I think the only solution ot this problem is to use noise floor 
calibration from ART
and apply this when available instead of default value.

Br,
Wojtek

Jan 13 15:16:06 wlanTS kernel: [21498.975369] ath_rx_tasklet:1361 
04:f0:21:04:56:9d 29
Jan 13 15:16:06 wlanTS kernel: [21498.990727] ath_rx_tasklet:1361 
04:f0:21:04:56:9d 24
Jan 13 15:16:06 wlanTS kernel: [21499.000331] ath9k_hw_loadnf:261 
writing nfval[0]=-101 for 5180
Jan 13 15:16:06 wlanTS kernel: [21499.000335] ath9k_hw_loadnf:261 
writing nfval[1]=-101 for 5180
Jan 13 15:16:06 wlanTS kernel: [21499.000342] ath9k_hw_loadnf:325 
writing -50 to MAX CCA[0]
Jan 13 15:16:06 wlanTS kernel: [21499.000344] ath9k_hw_loadnf:325 
writing -50 to MAX CCA[1]
Jan 13 15:16:06 wlanTS kernel: [21499.001842] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 39
Jan 13 15:16:06 wlanTS kernel: [21499.006096] ath_rx_tasklet:1361 
04:f0:21:04:56:9d 23
Jan 13 15:16:06 wlanTS kernel: [21499.016065] ath_rx_tasklet:1361 
04:f0:21:04:56:90 8
Jan 13 15:16:06 wlanTS kernel: [21499.017203] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 39
Jan 13 15:16:06 wlanTS kernel: [21499.021446] ath_rx_tasklet:1361 
04:f0:21:04:56:9d 22
Jan 13 15:16:06 wlanTS kernel: [21499.027139] ath_rx_tasklet:1361 
04:f0:21:04:56:9d 21
Jan 13 15:16:06 wlanTS kernel: [21499.027158] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 38
Jan 13 15:16:06 wlanTS kernel: [21499.027164] ath_rx_tasklet:1361 
04:f0:21:04:56:90 8
Jan 13 15:16:06 wlanTS kernel: [21499.031424] ath_rx_tasklet:1361 
04:f0:21:04:56:90 6
Jan 13 15:16:06 wlanTS kernel: [21499.032564] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 40
Jan 13 15:16:06 wlanTS kernel: [21499.036806] ath_rx_tasklet:1361 
04:f0:21:04:56:9d 24
Jan 13 15:16:06 wlanTS kernel: [21499.046786] ath_rx_tasklet:1361 
04:f0:21:04:56:90 8
Jan 13 15:16:06 wlanTS kernel: [21499.047925] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 38
Jan 13 15:16:06 wlanTS kernel: [21499.052167] ath_rx_tasklet:1361 
04:f0:21:04:56:9d 24
Jan 13 15:16:06 wlanTS kernel: [21499.053715] ath9k_hw_loadnf:261 
writing nfval[0]=-115 for 5200
Jan 13 15:16:06 wlanTS kernel: [21499.053719] ath9k_hw_loadnf:261 
writing nfval[1]=-115 for 5200
Jan 13 15:16:06 wlanTS kernel: [21499.053726] ath9k_hw_loadnf:325 
writing -50 to MAX CCA[0]
Jan 13 15:16:06 wlanTS kernel: [21499.053728] ath9k_hw_loadnf:325 
writing -50 to MAX CCA[1]
Jan 13 15:16:06 wlanTS kernel: [21499.111587] ath9k_hw_loadnf:261 
writing nfval[0]=-101 for 5180
Jan 13 15:16:06 wlanTS kernel: [21499.111590] ath9k_hw_loadnf:261 
writing nfval[1]=-101 for 5180
Jan 13 15:16:06 wlanTS kernel: [21499.111598] ath9k_hw_loadnf:325 
writing -50 to MAX CCA[0]
Jan 13 15:16:06 wlanTS kernel: [21499.111600] ath9k_hw_loadnf:325 
writing -50 to MAX CCA[1]
Jan 13 15:16:06 wlanTS kernel: [21499.114936] ath9k_hw_loadnf:261 
writing nfval[0]=-115 for 5180
Jan 13 15:16:06 wlanTS kernel: [21499.114940] ath9k_hw_loadnf:261 
writing nfval[1]=-115 for 5180
Jan 13 15:16:06 wlanTS kernel: [21499.114947] ath9k_hw_loadnf:325 
writing -50 to MAX CCA[0]
Jan 13 15:16:06 wlanTS kernel: [21499.114949] ath9k_hw_loadnf:325 
writing -50 to MAX CCA[1]
Jan 13 15:16:06 wlanTS kernel: [21499.115050] wlan0: authenticate with 
04:f0:21:04:56:9e
Jan 13 15:16:06 wlanTS kernel: [21499.117677] ath9k_hw_loadnf:261 
writing nfval[0]=-115 for 5180
Jan 13 15:16:06 wlanTS kernel: [21499.117680] ath9k_hw_loadnf:261 
writing nfval[1]=-115 for 5180
Jan 13 15:16:06 wlanTS kernel: [21499.117687] ath9k_hw_loadnf:325 
writing -50 to MAX CCA[0]
Jan 13 15:16:06 wlanTS kernel: [21499.117689] ath9k_hw_loadnf:325 
writing -50 to MAX CCA[1]
Jan 13 15:16:06 wlanTS kernel: [21499.117788] wlan0: send auth to 
04:f0:21:04:56:9e (try 1/3)
Jan 13 15:16:06 wlanTS kernel: [21499.117875] cfg80211: All devices are 
disconnected, going to restore regulatory settings
Jan 13 15:16:06 wlanTS kernel: [21499.117877] cfg80211: Restoring 
regulatory settings
Jan 13 15:16:06 wlanTS kernel: [21499.117881] cfg80211: Kicking the queue
Jan 13 15:16:06 wlanTS kernel: [21499.117884] cfg80211: Calling CRDA to 
update world regulatory domain
Jan 13 15:16:06 wlanTS kernel: [21499.119510] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 53
Jan 13 15:16:06 wlanTS kernel: [21499.119548] wlan0: authenticated
Jan 13 15:16:06 wlanTS kernel: [21499.120918] wlan0: associate with 
04:f0:21:04:56:9e (try 1/3)
Jan 13 15:16:06 wlanTS kernel: [21499.121393] cfg80211: Ignoring 
regulatory request set by core since the driver uses its own custom 
regulatory domain
Jan 13 15:16:06 wlanTS kernel: [21499.121397] cfg80211: Ignoring 
regulatory request set by core since the driver uses its own custom 
regulatory domain
Jan 13 15:16:06 wlanTS kernel: [21499.121399] cfg80211: Ignoring 
regulatory request set by core since the driver uses its own custom 
regulatory domain
Jan 13 15:16:06 wlanTS kernel: [21499.121400] cfg80211: Ignoring 
regulatory request set by core since the driver uses its own custom 
regulatory domain
Jan 13 15:16:06 wlanTS kernel: [21499.121402] cfg80211: Ignoring 
regulatory request set by core since the driver uses its own custom 
regulatory domain
Jan 13 15:16:06 wlanTS kernel: [21499.121417] cfg80211: World regulatory 
domain updated:
Jan 13 15:16:06 wlanTS kernel: [21499.121418] cfg80211:  DFS Master 
region: unset
Jan 13 15:16:06 wlanTS kernel: [21499.121419] cfg80211: (start_freq - 
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan 13 15:16:06 wlanTS kernel: [21499.121421] cfg80211:   (2402000 KHz - 
2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 13 15:16:06 wlanTS kernel: [21499.121422] cfg80211:   (2457000 KHz - 
2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan 13 15:16:06 wlanTS kernel: [21499.121424] cfg80211:   (2474000 KHz - 
2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan 13 15:16:06 wlanTS kernel: [21499.121425] cfg80211:   (5170000 KHz - 
5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 13 15:16:06 wlanTS kernel: [21499.121426] cfg80211:   (5735000 KHz - 
5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 13 15:16:06 wlanTS kernel: [21499.122410] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 54
Jan 13 15:16:06 wlanTS kernel: [21499.122426] wlan0: RX AssocResp from 
04:f0:21:04:56:9e (capab=0x11 status=0 aid=1)
Jan 13 15:16:06 wlanTS kernel: [21499.122461] wlan0: associated
Jan 13 15:16:06 wlanTS kernel: [21499.122488] cfg80211: Calling CRDA for 
country: XA
Jan 13 15:16:06 wlanTS kernel: [21499.124318] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 54
Jan 13 15:16:06 wlanTS kernel: [21499.124337] cfg80211: Found new beacon 
on frequency: 5180 MHz (Ch 36) on phy0
Jan 13 15:16:06 wlanTS kernel: [21499.124346] cfg80211: Pending 
regulatory request, waiting for it to be processed...
Jan 13 15:16:06 wlanTS kernel: [21499.124998] ath_rx_tasklet:1361 
00:14:5a:02:10:2d 54
Jan 13 15:16:06 wlanTS kernel: [21499.125906] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 54
Jan 13 15:16:06 wlanTS kernel: [21499.128106] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 54
Jan 13 15:16:06 wlanTS kernel: [21499.140085] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 54
=>>> here rssi jumps 15dB
Jan 13 15:16:06 wlanTS kernel: [21499.155444] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 39
Jan 13 15:16:06 wlanTS kernel: [21499.170806] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 37
Jan 13 15:16:06 wlanTS kernel: [21499.186165] ath_rx_tasklet:1361 
04:f0:21:04:56:9e 40

>> Sujith
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

