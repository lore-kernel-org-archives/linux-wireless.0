Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52578 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab0DCVwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 17:52:32 -0400
Received: by pva18 with SMTP id 18so1266548pva.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Apr 2010 14:52:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m2k43e72e891004012305ge1843cd8q7776683697b62490@mail.gmail.com>
References: <m2p43e72e891004012145s2f344f7fo9b12044e9b895c06@mail.gmail.com>
	<t2t43e72e891004012201xc3e1d823sb20e2b1d9a5460cd@mail.gmail.com>
	<g2o43e72e891004012204n7e6988eax83e94c236d9ce5ba@mail.gmail.com>
	<m2k43e72e891004012305ge1843cd8q7776683697b62490@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 3 Apr 2010 14:52:12 -0700
Message-ID: <k2j43e72e891004031452w4e8f8732zc73ba1b08579878f@mail.gmail.com>
Subject: Re: iwlagn unexpected AddBA Req
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 1, 2010 at 11:05 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Apr 1, 2010 at 10:04 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Thu, Apr 1, 2010 at 10:01 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Thu, Apr 1, 2010 at 9:45 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>> [  117.491303] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
>>>> [  178.467383] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
>>>> [  239.447236] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
>>>>
>>>> I get a lof of these at spurious times against my WRT610N using
>>>> today's wireless-testing on iwlagn.
>>>
>>> Here's a very simply way to reproduce this -- I ping my AP and keep
>>> only that connection alive. I see this come up every minute. I see the
>>> MCS rate fluctuate between 7 and 15 @ HT40 Short GI, and also 6
>>> Mbit/s. This is on 5 GHz.
>>
>> OK I don't think this is coincidence this happens exactly every minute
>> + 1 second:
>>
>> Apr  1 21:50:01 tux kernel: [  788.234773] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 21:51:02 tux kernel: [  849.212426] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 21:52:03 tux kernel: [  910.188457] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 21:53:04 tux kernel: [  971.163480] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 21:54:05 tux kernel: [ 1032.143746] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 21:55:06 tux kernel: [ 1093.151574] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 21:56:07 tux kernel: [ 1154.158165] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 21:57:08 tux kernel: [ 1215.163516] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 21:58:09 tux kernel: [ 1276.171801] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 21:59:10 tux kernel: [ 1337.177613] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 22:00:11 tux kernel: [ 1398.186640] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 22:01:12 tux kernel: [ 1459.193255] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 22:02:13 tux kernel: [ 1520.199135] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>> Apr  1 22:03:14 tux kernel: [ 1581.204850] unexpected AddBA Req from
>> 00:22:6b:56:fd:e9 on tid 0
>
> Hm, I had a feeling this was firmware related so I just downloaded the
> latest, turns out I have the latest:
>
> mcgrof@tux ~/Downloads/firmware/iwlwifi-4965-ucode-228.61.2.24 $ ls
> iwlwifi-4965-2.ucode  LICENSE.iwlwifi-4965-ucode  README.iwlwifi-4965-ucode
> mcgrof@tux ~/Downloads/firmware/iwlwifi-4965-ucode-228.61.2.24 $ sudo
> cp iwlwifi-4965-2.ucode /lib/firmware/^C
> mcgrof@tux ~/Downloads/firmware/iwlwifi-4965-ucode-228.61.2.24 $
> sha1sum iwlwifi-4965-2.ucode
> 86b4ff04133b2b44412833234dc1dfbb502a4b7a  iwlwifi-4965-2.ucode
> mcgrof@tux ~/Downloads/firmware/iwlwifi-4965-ucode-228.61.2.24 $
> sha1sum /lib/firmware/iwlwifi-4965-2.ucode
> 86b4ff04133b2b44412833234dc1dfbb502a4b7a  /lib/firmware/iwlwifi-4965-2.ucode
>
> Apr  1 22:45:06 tux kernel: [    4.975607] iwlagn 0000:03:00.0: irq 32
> for MSI/MSI-X
> Apr  1 22:45:06 tux kernel: [    4.976734] iwlagn 0000:03:00.0:
> firmware: requesting iwlwifi-4965-2.ucode
> Apr  1 22:45:06 tux kernel: [    5.008333] iwlagn 0000:03:00.0: loaded
> firmware version 228.61.2.24
>
> Sometimes, I get into a loop where I just get these:
>
> 1270187820.132338: wlan14 (phy #0): deauth 00:22:6b:56:fd:e9 ->
> 00:21:5c:02:1f:db reason 15: 4-way handshake timeout
>
> I get this against 2.4 GHz and 5 Ghz, the 2 GHz band is configured to
> be 802.11g only. 5 GHz is configured for HT40 5 GHz only.

Today I also got some firmware crashes:

[74421.540175] No probe response from AP 00:22:6b:56:fd:e9 after
500ms, disconnecting.
[74421.542633] iwlagn 0000:03:00.0: Microcode SW error detected.
Restarting 0x2000000.
[74421.542811] iwlagn 0000:03:00.0: Start IWL Error Log Dump:
[74421.542930] iwlagn 0000:03:00.0: Status: 0x000213E4, count: 5
[74421.543215] iwlagn 0000:03:00.0: Desc
Time       data1      data2      line
[74421.543356] iwlagn 0000:03:00.0: SYSASSERT                    (#05)
0000001863 0x00000001 0x00000000 1384
[74421.543494] iwlagn 0000:03:00.0: blink1  blink2  ilink1  ilink2
[74421.543615] iwlagn 0000:03:00.0: 0x0217A 0x021C2 0x006DE 0x00000
[74421.543735] iwlagn 0000:03:00.0: FH register values:
[74421.543890] iwlagn 0000:03:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X03c6a400
[74421.544061] iwlagn 0000:03:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0016fb80
[74421.544233] iwlagn 0000:03:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000008
[74421.544404] iwlagn 0000:03:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819004
[74421.544574] iwlagn 0000:03:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X0000003c
[74421.544743] iwlagn 0000:03:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[74421.544914] iwlagn 0000:03:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[74421.545080] iwlagn 0000:03:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0002
[74421.545251] iwlagn 0000:03:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[74421.545469] iwlagn 0000:03:00.0: Start IWL Event Log Dump: display
last 20 entries
[74421.545645] iwlagn 0000:03:00.0: EVT_LOGT:0000000267:0x0218001c:0218
[74421.545798] iwlagn 0000:03:00.0: EVT_LOGT:0000000269:0x00000021:0217
[74421.545950] iwlagn 0000:03:00.0: EVT_LOGT:0000000272:0x0219001c:0218
[74421.546100] iwlagn 0000:03:00.0: EVT_LOGT:0000000274:0x00000021:0217
[74421.546251] iwlagn 0000:03:00.0: EVT_LOGT:0000000276:0x021a001c:0218
[74421.546403] iwlagn 0000:03:00.0: EVT_LOGT:0000000278:0x00000021:0217
[74421.546556] iwlagn 0000:03:00.0: EVT_LOGT:0000000281:0x021b001c:0218
[74421.546706] iwlagn 0000:03:00.0: EVT_LOGT:0000000283:0x00000021:0217
[74421.546857] iwlagn 0000:03:00.0: EVT_LOGT:0000000286:0x021c001c:0218
[74421.547007] iwlagn 0000:03:00.0: EVT_LOGT:0000000288:0x00000021:0217
[74421.547158] iwlagn 0000:03:00.0: EVT_LOGT:0000000291:0x021d001c:0218
[74421.547307] iwlagn 0000:03:00.0: EVT_LOGT:0000000292:0x00000021:0217
[74421.547460] iwlagn 0000:03:00.0: EVT_LOGT:0000000295:0x021e001c:0218
[74421.547611] iwlagn 0000:03:00.0: EVT_LOGT:0000000297:0x00000021:0217
[74421.547762] iwlagn 0000:03:00.0: EVT_LOGT:0000000300:0x021f001c:0218
[74421.547913] iwlagn 0000:03:00.0: EVT_LOGT:0000000302:0x00000021:0217
[74421.548060] iwlagn 0000:03:00.0: EVT_LOGT:0000000305:0x0220001c:0218
[74421.548212] iwlagn 0000:03:00.0: EVT_LOGT:0000000306:0x00000021:0217
[74421.548363] iwlagn 0000:03:00.0: EVT_LOGT:0000001862:0x0473004e:0401
[74421.548513] iwlagn 0000:03:00.0: EVT_LOGT:0000001866:0x00000000:0125
[74421.548669] iwlagn 0000:03:00.0: Command REPLY_ADD_STA failed: FW Error
[74421.548794] iwlagn 0000:03:00.0: Adding station 00:22:6b:56:fd:e9 failed.
[74422.040173] iwlagn 0000:03:00.0: Error sending
REPLY_TX_LINK_QUALITY_CMD: time out after 500ms.
[74422.540164] iwlagn 0000:03:00.0: Error sending REPLY_ADD_STA: time
out after 500ms.
[74422.540310] iwlagn 0000:03:00.0: Adding station ff:ff:ff:ff:ff:ff failed.

  Luis
