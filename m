Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:38432 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3IWSVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 14:21:35 -0400
Received: by mail-vb0-f48.google.com with SMTP id w16so2419281vbf.7
        for <linux-wireless@vger.kernel.org>; Mon, 23 Sep 2013 11:21:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DB3584@HASMSX103.ger.corp.intel.com>
References: <CAObL_7HXC8qQ54O5QPAo7cQT2yeK-etgKD-7aoaL3dkT4qcOow@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DB3584@HASMSX103.ger.corp.intel.com>
From: Andrew Lutomirski <andy@luto.us>
Date: Mon, 23 Sep 2013 19:21:14 +0100
Message-ID: <CAObL_7GA-SD5bK7Hnwyp_vnoLxSbcGGtnzgyD-GBHAwaxF1JxQ@mail.gmail.com> (sfid-20130923_202144_198400_30A1E41B)
Subject: Re: [Ilw] Intel 6300 crashes hard (3.11 regression?)
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 23, 2013 at 5:01 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>>
>> I've had a failure twice on 3.11.1-200.fc19.x86_64.  I've never seen it on
>> earlier Fedora kernels or on 3.11-rc3.  The computer hangs for a minute or so.
>> When it comes back, wireless doesn't work.  rmmoding and modprobing
>> iwldvm doesn't help (it's at the bottom of the attachment).
>>
>> Even rebooting doesn't fix it unless I pull the battery.  Otherwise iwlwifi loads
>> but wlan0 doesn't appear and the only log line is the one saying that iwlwifi
>> loaded.
>>
>> The messages on startup are:
>>
>> [   11.440725] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't
>> have ASPM control
>> [   11.440788] iwlwifi 0000:03:00.0: irq 51 for MSI/MSI-X
>> [   11.455653] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1
>> build 25532 op_mode iwldvm
>> [   11.517924] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
>> [   11.517930] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
>> [   11.517932] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING
>> disabled
>> [   11.517934] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
>> [   11.517936] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R)
>> Ultimate-N 6300 AGN, REV=0x74
>> [   11.519626] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
>>
>> (Both failures happened with pcie_aspm=force, but this is without it.
>> I want to see if disabling that option fixes it.)
>
> Please do and report back - what I can see here is that we kinda can't access the NIC - so I would be curious if pcie_aspm=force changes the game here.
>

It happened again.  This time I got some stuff in the middle of the
dump that I didn't notice last time:

[ 1125.076283] iwlwifi 0000:03:00.0: Q 19 is active and mapped to fifo
2 ra_tid 0xa5a5 [90,1515870810]
[ 1127.073531] iwlwifi 0000:03:00.0: Error sending REPLY_TXFIFO_FLUSH:
time out after 2000ms.
[ 1127.073544] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 135
write_ptr 143
[ 1127.073550] iwlwifi 0000:03:00.0: Couldn't flush the AGG queue
[ 1129.110029] iwlwifi 0000:03:00.0: Error sending REPLY_ADD_STA: time
out after 2000ms.
[ 1129.110037] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 135
write_ptr 146
[ 1129.110044] wlan0: HW problem - can not stop rx aggregation for
50:a7:33:27:30:78 tid 0
[ 1131.107391] iwlwifi 0000:03:00.0: Error sending REPLY_ADD_STA: time
out after 2000ms.
[ 1131.107399] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 135
write_ptr 149
[ 1131.107405] wlan0: HW problem - can not stop rx aggregation for
50:a7:33:27:30:78 tid 1
[ 1133.104739] iwlwifi 0000:03:00.0: Error sending REPLY_ADD_STA: time
out after 2000ms.
[ 1133.104745] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 135
write_ptr 152
[ 1133.104750] wlan0: HW problem - can not stop rx aggregation for
50:a7:33:27:30:78 tid 5
[ 1135.102155] iwlwifi 0000:03:00.0: Error sending REPLY_ADD_STA: time
out after 2000ms.
[ 1135.102160] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 135
write_ptr 155
[ 1135.102163] wlan0: HW problem - can not stop rx aggregation for
50:a7:33:27:30:78 tid 6
[ 1137.099675] iwlwifi 0000:03:00.0: Error sending REPLY_QOS_PARAM:
time out after 2000ms.
[ 1137.099682] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 135
write_ptr 158
[ 1137.099686] iwlwifi 0000:03:00.0: Failed to update QoS
[ 1139.097113] iwlwifi 0000:03:00.0: Error sending REPLY_RXON: time
out after 2000ms.
[ 1139.097120] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 135
write_ptr 161
[ 1139.097124] iwlwifi 0000:03:00.0: Error clearing ASSOC_MSK on BSS (-110)
[ 1141.094533] iwlwifi 0000:03:00.0: Error sending REPLY_RXON: time
out after 2000ms.
[ 1141.094589] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 135
write_ptr 164
[ 1141.094633] iwlwifi 0000:03:00.0: Error clearing ASSOC_MSK on BSS (-110)
[ 1141.314184] iwlwifi 0000:03:00.0: No space in command queue
[ 1141.314259] iwlwifi 0000:03:00.0: Restarting adapter queue is full
[ 1141.314305] iwlwifi 0000:03:00.0: Error sending REPLY_LEDS_CMD:
enqueue_hcmd failed: -28
[ 1143.091961] iwlwifi 0000:03:00.0: Error sending REPLY_RXON: time
out after 2000ms.
[ 1143.092016] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 135
write_ptr 165
[ 1143.092060] iwlwifi 0000:03:00.0: Error clearing ASSOC_MSK on BSS (-110)
[ 1145.090373] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 0
[ 1145.090450] iwlwifi 0000:03:00.0: Current SW read_ptr 142 write_ptr 143
[ 1145.110262] iwl data: 00000000: 90 3b 0d a2 00 88 ff ff 50 3b 0d a2
00 88 ff ff  .;......P;......
[ 1145.130280] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x5a5a5a5a
[ 1145.149994] iwlwifi 0000:03:00.0: FH TRBs(1) = 0x5a5a5a5a
[ 1145.169813] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x5a5a5a5a
[ 1145.189419] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x5a5a5a5a
[ 1145.208993] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x5a5a5a5a
[ 1145.228552] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x5a5a5a5a
[ 1145.248097] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x5a5a5a5a
[ 1145.267558] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x5a5a5a5a


3.10 seems stable.

--Andy
