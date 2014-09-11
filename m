Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:11405 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaIKJ5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 05:57:21 -0400
Message-ID: <541171FE.9070306@broadcom.com> (sfid-20140911_115725_178664_A77CE552)
Date: Thu, 11 Sep 2014 11:57:18 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: P2P_DEVICE support in Android KitKat
References: <540FFDFD.2070302@broadcom.com> <20140910111040.GA5269@w1.fi> <54105CE9.1030004@broadcom.com>
In-Reply-To: <54105CE9.1030004@broadcom.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-09-14 16:15, Arend van Spriel wrote:
> On 09/10/14 13:10, Jouni Malinen wrote:
>> On Wed, Sep 10, 2014 at 09:30:05AM +0200, Arend van Spriel wrote:
>>> I am running some tests on a haswell target with Android KitKat
>>> (3.10.20 kernel). In this configuration our brcmfmac driver is used
>>> with driver param 'p2p_device=1'. So we end up with wlan0 and
>>> p2p-dev-wlan0 interfaces (can blame myself for that). The
>>> configuration has a network configured, but I did not expect
>>> wpa_supplicant to start association using the p2p device interface.
>>> The wlan0 interface is already connected to the AP. How can I fix
>>> this to assure p2p-dev-wlan0 is only used for p2p management
>>> scenarios.
>>
>> Hmm.. Can you please show the wpa_supplicant command line that is used
>> here and describe how that network block gets configured for the
>> p2p-dev-wlan0 "interface"? I would have expected that there would never
>> be a configuration with an enabled network block being passed for the
>> P2P management interface.. Internally, wpa_supplicant should not add
>> such for P2P groups, but I don't think there is any filtering on
>> configuration if something is externally trying to make wpa_supplicant
>> use that management interface for a station mode connection.
> 
> Hi Jouni,
> 
> Jithu informed me about the '-m' command line option so digging in git
> revision history I found the commit from Ilan which kind of describes
> what I am seeing
> 
> c16a759 wpa_supplicant: Add a configuration file for the P2P_DEVICE
> parameters
> 
> Here is p2p_supplicant service instantiating the wpa_supplicant.
> 
> service p2p_supplicant /system/bin/wpa_supplicant -Dnl80211 -iwlan0 \
>   -g@android:wpa_wlan0 -c/data/misc/wifi/p2p_supplicant.conf -dt
> 
> The p2p_supplicant.conf has update_config=1 set which is also mentioned
> in the commit message. Without -m option p2p-dev-wlan0 is created using
> the same config file as for wlan0 so some filtering would be required
> (or use -m).

Although the -m may work it feels somewhat awkward. My idea behind the
P2P_DEVICE functionality was to have simpler command line with just the
primary interface and a single configuration file. With that in mind I
created a patch filtering the networks so they do not get enabled for
the P2P_DEVICE interface. That seems to be working, but I will do some
more testing with it.

Regards,
Arend

