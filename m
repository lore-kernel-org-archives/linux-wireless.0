Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60043 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2D2Fbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2012 01:31:37 -0400
Received: by wejx9 with SMTP id x9so1210724wej.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Apr 2012 22:31:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3SFmNKqUTt53EHkAjupAoB8ZxQZZP1osm7=JwfHnwbqg@mail.gmail.com>
References: <CAOvK7nAOHqKC8rpFDqGnW7NLCX-G2+syRGih_rv7N5O5rfOUdA@mail.gmail.com>
	<CANUX_P1t8XJOka-QGzZSYFHb6MLc7rm4madn059Yg4b6hJB49A@mail.gmail.com>
	<CAOvK7nDO4fS6R5go+ZXYBqyQc8hhbJGun9Weh=-EyX5k11+tXw@mail.gmail.com>
	<CANUX_P2rzvDCBVLmU2rfaZmUOCMuMDe5=TXE_jwxq4ULrvc=QQ@mail.gmail.com>
	<CAOvK7nCwRbDNZSnn0EvFMpcQMvX1DmU-tBuFT4kRW1TigwyJDQ@mail.gmail.com>
	<CANUX_P0JsyA53T_vs5Ea0pE5Ye4G9xRC4xKcdwgAmoC8E63sHg@mail.gmail.com>
	<CAOvK7nCf6k_ugJ=UBF8y0VBr_kVmESpetfnpn=NW73r_K=kKyw@mail.gmail.com>
	<CAOvK7nCGwqqqrWNQhPqZoBqs6eT11gQNYbrZhb0bNSPTS-YxEw@mail.gmail.com>
	<CANUX_P2DDQ-U9Yz2YksEEpOgjyyYO1GnFHR8ogEHNwojKvn3yg@mail.gmail.com>
	<CAOvK7nB0L9GcnV-cNONndZMrAVLfFf3VaY4T-gPb+FgrNByeSA@mail.gmail.com>
	<CANUX_P38L7OqBNeK+jO0EPMHf1M3QKxmsTA6o-t+6ujoq1VJ5w@mail.gmail.com>
	<CAOvK7nB1gnnWcv6HFrn1MhMe-FheRtdTpi+BhCcCYNx6RowaTQ@mail.gmail.com>
	<CANUX_P3SFmNKqUTt53EHkAjupAoB8ZxQZZP1osm7=JwfHnwbqg@mail.gmail.com>
Date: Sun, 29 Apr 2012 08:31:36 +0300
Message-ID: <CANUX_P1ivcpLxm4z5k8SU+hGXG0A1hbSMnps7_i025kaAThyCg@mail.gmail.com> (sfid-20120429_073213_236660_FD94B3AB)
Subject: Re: iwlwifi bug
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: dchyan@princeton.edu
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 26, 2012 at 21:11, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Thanks,
>
> this log is very instructive. Obviously we have a bug in the state
> machine. Will send you a patch for further investigation.
>

Can you try again with debug=0x84000000
If you can enable CONFIG_MAC80211_HT_DEBUG it would help too.

I also would like to see the code you are running. Can you please tell
me what is that build you are talking about "latest build
(2012-04-23)"  ?

Thanks


> Thanks for reporting.
>
> Emmanuel Grumbach
> egrumbach@gmail.com
>
>
> On Wed, Apr 25, 2012 at 22:33, Daniel Chyan <dchyan@princeton.edu> wrote:
>> I have attached the relevant log.
>>
>> On Wed, Apr 25, 2012 at 8:45 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> Just reload the module with debug=0x80000000 and when you see that
>>> warning send me the whole log (output of dmesg).
>>>
>>> Thanks
>>>
>>> Emmanuel Grumbach
>>> egrumbach@gmail.com
>>>
>>>
>>> On Wed, Apr 25, 2012 at 14:56, Daniel Chyan <dchyan@princeton.edu> wrote:
>>>> Yes, I am using compat-wireless. I have set the flag and recompiled.
>>>> Which log do you want exactly?
>>>>
>>>> On Wed, Apr 25, 2012 at 3:18 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>>> I understand you sue compat right ?
>>>>> In that case just edit the config.mk file and set the flag there.
>>>>>
>>>>> I will need the full log and apparently the debug flags I requested isn't set.
>>>>>
>>>>>
>>>>>
>>>>> On Wed, Apr 25, 2012 at 09:24, Daniel Chyan <dchyan@princeton.edu> wrote:
>>>>>> I appreciate your patience with this thread. These drivers have been awesome.
>>>>>> A challenge to reproducing the original warning is also a seemingly
>>>>>> excessive time to associate at times. For example:
>>>>>>
>>>>>> ... (200 more times or so as well.)
>>>>>> [  892.585058] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  892.590706] wlan0: direct probe responded
>>>>>> [  892.592991] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  892.597123] wlan0: direct probe responded
>>>>>> [  892.600979] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  892.608344] wlan0: direct probe responded
>>>>>> [  892.608991] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  892.613117] wlan0: direct probe responded
>>>>>> [  892.616981] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  892.621120] wlan0: direct probe responded
>>>>>> [  892.624929] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  892.629038] wlan0: direct probe responded
>>>>>> [  892.632944] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  892.637057] wlan0: direct probe responded
>>>>>> [  892.640852] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  892.644983] wlan0: direct probe responded
>>>>>> [  892.648843] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  892.852281] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 2/3)
>>>>>> [  893.055683] wlan0: direct probe to c0:c1:c0:0e:d3:19 (try 3/3)
>>>>>> [  893.259123] wlan0: authentication with c0:c1:c0:0e:d3:19 timed out
>>>>>> [  893.260852] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active
>>>>>> station id 0 addr c0:c1:c0:0e:d3:19
>>>>>> [  901.518568] wlan0: authenticate with c0:c1:c0:0e:d3:19
>>>>>> [  901.525227] wlan0: send auth to c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  901.527106] wlan0: authenticated
>>>>>> [  901.528255] wlan0: associate with c0:c1:c0:0e:d3:19 (try 1/3)
>>>>>> [  901.531724] wlan0: RX AssocResp from c0:c1:c0:0e:d3:19 (capab=0x411
>>>>>> status=0 aid=1)
>>>>>> [  901.531738] wlan0: associated
>>>>>> [  901.536691] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>>>>>>
>>>>>> On Wed, Apr 25, 2012 at 2:17 AM, Daniel Chyan <dchyan@princeton.edu> wrote:
>>>>>>> Just to confirm, the commands are "sudo make CONFIG_IWLWIFI_DEBUG=y"
>>>>>>> and then "sudo make install"?
>>>>>>>
>>>>>>> If those commands are correct, here is the dmesg output:
>>>>>>>
>>>>>>> [  422.515639] ------------[ cut here ]------------
>>>>>>> [  422.515688] WARNING: at
>>>>>>> /home/foo/bar/ness/compat-wireless-2012-04-23/net/mac80211/driver-ops.h:12
>>>>>>> ieee80211_bss_info_change_notify+0x2d1/0x2e0 [mac80211]()
>>>>>>> [  422.515696] Hardware name: 4177CTO
>>>>>>> [  422.515700] wlan0:  Failed check-sdata-in-driver check, flags: 0x4
>>>>>>> [  422.515704] Modules linked in: btrfs zlib_deflate libcrc32c ufs
>>>>>>> qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs reiserfs parport_pc
>>>>>>> ppdev snd_hda_codec_hdmi snd_hda_codec_conexant bnep rfcomm bluetooth
>>>>>>> speedstep_lib binfmt_misc snd_hda_intel snd_hda_codec snd_hwdep
>>>>>>> snd_pcm thinkpad_acpi snd_seq_midi snd_rawmidi i915 arc4
>>>>>>> snd_seq_midi_event snd_seq snd_timer snd_seq_device iwlwifi(-)
>>>>>>> uvcvideo psmouse videodev mei(C) v4l2_compat_ioctl32 tpm_tis snd
>>>>>>> drm_kms_helper nvram drm i2c_algo_bit soundcore serio_raw
>>>>>>> snd_page_alloc mac80211 cfg80211 wmi compat video lp parport usbhid
>>>>>>> hid firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci ahci libahci
>>>>>>> e1000e
>>>>>>> [  422.515801] Pid: 19766, comm: modprobe Tainted: G         C
>>>>>>> 3.0.0-17-generic #30-Ubuntu
>>>>>>> [  422.515806] Call Trace:
>>>>>>> [  422.515823]  [<ffffffff8105e8ff>] warn_slowpath_common+0x7f/0xc0
>>>>>>> [  422.515832]  [<ffffffff8105e9f6>] warn_slowpath_fmt+0x46/0x50
>>>>>>> [  422.515858]  [<ffffffffa010e70e>] ? __sta_info_destroy+0x1e/0x560 [mac80211]
>>>>>>> [  422.515881]  [<ffffffffa010aa11>]
>>>>>>> ieee80211_bss_info_change_notify+0x2d1/0x2e0 [mac80211]
>>>>>>> [  422.515915]  [<ffffffffa012f6f0>]
>>>>>>> ieee80211_destroy_auth_data+0x50/0x80 [mac80211]
>>>>>>> [  422.515948]  [<ffffffffa01353c1>] ieee80211_mgd_teardown+0x51/0x70 [mac80211]
>>>>>>> [  422.515975]  [<ffffffffa0118aec>]
>>>>>>> ieee80211_teardown_sdata+0xdc/0x100 [mac80211]
>>>>>>> [  422.515985]  [<ffffffff814dd9e0>] rollback_registered_many+0x1a0/0x260
>>>>>>> [  422.515993]  [<ffffffff814ddabb>] unregister_netdevice_many+0x1b/0x80
>>>>>>> [  422.516019]  [<ffffffffa0119c20>]
>>>>>>> ieee80211_remove_interfaces+0xd0/0x110 [mac80211]
>>>>>>> [  422.516042]  [<ffffffffa0109133>]
>>>>>>> ieee80211_unregister_hw+0x53/0x120 [mac80211]
>>>>>>> [  422.516063]  [<ffffffffa026d24b>] iwlagn_mac_unregister+0x2b/0x40 [iwlwifi]
>>>>>>> [  422.516081]  [<ffffffffa02653b1>] iwl_op_mode_dvm_stop+0x51/0xe0 [iwlwifi]
>>>>>>> [  422.516106]  [<ffffffffa0285c27>] iwl_drv_stop+0x47/0x70 [iwlwifi]
>>>>>>> [  422.516135]  [<ffffffffa029b34f>] iwl_pci_remove+0x22/0xcd3 [iwlwifi]
>>>>>>> [  422.516148]  [<ffffffff81312736>] pci_device_remove+0x46/0x110
>>>>>>> [  422.516162]  [<ffffffff813d06bc>] __device_release_driver+0x7c/0xe0
>>>>>>> [  422.516174]  [<ffffffff813d0e48>] driver_detach+0xc8/0xd0
>>>>>>> [  422.516186]  [<ffffffff813d0519>] bus_remove_driver+0x79/0xd0
>>>>>>> [  422.516198]  [<ffffffff813d1602>] driver_unregister+0x62/0xa0
>>>>>>> [  422.516210]  [<ffffffff813115b5>] pci_unregister_driver+0x45/0xc0
>>>>>>> [  422.516240]  [<ffffffffa02848e5>]
>>>>>>> iwl_pci_unregister_driver+0x15/0x20 [iwlwifi]
>>>>>>> [  422.516270]  [<ffffffffa029aa59>] iwl_exit+0x9/0x1c [iwlwifi]
>>>>>>> [  422.516282]  [<ffffffff8109f1ce>] sys_delete_module+0x18e/0x250
>>>>>>> [  422.516294]  [<ffffffff81135593>] ? do_munmap+0x1f3/0x2f0
>>>>>>> [  422.516307]  [<ffffffff815fb342>] system_call_fastpath+0x16/0x1b
>>>>>>> [  422.516315] ---[ end trace 45b9addccc842009 ]---
>>>>>>> [  422.560312] iwlwifi 0000:03:00.0: PCI INT A disabled
>>>>>>> [  432.738352] cfg80211: Calling CRDA to update world regulatory domain
>>>>>>> [  432.748736] cfg80211: World regulatory domain updated:
>>>>>>> [  432.748745] cfg80211:   (start_freq - end_freq @ bandwidth),
>>>>>>> (max_antenna_gain, max_eirp)
>>>>>>> [  432.748755] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
>>>>>>> (300 mBi, 2000 mBm)
>>>>>>> [  432.748762] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
>>>>>>> (300 mBi, 2000 mBm)
>>>>>>> [  432.748769] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
>>>>>>> (300 mBi, 2000 mBm)
>>>>>>> [  432.748776] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
>>>>>>> (300 mBi, 2000 mBm)
>>>>>>> [  432.748782] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
>>>>>>> (300 mBi, 2000 mBm)
>>>>>>> [  432.753876] iwlwifi: Unknown parameter `debug'
>>>>>>>
>>>>>>> - Daniel
>>>>>>>
>>>>>>> On Wed, Apr 25, 2012 at 2:07 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>>>>>> On Wed, Apr 25, 2012 at 08:58, Daniel Chyan <dchyan@princeton.edu> wrote:
>>>>>>>>> Correct me if I did it incorrectly. I issue "sudo modprobe iwlwifi
>>>>>>>>> debug=0x80000000" but I receive an "Unknown symbol in module, or
>>>>>>>>> unknown parameter" error.
>>>>>>>>>
>>>>>>>>
>>>>>>>> All right, please compile with CONFIG_IWLWIFI_DEBUG=y
