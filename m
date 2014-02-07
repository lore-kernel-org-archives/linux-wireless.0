Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:53298 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaBGKLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 05:11:37 -0500
Received: by mail-oa0-f53.google.com with SMTP id m1so3812977oag.26
        for <linux-wireless@vger.kernel.org>; Fri, 07 Feb 2014 02:11:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140131121621.GA19138@redhat.com>
References: <20140117100613.GD1425@redhat.com>
	<A411C6B4-8474-47AC-97E1-0D92B24EB675@gmail.com>
	<1390133995.6945.11.camel@X1Carbon.localdomain>
	<03574886-F38F-461C-97FC-B10DCCCF30E8@gmail.com>
	<52DC1761.9080608@openwrt.org>
	<CABikg9zdW7GjaaghfW3fLcPKEiF0-3P5Ht2DY9hx6r0-XcguRw@mail.gmail.com>
	<20140120185044.GA1682@redhat.com>
	<CABikg9y_jd6TWGGN09edqabXboO9VoBTPUtLWFyWZjfSr6dnqg@mail.gmail.com>
	<20140122162522.GA10630@redhat.com>
	<CABikg9w7JjdeD7EU1cw9A-aARddDigDZzaxoL5yk6YeFtJB4hw@mail.gmail.com>
	<20140131121621.GA19138@redhat.com>
Date: Fri, 7 Feb 2014 11:11:36 +0100
Message-ID: <CABikg9y9gRgZyqhkBf=yq8rfQH+kgO1HEf1wfqVE2rdiEHRsSA@mail.gmail.com> (sfid-20140207_111142_577488_22F13278)
Subject: Re: USB rt2x00 driver regression
From: Sergei Antonov <saproj@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 January 2014 13:16, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Jan 29, 2014 at 06:45:31PM +0100, Sergei Antonov wrote:
>> > On older kernels "TX status timeout" messages were only enabled if
>> > kernel was compiled with CONFIG_RT2X00_DEBUG option , so perhaps
>> > that is the reason why you did not see them on older kernel with
>> > older firmware. But if really TX status timeouts start to happen after
>> > firmware update, we should fix our driver to better talk to the
>> > firmware, though I do not have idea how. If not, we should probably
>> > disable those messages in non-debug mode as it was on old kernels.
>>
>> Yes, it could have been due to CONFIG_RT2X00_DEBUG=n that I didn't
>> have warnings.
>
> I will move those annoying messages back to debug level, they are
> printed by default by mistake anyway.
>
>> The AP with which I have the warnings is another Linux computer with
>> hostapd-2.0. Can it be the cause of this "TX status" thing?
>
> It can be that AP does not ACK some frames for some reason and we see
> those warnings. Could you please provide me details about that AP (what
> H/W and driver is used and hostapd config file), I will see if I could
> reproduce those messages locally.

OK. The details about HW follow.

It's a PCI Ralink card with firmware file taken recently from linux-firmware:
===============================
ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 2872, rev 0200 detected
ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0003 detected
ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading firmware
file 'rt2860.bin'
ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware detected -
version: 0.34
===============================

The hostapd.conf:
===============================
interface=wlan0
driver=nl80211
ssid=myname

country_code=DE
hw_mode=g

channel=11

auth_algs=1
logger_syslog=-1
logger_syslog_level=3
logger_stdout=-1
logger_stdout_level=2
ignore_broadcast_ssid=0

wpa=2
wpa_key_mgmt=WPA-PSK
wpa_passphrase=*******
rsn_pairwise=CCMP

macaddr_acl=1
accept_mac_file=/etc/hostapd.accept
===============================

The kernel I originally used was 3.4. But I just upgraded it to 3.13.1
and the problem remains. Config values are:
CONFIG_RT2X00=y
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
CONFIG_RT2800PCI=y
# CONFIG_RT2800PCI_RT33XX is not set
# CONFIG_RT2800PCI_RT35XX is not set
# CONFIG_RT2800PCI_RT53XX is not set
CONFIG_RT2800PCI_RT3290=y
# CONFIG_RT2500USB is not set
# CONFIG_RT73USB is not set
# CONFIG_RT2800USB is not set
CONFIG_RT2800_LIB=y
CONFIG_RT2800_LIB_MMIO=y
CONFIG_RT2X00_LIB_MMIO=y
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_DEBUG=y
CONFIG_RTL_CARDS=y
