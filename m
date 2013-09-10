Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36313 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3IJF2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 01:28:01 -0400
Received: by mail-wg0-f53.google.com with SMTP id x12so3773388wgg.20
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 22:28:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1781136.IRflOffuSs@blech>
References: <CAHhaCVjomgED0WW1fyUQbePNS0DnPEfKb5uE-+rEMhx6zgO1ZA@mail.gmail.com>
 <1781136.IRflOffuSs@blech>
From: "Brian O'Connor" <bocon13@gmail.com>
Date: Mon, 9 Sep 2013 22:27:39 -0700
Message-ID: <CAHhaCVh_etgA1aoSur5shtduCbk9R-zuya8sBKu90A9M_Kj6qg@mail.gmail.com> (sfid-20130910_072805_645955_27E8B8EF)
Subject: Re: beginner build question
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

Thanks for getting back to me. I've run into another issue:

# note the extra / before r92su
$ sudo make load
insmod /r92su/r92su.ko
Error: could not load module /r92su/r92su.ko: No such file or directory
make: *** [load] Error 1

# so I manually run
$ sudo insmod r92su/r92su.ko
Error: could not insert module r92su/r92su.ko: Unknown symbol in module

$ dmesg
...
[ 2066.923259] r92su: module verification failed: signature and/or
required key missing - tainting kernel
[ 2066.923332] r92su: Unknown symbol cfg80211_scan_done (err 0)
[ 2066.923362] r92su: Unknown symbol ieee80211_amsdu_to_8023s (err 0)
[ 2066.923386] r92su: Unknown symbol ieee80211_data_from_8023 (err 0)
[ 2066.923403] r92su: Unknown symbol cfg80211_disconnected (err 0)
[ 2066.923432] r92su: Unknown symbol wiphy_register (err 0)
[ 2066.923442] r92su: Unknown symbol wiphy_new (err 0)
[ 2066.923451] r92su: Unknown symbol cfg80211_put_bss (err 0)
[ 2066.923461] r92su: Unknown symbol cfg80211_inform_bss (err 0)
[ 2066.923478] r92su: Unknown symbol cfg80211_ibss_joined (err 0)
[ 2066.923496] r92su: Unknown symbol cfg80211_michael_mic_failure (err 0)
[ 2066.923508] r92su: Unknown symbol cfg80211_connect_result (err 0)
[ 2066.923527] r92su: Unknown symbol wiphy_unregister (err 0)
[ 2066.923546] r92su: Unknown symbol cfg80211_get_bss (err 0)
[ 2066.923576] r92su: Unknown symbol ieee80211_data_to_8023 (err 0)
[ 2066.923597] r92su: Unknown symbol ieee80211_hdrlen (err 0)
[ 2066.923615] r92su: Unknown symbol ieee80211_frequency_to_channel (err 0)
[ 2066.923634] r92su: Unknown symbol cfg80211_unlink_bss (err 0)
[ 2066.923644] r92su: Unknown symbol wiphy_free (err 0)
[ 2233.171269] r8712u 2-4:1.0 wlan0:
r8712_got_addbareq_event_callback: mac = c8:d7:19:xx:xx:xx, seq =
10528, tid = 2

Any idea? I would be happy to provide more debugging if it helps.

Thanks,
Brian

On Fri, Sep 6, 2013 at 3:21 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> Hello,
>
> On Friday, September 06, 2013 02:27:26 AM Brian O'Connor wrote:
>> I am trying to compile rtl8192su in Ubuntu 13.04 and I get the
>> following error when I "make all":
>>
>> make -C /lib/modules/3.10.10-031010-generic/build
>> M=/home/media/rtl8192su/r92su CONFIG_R92SU=m CONFIG_R92SU_DEBUGFS=y
>> CONFIG_R92SU_WPC=y all EXTRA_CFLAGS="-DDEBUG -DCONFIG_R92SU=m
>                      ^^^
>> -DCONFIG_R92SU_DEBUGFS=y -DCONFIG_R92SU_WPC=y"
>> make[1]: Entering directory `/usr/src/linux-headers-3.10.10-031010-generic'
>> make[1]: *** No rule to make target `vmlinux', needed by `all'.  Stop.
>> make[1]: Leaving directory `/usr/src/linux-headers-3.10.10-031010-generic'
>> make: *** [all] Error 2
>>
>> Any suggestions?
> Thanks for reporting this. I fixed the project's readme.
> <https://github.com/chunkeey/rtl8192su/commit/d1934e155840ccd273a429d85f1f2aa407ba49b7>
>
> Just run "make" instead of "make all".
>
> Regards
>
> Chr
>
