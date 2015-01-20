Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50601 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbATJOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 04:14:38 -0500
Received: by mail-wi0-f180.google.com with SMTP id bs8so21515236wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 01:14:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54BDDB3B.3020902@candelatech.com>
References: <54B97B96.4040903@darmstadt.freifunk.net>
	<1421658833-13311-1-git-send-email-michal.kazior@tieto.com>
	<54BDDB3B.3020902@candelatech.com>
Date: Tue, 20 Jan 2015 17:14:37 +0800
Message-ID: <CAEFj984fjXUuRsNghr2Q4+397AS1TEO-K392YitUuZ5ztTF8iA@mail.gmail.com> (sfid-20150120_101444_995031_6D0C2C34)
Subject: Re: [RFC/RFT] ath10k: enable IBSS in multi-vif
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	martin@darmstadt.freifunk.net,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Experienced firmware crashed in 636 firmware immediately after
bringing up the AP interface.

The partial log is listed here:

[  290.350000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 33 value 0
[  290.350000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 48 value 1
[  290.350000] ath10k_pci 0000:00:00.0: wmi peer create vdev_id 0
peer_addr 04:f0:21:0c:a5:43
[  290.350000] ath10k_pci 0000:00:00.0: wmi pdev set param 13 value 50
[  290.350000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 40 value 3747
[  290.350000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 41 value 3895
[  290.350000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 42 value 3900
[  290.350000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 1 value -1
[  290.350000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 2 value -1
[  290.350000] ath10k_pci 0000:00:00.0: mac txpower 17
[  290.350000] ath10k_pci 0000:00:00.0: wmi pdev set param 3 value 34
[  290.350000] ath10k_pci 0000:00:00.0: wmi pdev set param 4 value 34
[  290.350000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  290.350000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  290.350000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  290.350000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  290.350000] ath10k_pci 0000:00:00.0: mac config channel 5180MHz
flags 0x120 radar 0
[  290.350000] ath10k_pci 0000:00:00.0: mac monitor recalc started? 0 should? 0
[  290.350000] ath10k_pci 0000:00:00.0: mac monitor recalc started? 0 should? 1
[  290.350000] ath10k_pci 0000:00:00.0: WMI vdev create: id 1 type 4
subtype 0 macaddr 04:f0:21:0c:a5:43
[  290.350000] ath10k_pci 0000:00:00.0: mac monitor vdev 1 created
[  290.350000] ath10k_pci 0000:00:00.0: wmi vdev start id 0x1 flags:
0x0, freq 5180, mode 10, ch_flags: 0xA000000, max_power: 34
[  290.350000] ath10k_pci 0000:00:00.0: WMI_VDEV_START_RESP_EVENTID
[  290.350000] ath10k_pci 0000:00:00.0: wmi mgmt vdev up id 0x1 assoc
id 0 bssid 04:f0:21:0c:a5:43
[  290.350000] ath10k_pci 0000:00:00.0: mac monitor vdev 1 started
[  290.350000] ath10k_pci 0000:00:00.0: mac monitor started
[  290.350000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 3 value 100
[  290.350000] ath10k_pci 0000:00:00.0: mac vdev 0 beacon_interval 100
[  290.350000] ath10k_pci 0000:00:00.0: vdev 0 set beacon tx mode to staggered
[  290.350000] ath10k_pci 0000:00:00.0: wmi pdev set param 7 value 0
[  290.350000] ath10k_pci 0000:00:00.0: mac vdev 0 start center_freq
5180 phymode 11ac-vht80
[  290.350000] ath10k_pci 0000:00:00.0: wmi vdev start id 0x0 flags:
0x0, freq 5180, mode 10, ch_flags: 0xA000000, max_power: 34
[  291.330000] ath10k_pci 0000:00:00.0: wmi event debug mesg len 36
[  291.350000] ath10k_pci 0000:00:00.0: firmware crashed! (uuid
ca777c3c-e580-4237-824a-8da65949870b)
[  291.360000] ath10k_pci 0000:00:00.0: qca988x hw2.0 (0x4100016c,
0x043202ff) fw 999.999.0.636 api 2 htt 2.1 wmi 1 cal otp max_sta 16
[  291.370000] ath10k_pci 0000:00:00.0: debug 1 debugfs 1 tracing 1
dfs 1 testmode 0
[  291.380000] ath10k_pci 0000:00:00.0: firmware register dump:
[  291.380000] ath10k_pci 0000:00:00.0: [00]: 0x4100016C 0x00000000
0x009C4521 0x00000000
[  291.390000] ath10k_pci 0000:00:00.0: [04]: 0x009C4521 0x00060330
0x00000019 0x00955A00
[  291.400000] ath10k_pci 0000:00:00.0: [08]: 0x00046A4E 0x00000000
0x0040CC94 0x00000020
[  291.410000] ath10k_pci 0000:00:00.0: [12]: 0x00000000 0x00000000
0x00958360 0x0095836B
[  291.420000] ath10k_pci 0000:00:00.0: [16]: 0x809A0978 0x0040AD94
0x00439304 0x0040D074
[  291.420000] ath10k_pci 0000:00:00.0: [20]: 0x0000FFFF 0x00000000
0x0041B618 0x00000000
[  291.430000] ath10k_pci 0000:00:00.0: [24]: 0x809A0978 0x0040AD94
0x00439304 0x11A93B77
[  291.440000] ath10k_pci 0000:00:00.0: [28]: 0x809AD1A2 0x0040ADE4
0x00439304 0x0043F68C
[  291.450000] ath10k_pci 0000:00:00.0: [32]: 0x00000001 0x00000000
0x00000000 0x00430D74
[  291.460000] ath10k_pci 0000:00:00.0: [36]: 0x00000000 0x00000000
0x00000000 0x00000000
[  291.460000] ath10k_pci 0000:00:00.0: [40]: 0x00000000 0x00000000
0x000000AB 0x00412700
[  291.470000] ath10k_pci 0000:00:00.0: [44]: 0x00439BB8 0x00000000
0x00000000 0x00400000
[  291.480000] ath10k_pci 0000:00:00.0: [48]: 0x809AE0B4 0x0040AE04
0x00400000 0x0043F68C
[  291.490000] ath10k_pci 0000:00:00.0: [52]: 0x00000001 0x00000000
0x004231F0 0x00400000
[  291.500000] ath10k_pci 0000:00:00.0: [56]: 0x809AE17E 0x0040AE44
0x0040FE6C 0x0040D310
[  291.510000] ath10k_pci 0000:00:00.0: wmi mgmt vdev up id 0x0 assoc
id 0 bssid 04:f0:21:0c:a5:43
[  291.510000] ath10k_pci 0000:00:00.0: mac vdev 0 up
[  291.510000] ath10k_pci 0000:00:00.0: mac vdev 0 cts_prot 0
[  291.510000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 44 value 0
[  291.510000] ath10k_pci 0000:00:00.0: mac vdev 0 slot_time 2
[  291.510000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 7 value 2
[  291.510000] ath10k_pci 0000:00:00.0: mac vdev 0 preamble 1n
[  291.510000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 8 value 1
[  291.510000] ath10k_pci 0000:00:00.0: mac vdev_id 0 txpower 17

---
Chun-Yeow

On Tue, Jan 20, 2015 at 12:36 PM, Ben Greear <greearb@candelatech.com> wrote:
>
>
> On 01/19/2015 01:13 AM, Michal Kazior wrote:
>>
>> The 999.999.0.636 firmware seems to support
>> concurrent IBSS + AP/STA. At least basic stuff
>> works so enable it since some people are
>> interested in this stuff.
>>
>> If it's broken we can fix, restrict or disable it
>> later.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>> Hi Martin,
>>
>> Feel free to take this patch and run whatever case
>> you had in mind. If this proves to work for you
>> without any major issues (like notorious crashes,
>> traffic issues and such) I guess we could try
>> pulling this upstream.
>>
>> Make sure you use 999.999.0.636 firmware. The 10.x
>> doesn't support IBSS at all.
>
>
> Likely my 10.1.467 based CT firmware will support this as well...
>
> Ben
>
>>
>>
>>   drivers/net/wireless/ath/ath10k/mac.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
>> b/drivers/net/wireless/ath/ath10k/mac.c
>> index 9524bc5..11170ce 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -5032,6 +5032,10 @@ static const struct ieee80211_iface_limit
>> ath10k_if_limits[] = {
>>         .max    = 7,
>>         .types  = BIT(NL80211_IFTYPE_AP)
>>         },
>> +       {
>> +       .max    = 1,
>> +       .types  = BIT(NL80211_IFTYPE_ADHOC)
>> +       },
>>   };
>>
>>   static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
>>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
