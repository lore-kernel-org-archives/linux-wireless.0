Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36087 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab2EUHa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 03:30:58 -0400
Received: by yhmm54 with SMTP id m54so4107383yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2012 00:30:58 -0700 (PDT)
Message-ID: <4FB9EF2E.3000900@opensuse.org> (sfid-20120521_093102_888035_B222ADB8)
Date: Mon, 21 May 2012 03:30:54 -0400
From: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi: Driver unmaps unmatched page at PFN ffe70000
References: <4FB7F52D.7020904@opensuse.org> <CANUX_P3_LMpXaBXYVwfB+UiqwZeAhZ+1ErLtgXO3ejCMaCtHLw@mail.gmail.com>
In-Reply-To: <CANUX_P3_LMpXaBXYVwfB+UiqwZeAhZ+1ErLtgXO3ejCMaCtHLw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21/05/12 01:12, Emmanuel Grumbach wrote:
> On Sat, May 19, 2012 at 10:31 PM, Cristian Rodríguez
> <crrodriguez@opensuse.org>  wrote:
>>
>> On resume, I get the following warning
>>
>> [43265.744510] ------------[ cut here ]------------
>> [43265.744516] WARNING: at
>> /usr/src/linux-3.4.0-rc7-2/drivers/iommu/intel-iommu.c:2922
>> intel_unmap_page+0x15d/0x1c0()
>> [43265.744518] Hardware name: Dell System XPS 15Z
>> [43265.744519] Driver unmaps unmatched page at PFN ffe70000
>> [43265.744520] Modules linked in: fuse rfcomm af_packet bnep arc4 iwlwifi
>> btusb bluetooth mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek
>> dell_laptop dcdbas kvm_intel snd_hda_intel snd_hda_codec kvm cfg80211
>> snd_hwdep uvcvideo snd_pcm snd_timer videobuf2_core snd videodev sr_mod
>> mei(C) edd sg cdrom soundcore videobuf2_vmalloc coretemp rfkill dell_wmi
>> iTCO_wdt i2c_i801 videobuf2_memops microcode snd_page_alloc sparse_keymap
>> battery pcspkr ac iTCO_vendor_support autofs4 sha256_generic dm_crypt dm_mod
>> linear btrfs zlib_deflate libcrc32c nouveau ttm mxm_wmi ghash_clmulni_intel
>> crc32c_intel i915 wmi drm_kms_helper drm i2c_algo_bit xhci_hcd button video
>> aesni_intel cryptd aes_x86_64 fan thermal processor thermal_sys
>> [43265.744560] Pid: 2378, comm: NetworkManager Tainted: G         C
>> 3.4.0-rc7-2-desktop-test #1
>
> Can you please give a try to this one ?
>
> http://www.spinics.net/lists/linux-wireless/msg90507.html

Hi:

Ok, I applied that patch to this kernel with an slight modification 
(there are no txq->entries but txq->skbs on this version)

the system works, however trying to reproduce this problem again might 
not be so easy, according to my logs, this warning has happened only 4 
times in 5 months..


