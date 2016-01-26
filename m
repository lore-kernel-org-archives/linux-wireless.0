Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33088 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965652AbcAZO2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 09:28:25 -0500
Received: by mail-io0-f196.google.com with SMTP id f81so15856605iof.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 06:28:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9D2EC6@hasmsx109.ger.corp.intel.com>
References: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com>
	<1453760341-30008-1-git-send-email-mar.kolya@gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E9D2EC6@hasmsx109.ger.corp.intel.com>
Date: Tue, 26 Jan 2016 09:28:24 -0500
Message-ID: <CALGY4fv5t7k9Xcw1iysL3gyLih7S4z2Y7ShXTJiXWc5aDVVM_A@mail.gmail.com> (sfid-20160126_152829_002065_C48B18CB)
Subject: Re: [PATCH v2] iwldvm: fix chain gain calibration when firmware
 return zero values
From: Nikolay Martynov <mar.kolya@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"julian.calaby@gmail.com" <julian.calaby@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

2016-01-26 3:28 GMT-05:00 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
>
>
> On 01/26/2016 12:20 AM, Nikolay Martynov wrote:
>> It looks like sometimes firmware returns zero for chain noise and signal
>> during calibration period. This seems to be a known problem and current
>> implementation accounts for this by ignoring invalid data when all chains
>> return zero signal and noise.
>>
>> The problem is that sometimes firmware returns zero for only one chain for
>> some (not all) beacons used for calibration. This leads to perfectly valid
>> chains be disabled and may cause invalid gain settings.
>> For example this is calibration data taken on laptop with Intel 6300 card
>> with all three antennas attached:
>>
>> active_chains:                         3
>> chain_noise_a:                         312
>> chain_noise_b:                         297
>> chain_noise_c:                         0
>> chain_signal_a:                        549
>> chain_signal_b:                        513
>> chain_signal_c:                        0
>> beacon_count:                  16
>> disconn_array:                         0 0 1
>> delta_gain_code:               4 0 0
>> radio_write:                   1
>> state:                                 3
>>
>> This patch changes statistics gathering to make sure that zero noise
>> results are ignored for valid rx chains. The rationale being that even if
>> anntenna is not connected we should be able to see non zero noise if rx
>> chain is present.
>
> But then the firmware will continue to send zero for signal and this
> will impact lots
> of flows like roaming. If the driver allows the firmware to use that
> antenna, the
> firmware may use this antenna for scanning and roaming will be broken.
> This seems to be a bug in the firmware, but there isn't much I can do
> about it.
> Sorry, I have to NACK this patch.

  Could you please elaborate on how this patch would affect roaming or
other things. As far as I can see this patch doesn't change much
behavior apart from ignoring invalid values from firmware.
Disconnected antennas still get disabled (as before) connected
antennas still work (more often than before). So I'm not sure I can
see how this patch would change what firmware does at all. I really
hope you could find a moment and explain this.

Thanks!
Nikolay.
