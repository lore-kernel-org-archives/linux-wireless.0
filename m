Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33277 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbcBBPgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 10:36:47 -0500
Subject: Re: [PATCH] rtlwifi: Fix warning from ieee80211_get_tx_rates() when
 using 5G
To: Kalle Valo <kvalo@codeaurora.org>
References: <1454353134-29939-1-git-send-email-Larry.Finger@lwfinger.net>
 <87zivjh6jg.fsf@kamboji.qca.qualcomm.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Stable <stable@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56B0CD0C.9010702@lwfinger.net> (sfid-20160202_163652_724960_B638309A)
Date: Tue, 2 Feb 2016 09:36:44 -0600
MIME-Version: 1.0
In-Reply-To: <87zivjh6jg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2016 02:15 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> When using a 5G-capable device with VHT rates enabled, the following
>> warning results:
>>
>> WARNING: CPU: 3 PID: 2253 at net/mac80211/rate.c:625 ieee80211_get_tx_rates+0x22e/0x620 [mac80211]()
>> Modules linked in: rtl8821ae btcoexist rtl_pci rtlwifi fuse drbg ansi_cprng ctr ccm bnep bluetooth af_packet nfs fscache vboxpci(O) vboxnetadp(O) vboxne
>> tflt(O) vboxdrv(O) arc4 snd_hda_codec_generic x86_pkg_temp_thermal rtsx_pci_sdmmc mmc_core rtsx_pci_ms kvm_intel memstick iwlmvm kvm mac80211 snd_hda_intel snd_hda_cod
>> ec snd_hwdep snd_hda_core irqbypass snd_pcm iwlwifi crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 snd_timer lrw gf128mul glue_h
>> elper ablk_helper cryptd snd cfg80211 pcspkr serio_raw e1000e rtsx_pci lpc_ich ptp xhci_pci mfd_core pps_core xhci_hcd soundcore toshiba_acpi thermal sparse_keymap wmi
>>   toshiba_bluetooth rfkill acpi_cpufreq battery ac processor dm_mod i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
>> drm sr_mod cdrom video button sg autofs4 [last unloaded: rtlwifi]
>> CPU: 3 PID: 2253 Comm: Timer Tainted: G        W  O    4.5.0-rc1-wl+ #79
>> Hardware name: TOSHIBA TECRA A50-A/TECRA A50-A, BIOS Version 4.20   04/17/2014
>>    ffffffffa05c4be6 ffff8802262036d8 ffffffff813d7912 0000000000000000
>>    ffff880226203710 ffffffff8106bcb6 ffff8800c6831300 ffff8800c6831330
>>    0000000000000000 ffff8800c683133c ffff880065923638 ffff880226203720
>> Call Trace:
>>    <IRQ>  [<ffffffff813d7912>] dump_stack+0x4b/0x79
>>    [<ffffffff8106bcb6>] warn_slowpath_common+0x86/0xc0
>>    [<ffffffff8106bdaa>] warn_slowpath_null+0x1a/0x20
>>    [<ffffffffa05511ee>] ieee80211_get_tx_rates+0x22e/0x620 [mac80211]
>>    [<ffffffffa0782232>] ? rtl_is_special_data+0x32/0x240 [rtlwifi]
>>    [<ffffffffa055209e>] ? rate_control_get_rate+0xce/0x150 [mac80211]
>>    [<ffffffff810bfc7d>] ? trace_hardirqs_on+0xd/0x10
>>    [<ffffffff81071cc5>] ? __local_bh_enable_ip+0x65/0xd0
>> --- traceback terminated here ---
>>
>> The problem is that IEEE80211_TX_RC_VHT_MCS is not set in the rate flags.
>>
>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Tested-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org>
>
> Isn't the commit log somewhat misleading as VHT was completely _broken_?
> Do you mind if I change the commit log to this:
>
> ----------------------------------------------------------------------
> rtlwifi: fix broken VHT support
>
> When using a 5G-capable device with VHT (802.11ac) rates enabled was not
> working (packets were not delivered) and the following mac80211 warning
> was printed:

That change is fine.

Larry


