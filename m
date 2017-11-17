Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37162 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbdKQJkH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2017 04:40:07 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Thomas Backlund <tmb@mageia.org>
Cc: <linux-wireless@vger.kernel.org>, ath10k@lists.infradead.org
Subject: Re: ath10k_pci / qca6174 firmware crash...
References: <6679116b-1bb3-bace-71de-5a21eea170f9@mageia.org>
Date: Fri, 17 Nov 2017 11:40:02 +0200
In-Reply-To: <6679116b-1bb3-bace-71de-5a21eea170f9@mageia.org> (Thomas
        Backlund's message of "Fri, 3 Nov 2017 18:49:43 +0200")
Message-ID: <87fu9djlal.fsf@purkki.adurom.net> (sfid-20171117_104014_688242_0270DACE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Backlund <tmb@mageia.org> writes:

> I have a Lenovo Yoga 720 running linux 4.13.10
>
>
> Got a firmware crash, and a reboot was needed to get the wireless back.
>
> is this known ?

Please CC ath10k list when reporting ath10k bugs. Adding it now.

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/support

Thomas' report:

> kernel logs:
>> [22881.494830] ath10k_pci 0000:3f:00.0: firmware crashed! (uuid n/a)
>> [22881.494840] ath10k_pci 0000:3f:00.0: qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 17aa:0827
>> [22881.494842] ath10k_pci 0000:3f:00.0: kconfig debug 1 debugfs 0 tracing 0 dfs 0 testmode 0
>> [22881.495227] ath10k_pci 0000:3f:00.0: firmware ver WLAN.RM.4.4.1-00051-QCARMSWP-1 api 6 features wowlan,ignore-otp crc32 c3fd4411
>> [22881.495495] ath10k_pci 0000:3f:00.0: board_file api 2 bmi_id N/A crc32 0e26ef70
>> [22881.495498] ath10k_pci 0000:3f:00.0: htt-ver 3.44 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1
>> [22881.507606] ath10k_pci 0000:3f:00.0: failed to get memcpy hi address for firmware address 4: -16
>> [22881.507607] ath10k_pci 0000:3f:00.0: failed to read firmware dump area: -16
>> [22881.507609] ath10k_pci 0000:3f:00.0: Copy Engine register dump:
>> [22881.507625] ath10k_pci 0000:3f:00.0: [00]: 0x00034400   2   2   3   3
>> [22881.507637] ath10k_pci 0000:3f:00.0: [01]: 0x00034800  24  24 357 358
>> [22881.507644] ath10k_pci 0000:3f:00.0: [02]: 0x00034c00  35  35  97  99
>> [22881.507655] ath10k_pci 0000:3f:00.0: [03]: 0x00035000   2   2   4   2
>> [22881.507663] ath10k_pci 0000:3f:00.0: [04]: 0x00035400 847 847 233 169
>> [22881.507672] ath10k_pci 0000:3f:00.0: [05]: 0x00035800   0   0  64   0
>> [22881.507684] ath10k_pci 0000:3f:00.0: [06]: 0x00035c00  26  26  26  26
>> [22881.507691] ath10k_pci 0000:3f:00.0: [07]: 0x00036000   1   1   1   1
>> [22881.571157] ieee80211 phy0: Hardware restart was requested
>> [22882.260322] ath10k_pci 0000:3f:00.0: Unknown eventid: 118809
>> [22882.262835] ath10k_pci 0000:3f:00.0: Unknown eventid: 90118
>> [22882.356074] ath10k_pci 0000:3f:00.0: device successfully recovered
>
>
>
> At this point network is still broken.
>
> Here I tried to disable/enable wireless to recover network access :
> (sometimes it work, but not this time)
>
>> [23596.617062] wlp63s0: deauthenticating from 18:8b:45:02:96:cf by local choice (Reason: 3=DEAUTH_LEAVING)
>> [23602.583145] ath10k_pci 0000:3f:00.0: Unknown eventid: 118809
>> [23602.585917] ath10k_pci 0000:3f:00.0: Unknown eventid: 90118
>> [23602.642812] IPv6: ADDRCONF(NETDEV_UP): wlp63s0: link is not ready
>> [23602.655518] IPv6: ADDRCONF(NETDEV_UP): wlp63s0: link is not ready
>> [23609.249013] ath10k_pci 0000:3f:00.0: failed to receive control response completion, polling..
>> [23609.281698] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x00000001 at 0x00034430: -110
>> [23609.314384] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x00034444: -110
>> [23609.347066] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x0000001e at 0x00034430: -110
>> [23609.379755] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x00000001 at 0x00034830: -110
>> [23609.412449] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x00000001 at 0x00035430: -110
>> [23609.445129] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x00035444: -110
>> [23609.477809] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x0000001e at 0x00035430: -110
>> [23609.510497] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x0000001e at 0x00034830: -110
>> [23609.543184] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x00000001 at 0x00034c30: -110
>> [23610.977362] ath10k_pci 0000:3f:00.0: ctl_resp never came in (-110)
>> [23610.977365] ath10k_pci 0000:3f:00.0: failed to connect to HTC: -110
>> [23614.269213] ath10k_warn: 112 callbacks suppressed
>> [23614.269215] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0xffff0800 at 0x00035010: -110
>> [23614.301897] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x00035010: -110
>> [23614.334583] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0xfffeffff at 0x00035010: -110
>> [23614.367258] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003504c: -110
>> [23614.399936] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x0000ffff at 0x0003504c: -110
>> [23614.432615] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003504c: -110
>> [23614.465293] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0xffff0020 at 0x0003504c: -110
>> [23614.497976] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x00035444: -110
>> [23614.530657] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003543c: -110
>> [23614.563341] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x0d040000 at 0x00035400: -110
>> [23618.745947] ath10k_pci 0000:3f:00.0: failed to read device register, device is gone
>> [23619.277892] ath10k_warn: 143 callbacks suppressed
>> [23619.277895] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0xfffeffff at 0x00034410: -110
>> [23619.310205] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003444c: -110
>> [23619.342469] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x0000ffff at 0x0003444c: -110
>> [23619.375152] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003444c: -110
>> [23619.407560] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0xffff0010 at 0x0003444c: -110
>> [23619.440211] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x00034848: -110
>> [23619.472846] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x00034840: -110
>> [23619.505155] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x0d03e000 at 0x00034808: -110
>> [23619.537721] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0x00000200 at 0x0003480c: -110
>> [23619.570447] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x00034810: -110
>> [23624.291033] ath10k_warn: 144 callbacks suppressed
>> [23624.291036] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23624.323722] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23624.356179] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23624.388309] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23624.420669] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23624.453327] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23624.485783] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23624.517940] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23624.550562] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23624.582722] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23624.745569] ath10k_pci 0000:3f:00.0: failed to read device register, device is gone
>> [23626.469140] ath10k_pci 0000:3f:00.0: Could not init core: -110
>> [23626.481714] IPv6: ADDRCONF(NETDEV_UP): wlp63s0: link is not ready
>> [23650.593887] ath10k_warn: 59 callbacks suppressed
>> [23650.593889] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x00080008: -110
>> [23650.626577] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0xffffffff at 0x00080008: -110
>> [23650.680865] ath10k_pci 0000:3f:00.0: failed to wake target for write32 of 0xfffffffe at 0x00080008: -110
>> [23650.735049] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23650.767735] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23650.800425] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23650.833110] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23650.865796] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23650.898478] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23650.931164] ath10k_pci 0000:3f:00.0: failed to wake target for read32 at 0x0003a028: -110
>> [23653.871963] ath10k_pci 0000:3f:00.0: failed to read device register, device is gone
>> [23653.970010] ath10k_pci 0000:3f:00.0: firmware crashed! (uuid n/a)
>> [23653.970013] ath10k_pci 0000:3f:00.0: qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 17aa:0827
>> [23653.970014] ath10k_pci 0000:3f:00.0: kconfig debug 1 debugfs 0 tracing 0 dfs 0 testmode 0
>> [23653.970387] ath10k_pci 0000:3f:00.0: firmware ver WLAN.RM.4.4.1-00051-QCARMSWP-1 api 6 features wowlan,ignore-otp crc32 c3fd4411
>> [23653.970644] ath10k_pci 0000:3f:00.0: board_file api 2 bmi_id N/A crc32 0e26ef70
>> [23653.970645] ath10k_pci 0000:3f:00.0: htt-ver 3.44 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1
>> [23654.472884] ath10k_pci 0000:3f:00.0: failed to read firmware dump area: -16
>> [23654.472886] ath10k_pci 0000:3f:00.0: Copy Engine register dump:
>> [23654.603625] ath10k_pci 0000:3f:00.0: [00]: 0x00034400 4294967295 4294967295 4294967295 4294967295
>> [23654.734356] ath10k_pci 0000:3f:00.0: [01]: 0x00034800 4294967295 4294967295 4294967295 4294967295
>> [23654.865098] ath10k_pci 0000:3f:00.0: [02]: 0x00034c00 4294967295 4294967295 4294967295 4294967295
>> [23654.995839] ath10k_pci 0000:3f:00.0: [03]: 0x00035000 4294967295 4294967295 4294967295 4294967295
>> [23655.126570] ath10k_pci 0000:3f:00.0: [04]: 0x00035400 4294967295 4294967295 4294967295 4294967295
>> [23655.257293] ath10k_pci 0000:3f:00.0: [05]: 0x00035800 4294967295 4294967295 4294967295 4294967295
>> [23655.388016] ath10k_pci 0000:3f:00.0: [06]: 0x00035c00 4294967295 4294967295 4294967295 4294967295
>> [23655.518515] ath10k_pci 0000:3f:00.0: [07]: 0x00036000 4294967295 4294967295 4294967295 4294967295
>> [23655.518530] ath10k_pci 0000:3f:00.0: failed to reset chip: -5
>> [23655.518531] ath10k_pci 0000:3f:00.0: Could not init hif: -5
>
>
> --
> Thomas

-- 
Kalle Valo
