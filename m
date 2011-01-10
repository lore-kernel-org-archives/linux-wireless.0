Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:2907 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224Ab1AJHaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 02:30:55 -0500
Message-ID: <4D2AB5AD.10201@gmail.com>
Date: Mon, 10 Jan 2011 08:30:53 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Aleksandar Milivojevic <alex@milivojevic.org>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Wolfgang Kufner <wolfgang.kufner@gmail.com>,
	Luis Correia <buga@loide.net>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
References: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>	<20110107202224.GI21588@tux>	<AANLkTintU_vSt5eWoma4_d9tNCxPpOfpGZMq7XXppjpP@mail.gmail.com>	<201101081047.18475.helmut.schaa@googlemail.com> <AANLkTimDW2i1iKHG50__2BOYyvyWiii2eWVOP2HjkxtR@mail.gmail.com>
In-Reply-To: <AANLkTimDW2i1iKHG50__2BOYyvyWiii2eWVOP2HjkxtR@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/11 08:12, Aleksandar Milivojevic wrote:
> On Sat, Jan 8, 2011 at 1:47 AM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
>> Am Samstag, 8. Januar 2011 schrieb Aleksandar Milivojevic:
>>> Running 'iw event -t' shows a lot of disassociation due to inactivity.
>>>  This happens even if there is regular flow of traffic (for example, I
>>> start ping to my AP and leave it running, or I leave Pandora streaming
>>> music in the browser).
>>>
>>> Below is example of output of 'iw event -t' (these lines repeat in the
>>> output at irregularl intervals):
>>>
>>> 1294464037.037450: wlan0 (phy #0): deauth 00:1c:10:ea:2a:cb ->
>>> 00:1e:52:79:e9:ff reason 4: Disassociated due to inactivity
>>> 1294464037.037538: wlan0 (phy #0): disconnected (local request)
>>
>> Aha, so it's not the AP disassociating you but it's your client disconnecting
>> on its own. Mind to provide the wpa_supplicant log for the same situation when
>> run with "-ddt"?
> 
> Normally, I use NetworkManager, so all of wpa_supplican is kind of
> hidden under the hood.  For this, I stopped NetworkManager, and
> created following simple wpa_supplicant config file:
> 
> # WPA-PSK/TKIP
> ctrl_interface=/var/run/wpa_supplicant
> network={
>   ssid="MySSID"
>   scan_ssid=1
>   key_mgmt=WPA-PSK
>   psk="MyGreatSecret"
> }
> 
> Run wpa_supplicant by hand as "wpa_supplicant
> -c/path/to/my/wpa_supplicant.conf -iwlan0 -ddt".  The log is rather
> big, however I guess interesting part (if there's anything interesting
> there) is at the point where connection got dropped.  In
> /var/log/debug, I found following logged by the kernel (same as in
> previous logs I posted):
> 
> Jan  9 22:37:17 toporko kernel: [ 3152.500035] ieee80211 phy0: wlan0:
> No probe response from AP 00:1e:52:79:e9:ff after 500ms,
> disconnecting.
> Jan  9 22:37:19 toporko kernel: [ 3154.138808] cfg80211: All devices
> are disconnected, going to restore regulatory settings
> 
> The output of wpa_supplicant was quiet until above "no probe response"
> was logged by the kernel (1294641437 timestamp corresponds to 22:37:17
> local time):
> 
> 1294641437.407476: RTM_NEWLINK: operstate=1 ifi_flags=0x1003 ([UP])
> 1294641437.407493: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> 1294641439.045890: RTM_NEWLINK: operstate=1 ifi_flags=0x1003 ([UP])
> 1294641439.045908: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> 1294641439.045913: Wireless event: cmd=0x8b15 len=20
> 1294641439.045916: Wireless event: new AP: 00:00:00:00:00:00
> 1294641439.045930: Setting scan request: 0 sec 100000 usec
> 1294641439.045938: Added BSSID 00:1e:52:79:e9:ff into blacklist
> 1294641439.045944: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> 1294641439.045947: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0
> seq_len=0 key_len=0
> 1294641439.045966: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0
> seq_len=0 key_len=0
> 1294641439.045976: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0
> seq_len=0 key_len=0
> 1294641439.045984: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0
> seq_len=0 key_len=0
> 1294641439.045993: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0
> seq_len=0 key_len=0
> 1294641439.046001: State: COMPLETED -> DISCONNECTED
> 1294641439.046007: wpa_driver_wext_set_operstate: operstate 1->0 (DORMANT)
> 1294641439.046010: WEXT: Operstate: linkmode=-1, operstate=5
> 1294641439.046027: EAPOL: External notification - portEnabled=0
> 1294641439.046032: EAPOL: SUPP_PAE entering state DISCONNECTED
> 1294641439.046034: EAPOL: SUPP_BE entering state INITIALIZE
> 1294641439.046038: EAPOL: External notification - portValid=0
> 1294641439.046041: EAPOL: External notification - EAP success=0
> 1294641439.146109: State: DISCONNECTED -> SCANNING
> 1294641439.146128: Starting AP scan (broadcast SSID)
> 1294641439.148479: Scan requested (ret=0) - scan timeout 30 seconds
> 
> And the following lines look just like standard
> scan/authentication/association thing...  Not sure if anything of the
> above is of any use...

Am I correct in that you are using TKIP encryption on your wireless network?

Please note that there currently is a bug in rt2800usb/rt2800pci where TKIP
hardware encryption is not working at all, and we haven't been able to track
that bug down yet.

Can you try to switch your network to AES encryption, or load the rt2800usb
driver with nohwcrypt module parameter enabled, and check what happens?

--
Gertjan
