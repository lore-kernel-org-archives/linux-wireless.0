Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:39126 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbATJeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 04:34:21 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so36066526wgh.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 01:34:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnjfsp3pjB4OyDvbqpQQ4TbYM+NHtTeNPCrgUJWfL-d+Q@mail.gmail.com>
References: <54B97B96.4040903@darmstadt.freifunk.net>
	<1421658833-13311-1-git-send-email-michal.kazior@tieto.com>
	<54BDDB3B.3020902@candelatech.com>
	<CAEFj984fjXUuRsNghr2Q4+397AS1TEO-K392YitUuZ5ztTF8iA@mail.gmail.com>
	<CA+BoTQnjfsp3pjB4OyDvbqpQQ4TbYM+NHtTeNPCrgUJWfL-d+Q@mail.gmail.com>
Date: Tue, 20 Jan 2015 17:34:20 +0800
Message-ID: <CAEFj984dM9w54GGPRNrHput3fnAn+9O4BenHJiujjk07-Vt=nw@mail.gmail.com> (sfid-20150120_103426_588928_819201B0)
Subject: Re: [RFC/RFT] ath10k: enable IBSS in multi-vif
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Martin Weinelt <martin@darmstadt.freifunk.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, you are right due to the bridging in hostapd.conf.

I try to disable bridging and bring up the adhoc interface then follow
by AP interface but not succeed to bring up the AP interface:

[  560.790000] ath10k_pci 0000:00:00.0: wmi vdev id 0x1 set param 1 value -1
[  560.790000] ath10k_pci 0000:00:00.0: wmi vdev id 0x1 set param 2 value -1
[  560.790000] ath10k_pci 0000:00:00.0: mac txpower 0
[  560.790000] ath10k_pci 0000:00:00.0: wmi pdev set param 3 value 0
[  560.790000] ath10k_pci 0000:00:00.0: wmi pdev set param 4 value 0
[  560.790000] ath10k_pci 0000:00:00.0: mac monitor recalc started? 0 should? 0
[  560.790000] ath10k_pci 0000:00:00.0: mac vdev 1 cts_prot 0
[  560.790000] ath10k_pci 0000:00:00.0: wmi vdev id 0x1 set param 44 value 0
[  560.790000] ath10k_pci 0000:00:00.0: mac vdev 1 slot_time 1
[  560.790000] ath10k_pci 0000:00:00.0: wmi vdev id 0x1 set param 7 value 1
[  560.790000] ath10k_pci 0000:00:00.0: mac vdev 1 preamble 1n
[  560.790000] ath10k_pci 0000:00:00.0: wmi vdev id 0x1 set param 8 value 1
[  560.790000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  560.790000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  560.790000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  560.790000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  560.790000] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  560.800000] ath10k_pci 0000:00:00.0: mac monitor recalc started? 0 should? 0
[  560.800000] ath10k_pci 0000:00:00.0: wmi start scan
[  560.800000] ath10k_pci 0000:00:00.0: scan event started type 1
reason 4 freq 5180 req_id 40961 scan_id 40960 vdev_id 1 state starting
(1)
[  560.800000] ath10k_pci 0000:00:00.0: scan event bss channel type 4
reason 4 freq 5180 req_id 40961 scan_id 40960 vdev_id 1 state running
(2)
[  560.800000] ath10k_pci 0000:00:00.0: chan info err_code 0 freq 5180
cmd_flags 1 noise_floor -104 rx_clear_count 32398189 cycle_count
-42467525
[  560.850000] ath10k_pci 0000:00:00.0: scan event foreign channel
type 8 reason 4 freq 5180 req_id 40961 scan_id 40960 vdev_id 1 state
running (2)
[  560.850000] ath10k_pci 0000:00:00.0: chan info err_code 0 freq 5180
cmd_flags 0 noise_floor 0 rx_clear_count 32436098 cycle_count
-38055888
[  561.000000] ath10k_pci 0000:00:00.0: scan event bss channel type 4
reason 4 freq 5180 req_id 40961 scan_id 40960 vdev_id 1 state running
(2)
[  561.000000] ath10k_pci 0000:00:00.0: chan info err_code 0 freq 5180
cmd_flags 1 noise_floor -104 rx_clear_count 32517835 cycle_count
-24854129
[  561.110000] ath10k_pci 0000:00:00.0: scan event foreign channel
type 8 reason 4 freq 5200 req_id 40961 scan_id 40960 vdev_id 1 state
running (2)
[  561.110000] ath10k_pci 0000:00:00.0: chan info err_code 0 freq 5200
cmd_flags 0 noise_floor 0 rx_clear_count 32595586 cycle_count
-15487778
[  561.250000] ath10k_pci 0000:00:00.0: scan event bss channel type 4
reason 4 freq 5180 req_id 40961 scan_id 40960 vdev_id 1 state running
(2)
[  561.250000] ath10k_pci 0000:00:00.0: chan info err_code 0 freq 5180
cmd_flags 1 noise_floor -104 rx_clear_count 32672388 cycle_count
-2636953
[  561.300000] ath10k_pci 0000:00:00.0: scan event completed type 2
reason 0 freq 5180 req_id 40961 scan_id 40960 vdev_id 1 state running
(2)
[  561.640000] ath10k_pci 0000:00:00.0: mac monitor recalc started? 0 should? 0
[  561.640000] ath10k_pci 0000:00:00.0: wmi peer delete vdev_id 1
peer_addr 04:f0:21:0c:a6:43
[  561.640000] ath10k_pci 0000:00:00.0: mac vdev 1 delete (remove interface)
[  561.640000] ath10k_pci 0000:00:00.0: WMI vdev delete id 1
[  561.640000] ath10k_pci 0000:00:00.0: mac monitor recalc started? 0 should? 0
[  561.650000] ath10k_pci 0000:00:00.0: mac monitor recalc started? 0 should? 0

----
Chun-Yeow

On Tue, Jan 20, 2015 at 5:21 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 20 January 2015 at 10:14, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> Experienced firmware crashed in 636 firmware immediately after
>> bringing up the AP interface.
>>
>> The partial log is listed here:
> [...]
>> [  291.380000] ath10k_pci 0000:00:00.0: firmware register dump:
>> [  291.380000] ath10k_pci 0000:00:00.0: [00]: 0x4100016C 0x00000000
>> 0x009C4521 0x00000000
>> [  291.390000] ath10k_pci 0000:00:00.0: [04]: 0x009C4521 0x00060330
>> 0x00000019 0x00955A00
>> [  291.400000] ath10k_pci 0000:00:00.0: [08]: 0x00046A4E 0x00000000
>> 0x0040CC94 0x00000020
>> [  291.410000] ath10k_pci 0000:00:00.0: [12]: 0x00000000 0x00000000
>> 0x00958360 0x0095836B
>> [  291.420000] ath10k_pci 0000:00:00.0: [16]: 0x809A0978 0x0040AD94
>> 0x00439304 0x0040D074
>> [  291.420000] ath10k_pci 0000:00:00.0: [20]: 0x0000FFFF 0x00000000
>> 0x0041B618 0x00000000
>> [  291.430000] ath10k_pci 0000:00:00.0: [24]: 0x809A0978 0x0040AD94
>> 0x00439304 0x11A93B77
>> [  291.440000] ath10k_pci 0000:00:00.0: [28]: 0x809AD1A2 0x0040ADE4
>> 0x00439304 0x0043F68C
>> [  291.450000] ath10k_pci 0000:00:00.0: [32]: 0x00000001 0x00000000
>> 0x00000000 0x00430D74
>> [  291.460000] ath10k_pci 0000:00:00.0: [36]: 0x00000000 0x00000000
>> 0x00000000 0x00000000
>> [  291.460000] ath10k_pci 0000:00:00.0: [40]: 0x00000000 0x00000000
>> 0x000000AB 0x00412700
>> [  291.470000] ath10k_pci 0000:00:00.0: [44]: 0x00439BB8 0x00000000
>> 0x00000000 0x00400000
>> [  291.480000] ath10k_pci 0000:00:00.0: [48]: 0x809AE0B4 0x0040AE04
>> 0x00400000 0x0043F68C
>> [  291.490000] ath10k_pci 0000:00:00.0: [52]: 0x00000001 0x00000000
>> 0x004231F0 0x00400000
>> [  291.500000] ath10k_pci 0000:00:00.0: [56]: 0x809AE17E 0x0040AE44
>> 0x0040FE6C 0x0040D310
>
> Yeah.. This is monitor vdev related crash (due to bridging, no?). I
> haven't found a way around it.
>
>
> Michał
