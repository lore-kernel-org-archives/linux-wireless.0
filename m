Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58752 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab0DBGFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 02:05:44 -0400
Received: by pva18 with SMTP id 18so796623pva.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 23:05:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <g2o43e72e891004012204n7e6988eax83e94c236d9ce5ba@mail.gmail.com>
References: <m2p43e72e891004012145s2f344f7fo9b12044e9b895c06@mail.gmail.com>
	<t2t43e72e891004012201xc3e1d823sb20e2b1d9a5460cd@mail.gmail.com>
	<g2o43e72e891004012204n7e6988eax83e94c236d9ce5ba@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 1 Apr 2010 23:05:24 -0700
Message-ID: <m2k43e72e891004012305ge1843cd8q7776683697b62490@mail.gmail.com>
Subject: Re: iwlagn unexpected AddBA Req
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 1, 2010 at 10:04 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Apr 1, 2010 at 10:01 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Thu, Apr 1, 2010 at 9:45 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> [  117.491303] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
>>> [  178.467383] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
>>> [  239.447236] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
>>>
>>> I get a lof of these at spurious times against my WRT610N using
>>> today's wireless-testing on iwlagn.
>>
>> Here's a very simply way to reproduce this -- I ping my AP and keep
>> only that connection alive. I see this come up every minute. I see the
>> MCS rate fluctuate between 7 and 15 @ HT40 Short GI, and also 6
>> Mbit/s. This is on 5 GHz.
>
> OK I don't think this is coincidence this happens exactly every minute
> + 1 second:
>
> Apr  1 21:50:01 tux kernel: [  788.234773] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 21:51:02 tux kernel: [  849.212426] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 21:52:03 tux kernel: [  910.188457] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 21:53:04 tux kernel: [  971.163480] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 21:54:05 tux kernel: [ 1032.143746] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 21:55:06 tux kernel: [ 1093.151574] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 21:56:07 tux kernel: [ 1154.158165] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 21:57:08 tux kernel: [ 1215.163516] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 21:58:09 tux kernel: [ 1276.171801] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 21:59:10 tux kernel: [ 1337.177613] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 22:00:11 tux kernel: [ 1398.186640] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 22:01:12 tux kernel: [ 1459.193255] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 22:02:13 tux kernel: [ 1520.199135] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0
> Apr  1 22:03:14 tux kernel: [ 1581.204850] unexpected AddBA Req from
> 00:22:6b:56:fd:e9 on tid 0

Hm, I had a feeling this was firmware related so I just downloaded the
latest, turns out I have the latest:

mcgrof@tux ~/Downloads/firmware/iwlwifi-4965-ucode-228.61.2.24 $ ls
iwlwifi-4965-2.ucode  LICENSE.iwlwifi-4965-ucode  README.iwlwifi-4965-ucode
mcgrof@tux ~/Downloads/firmware/iwlwifi-4965-ucode-228.61.2.24 $ sudo
cp iwlwifi-4965-2.ucode /lib/firmware/^C
mcgrof@tux ~/Downloads/firmware/iwlwifi-4965-ucode-228.61.2.24 $
sha1sum iwlwifi-4965-2.ucode
86b4ff04133b2b44412833234dc1dfbb502a4b7a  iwlwifi-4965-2.ucode
mcgrof@tux ~/Downloads/firmware/iwlwifi-4965-ucode-228.61.2.24 $
sha1sum /lib/firmware/iwlwifi-4965-2.ucode
86b4ff04133b2b44412833234dc1dfbb502a4b7a  /lib/firmware/iwlwifi-4965-2.ucode

Apr  1 22:45:06 tux kernel: [    4.975607] iwlagn 0000:03:00.0: irq 32
for MSI/MSI-X
Apr  1 22:45:06 tux kernel: [    4.976734] iwlagn 0000:03:00.0:
firmware: requesting iwlwifi-4965-2.ucode
Apr  1 22:45:06 tux kernel: [    5.008333] iwlagn 0000:03:00.0: loaded
firmware version 228.61.2.24

Sometimes, I get into a loop where I just get these:

1270187820.132338: wlan14 (phy #0): deauth 00:22:6b:56:fd:e9 ->
00:21:5c:02:1f:db reason 15: 4-way handshake timeout

I get this against 2.4 GHz and 5 Ghz, the 2 GHz band is configured to
be 802.11g only. 5 GHz is configured for HT40 5 GHz only.

  Luis
