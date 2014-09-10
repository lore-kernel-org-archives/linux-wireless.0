Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:57334 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaIJOPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 10:15:11 -0400
Message-ID: <54105CE9.1030004@broadcom.com> (sfid-20140910_161517_737272_CF696A85)
Date: Wed, 10 Sep 2014 16:15:05 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: P2P_DEVICE support in Android KitKat
References: <540FFDFD.2070302@broadcom.com> <20140910111040.GA5269@w1.fi>
In-Reply-To: <20140910111040.GA5269@w1.fi>
Content-Type: multipart/mixed;
	boundary="------------070100010106090507000807"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------070100010106090507000807
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 09/10/14 13:10, Jouni Malinen wrote:
> On Wed, Sep 10, 2014 at 09:30:05AM +0200, Arend van Spriel wrote:
>> I am running some tests on a haswell target with Android KitKat
>> (3.10.20 kernel). In this configuration our brcmfmac driver is used
>> with driver param 'p2p_device=1'. So we end up with wlan0 and
>> p2p-dev-wlan0 interfaces (can blame myself for that). The
>> configuration has a network configured, but I did not expect
>> wpa_supplicant to start association using the p2p device interface.
>> The wlan0 interface is already connected to the AP. How can I fix
>> this to assure p2p-dev-wlan0 is only used for p2p management
>> scenarios.
>
> Hmm.. Can you please show the wpa_supplicant command line that is used
> here and describe how that network block gets configured for the
> p2p-dev-wlan0 "interface"? I would have expected that there would never
> be a configuration with an enabled network block being passed for the
> P2P management interface.. Internally, wpa_supplicant should not add
> such for P2P groups, but I don't think there is any filtering on
> configuration if something is externally trying to make wpa_supplicant
> use that management interface for a station mode connection.

Hi Jouni,

Jithu informed me about the '-m' command line option so digging in git 
revision history I found the commit from Ilan which kind of describes 
what I am seeing

c16a759 wpa_supplicant: Add a configuration file for the P2P_DEVICE 
parameters

Here is p2p_supplicant service instantiating the wpa_supplicant.

service p2p_supplicant /system/bin/wpa_supplicant -Dnl80211 -iwlan0 \
   -g@android:wpa_wlan0 -c/data/misc/wifi/p2p_supplicant.conf -dt

The p2p_supplicant.conf has update_config=1 set which is also mentioned 
in the commit message. Without -m option p2p-dev-wlan0 is created using 
the same config file as for wlan0 so some filtering would be required 
(or use -m).

Regards,
Arend

--------------070100010106090507000807
Content-Type: text/plain; name="p2p_supplicant.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="p2p_supplicant.conf"

ctrl_interface=/data/misc/wifi/sockets
update_config=1
driver_param=use_p2p_group_interface=1p2p_device=1
eapol_version=1
ap_scan=1
fast_reauth=1
device_name=BRIX-t1
device_type=10-0050F204-1
config_methods=keypad display push_button


--------------070100010106090507000807--
