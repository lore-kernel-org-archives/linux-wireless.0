Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40215 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0DZIUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 04:20:42 -0400
Received: by wwb22 with SMTP id 22so223304wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 01:20:37 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1271883056.4381.1743.camel@rchatre-DESK>
References: <n2g2d0a357f1004170705j6d0750fdkc4784f86aab51c97@mail.gmail.com>
	 <1271782442.14052.19698.camel@rchatre-DESK>
	 <s2j2d0a357f1004210006gc964e5edl672ec5406b892a9@mail.gmail.com>
	 <1271883056.4381.1743.camel@rchatre-DESK>
Date: Mon, 26 Apr 2010 10:20:35 +0200
Message-ID: <m2s2d0a357f1004260120z30d8b3a3i2792cfa4bc390dcc@mail.gmail.com>
Subject: Re: iwl3945: Error sending REPLY_{RXON|SCAN_CMD|TX_PWR_TABLE_CMD}
	time out after 500ms
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

last weekend I could test a bit.

On Saturday, I tested with Linux-2.6.34-git4 and some additional
iwlwifi patches.
I used wpa_supplicant was (0.6.10-2) and wext driver.

I had only one issue with
linux-image-2.6.34-rc4-115-gdc57da3_2.6.34-rc4-115-gdc57da3.20100424~iniza.1_i386.deb
kernel:

...
/var/log/syslog.1-Apr 25 13:33:11 seduxbox wpa_supplicant[1732]: WPA:
Group rekeying completed with 00:04:0e:e4:00:3d [GTK=CCMP]
/var/log/syslog.1:Apr 25 13:59:56 seduxbox kernel: [59184.500070] No
probe response from AP 00:04:0e:e4:00:3d after 500ms, disconnecting.
/var/log/syslog.1-Apr 25 13:59:56 seduxbox kernel: [59184.505044]
cfg80211: Calling CRDA to update world regulatory domain
/var/log/syslog.1-Apr 25 13:59:56 seduxbox wpa_supplicant[1732]:
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
/var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717331]
cfg80211: World regulatory domain updated:
/var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717337]
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
/var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717343]
(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
/var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717349]
(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
/var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717355]
(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
/var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717361]
(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
/var/log/syslog.1-Apr 25 13:59:57 seduxbox kernel: [59185.717367]
(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
/var/log/syslog.1-Apr 25 13:59:59 seduxbox wpa_supplicant[1732]:
Trying to associate with 00:04:0e:e4:00:3d
(SSID='g00gle-street-knows-my-SSID-and-where-I-live' freq=2442 MHz)
/var/log/syslog.1-Apr 25 13:59:59 seduxbox kernel: [59187.753888]
wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
/var/log/syslog.1-Apr 25 13:59:59 seduxbox kernel: [59187.755614]
wlan0: authenticated
/var/log/syslog.1-Apr 25 13:59:59 seduxbox kernel: [59187.755649]
wlan0: associate with 00:04:0e:e4:00:3d (try 1)
/var/log/syslog.1-Apr 25 13:59:59 seduxbox kernel: [59187.760216]
wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0
aid=1)
/var/log/syslog.1-Apr 25 13:59:59 seduxbox kernel: [59187.760221]
wlan0: associated
/var/log/syslog.1-Apr 25 13:59:59 seduxbox wpa_supplicant[1732]:
Associated with 00:04:0e:e4:00:3d
/var/log/syslog.1-Apr 25 13:59:59 seduxbox wpa_supplicant[1732]: WPA:
Key negotiation completed with 00:04:0e:e4:00:3d [PTK=CCMP GTK=CCMP]
/var/log/syslog.1-Apr 25 13:59:59 seduxbox wpa_supplicant[1732]:
CTRL-EVENT-CONNECTED - Connection to 00:04:0e:e4:00:3d completed
(reauth) [id=0 id_str=]
...

With Reinette's sanity-check patch this did not happen.

Nevertheless, it is hard for me to speak from reproducibility or even success.

I have this issue on my radar...

Flash and Linux is like fist and eye - if they come together it hurts.

Kind Regards,
- Sedat -

P.S.:

$ ls -l linux-image*2.6.34*rc4*.deb
-rw-r--r-- 1 sd sd 25436128 2010-04-24 11:20
linux-image-2.6.34-rc4-115-gdc57da3_2.6.34-rc4-115-gdc57da3.20100424~iniza.1_i386.deb
-rw-r--r-- 1 sd sd 25437636 2010-04-24 21:02
linux-image-2.6.34-rc4-115-gdc57da3-test_2.6.34-rc4-115-gdc57da3-test.20100424~iniza.2_i386.deb

[linux-image-2.6.34-rc4-115-gdc57da3_2.6.34-rc4-115-gdc57da3.20100424~iniza.1_i386.deb]

wireless-2.6/0001-iwlwifi-work-around-bogus-active-chains-detection.patch
iwlwifi-fixes-for-2.6.34/1-2-iwlwifi-fix-scan-races.patch
iwlwifi-fixes-for-2.6.34/2-2-iwlwifi-correct-6000-EEPROM-regulatory-address.patch

[linux-image-2.6.34-rc4-115-gdc57da3-test_2.6.34-rc4-115-gdc57da3-test.20100424~iniza.2_i386.deb]

wireless-2.6/0001-iwlwifi-work-around-bogus-active-chains-detection.patch
iwlwifi-fixes-for-2.6.34/1-2-iwlwifi-fix-scan-races.patch
iwlwifi-fixes-for-2.6.34/2-2-iwlwifi-correct-6000-EEPROM-regulatory-address.patch
rchatre/0001-Test-Sanity-check-by-Reinette-Chatre.patch

On Wed, Apr 21, 2010 at 10:50 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> Sedat,
>
> On Wed, 2010-04-21 at 00:06 -0700, Sedat Dilek wrote:
>> >> According to Johannes (on IRC) iwl3945 doesn't use internal scans yet
>> >> (see my patch below).
>> >> Thus, I am not sure if this needs to be fixed separately for iwl3945
>> >> and if I ran into a scan race condition here.
>> >
>> > Does this patch make any difference for you?
>> >
>>
>> Speaking of my patch "iwl3945-fix-scan-races.patch" from [3]?
>> I was guessing iwl3945 has internal scans support - is that the fact?
>> Johannes told me someone is working on it.
>
> It has some support ... but nothing that currently requests an internal
> scan.
>
>> To answer your question: Not sure, but it seems not to help.
>
> Weird.
>
>> >
>> > It does. Thank you. As a sanity check, could you please try this patch?
>> >
>>
>> In general, it would be very helpful to give some comments on what
>> this offered patch is doing.
>> Not sure, if I can test it today.
>>
>
> >From your logs I see that it is right after disconnecting from AP (after
> loosing probe responses) that the problem occurs. I see that we send QOS
> commands to the device, to which it responds, but after that you start
> to get errors. I looked at when those QOS commands are sent and they are
> sent in ieee80211_set_disassoc _after_ the queues have been disabled. I
> am not sure if that is the right thing to do and wanted to check if it
> is indeed those commands that are causing the issue. The patch I asked
> you to test modified the code to not send QOS commands after queues have
> been disabled.
>
>> By the way, might help to set one of the module-options for iwl3945?
>>
>> parm:           antenna:select antenna (1=Main, 2=Aux, default 0 [both]) (int)
>> parm:           swcrypto:using software crypto (default 1 [software]) (int)
>> parm:           debug:debug output mask (uint)
>> parm:           disable_hw_scan:disable hardware scanning (default 0) (int)
>> parm:           fw_restart3945:restart firmware in case of error (int)
>>
>> Especially "fw_restart3945" in my case?
>
> It should be set by default.
>
>>  On which errors it is
>> restarting firmware?
>
> Firmware errors.
>
> Reinette
>
>
>
