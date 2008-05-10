Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:44076 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbYEJRG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 13:06:58 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2477619waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 10:06:57 -0700 (PDT)
Message-ID: <1ba2fa240805101006t4b3362c8ja11e58db4634b0f9@mail.gmail.com> (sfid-20080510_190707_056984_59F9F303)
Date: Sat, 10 May 2008 20:06:54 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vincent C Jones" <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com>
	 <1210376474.3856.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
	 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 10, 2008 at 5:39 PM, Vincent C Jones
<v.jones@networkingunlimited.com> wrote:
>
> On Sat, 2008-05-10 at 03:12 +0300, Tomas Winkler wrote:
>> On Sat, May 10, 2008 at 2:41 AM, Vincent C Jones
>> <v.jones@networkingunlimited.com> wrote:
>> >
>> > On Sat, 2008-05-10 at 00:23 +0300, Tomas Winkler wrote:
>> >> On Fri, May 9, 2008 at 7:57 PM, Vincent C Jones
>> >> <v.jones@networkingunlimited.com> wrote:
>> >> > The channel/frequency reporting by iwlwifi is incompatible with
>> >> >  wpa_supplicant for 5GHz (802.11A) channels. Version numbers and iwlist
>> >> >  versus wpa_supplicant scan results are below. Association still works if
>> >> >  the correct channel is specified using iwconfig, but that is
>> >> >  incompatible with roaming.
>> >>
>> >> Fixed by the patch ' iwlwifi: Fix frequency in rx_status fill'
>> >>
>> >> Thanks
>> >> Tomas
>> >
>> > This patch did not apply cleanly to plain 2.6.26-rc1: off by -4 lines in
>> > iwl-3945.c and by 1078 lines in iwl-4965.c. More important, it did not
>> > fix the problem of wpa_supplicant thinking the 802.11A access points are
>> > on channel 0. Same results with 2.6.26-rc1-git7, with & without patch.
>> > Any idea when this patch (and the patches it appears to depend on) will
>> > make it into the 2.6.26 release?
>> >
>>
>> This patch is against wireless-testing.git, it's just too lines and
>> doesn't really have logical dependencies on other patches so I didn't
>> create a separate patch for 2.6.26...It looks maybe I should.
>> Can you  try to eproduce your problem on wireless-testing kernel with
>> this patch?
>> Also some logs will be useful
>>
>> Thanks
>> Tomas
>
> Tomas,
>
> No joy. Did I git the wrong tree?
>
> (git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git)
>
> Still had to apply your patch (offset 223 lines this time). Also applied
> the media/built-in.o patch so my config would compile. Wpa_supplicant
> (v0.6.3) still reports 0 for the channel of 11A stations:

It seems  to be correct.  There are some patches that come before this
one yet Yi has reordered the series a bit and pushed this one first
because of it's urgency. The later patches will come later, but there
is no dependency. So that my explain the offset.

>> scan_res
> bssid / frequency / signal level / flags / ssid
> 00:1a:c1:8a:23:40       0       208     [WPA-PSK-TKIP
> +CCMP][WPA2-PSK-TKIP+CCMP-preauth] NetworkingUnlimited
> 00:1e:2a:6c:93:d9       2462    169     [WPA-PSK-TKIP
> +CCMP][WPA2-PSK-TKIP+CCMP]NetworkingUnlimited-G
>>
>
> I've appended output of iwlist scan and dmesg. Any other logs of
> interest?
>
>
>          Cell 05 - Address: 00:1A:C1:8A:23:40
>                    ESSID:"NetworkingUnlimited"
>                    Mode:Master
>                    Frequency:5.24 GHz (Channel 48)
>                    Channel:48

Looks like channel is reported correctly here


>>>>> issue command "iwconfig wlan0 chan 48"

Not sure how wpa supplicant parses the scanning output

The scan result is  build by ieee80211_sta_scan_result function
defined in mlme.c file

The code dealing with frequency is below. I currently I don't have 11a
AP so if you can put some debug output in wpa_supplicant and mac80211
we can learn more. Otherwise I will have to look at this tomorrow

memset(&iwe, 0, sizeof(iwe));
        iwe.cmd = SIOCGIWFREQ;
        iwe.u.freq.m = bss->freq;
        iwe.u.freq.e = 6;
        current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
                                          IW_EV_FREQ_LEN);

        memset(&iwe, 0, sizeof(iwe));
        iwe.cmd = SIOCGIWFREQ;
        iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
        iwe.u.freq.e = 0;
        current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
                                          IW_EV_FREQ_LEN);


Thanks
Tomas
