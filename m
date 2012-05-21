Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45979 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab2EUJ3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 05:29:04 -0400
Received: by wgbdr13 with SMTP id dr13so4780999wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2012 02:29:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB9EF2E.3000900@opensuse.org>
References: <4FB7F52D.7020904@opensuse.org>
	<CANUX_P3_LMpXaBXYVwfB+UiqwZeAhZ+1ErLtgXO3ejCMaCtHLw@mail.gmail.com>
	<4FB9EF2E.3000900@opensuse.org>
Date: Mon, 21 May 2012 12:29:02 +0300
Message-ID: <CANUX_P0KyAqah9fxry5+3Lqopj9sA8UkUdB6joHohkO4wdBC6g@mail.gmail.com> (sfid-20120521_112910_707864_97D930A4)
Subject: Re: iwlwifi: Driver unmaps unmatched page at PFN ffe70000
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> On Sat, May 19, 2012 at 10:31 PM, Cristian Rodríguez
>> <crrodriguez@opensuse.org>  wrote:
>>>
>>>
>>> On resume, I get the following warning
>>>
>>> [43265.744510] ------------[ cut here ]------------
>>> [43265.744516] WARNING: at
>>> /usr/src/linux-3.4.0-rc7-2/drivers/iommu/intel-iommu.c:2922
>>> intel_unmap_page+0x15d/0x1c0()
>>> [43265.744518] Hardware name: Dell System XPS 15Z
>>> [43265.744519] Driver unmaps unmatched page at PFN ffe70000
>>> [43265.744520] Modules linked in: fuse rfcomm af_packet bnep arc4 iwlwifi
>>> btusb bluetooth mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek
>>> dell_laptop dcdbas kvm_intel snd_hda_intel snd_hda_codec kvm cfg80211
>>> snd_hwdep uvcvideo snd_pcm snd_timer videobuf2_core snd videodev sr_mod
>>> mei(C) edd sg cdrom soundcore videobuf2_vmalloc coretemp rfkill dell_wmi
>>> iTCO_wdt i2c_i801 videobuf2_memops microcode snd_page_alloc sparse_keymap
>>> battery pcspkr ac iTCO_vendor_support autofs4 sha256_generic dm_crypt
>>> dm_mod
>>> linear btrfs zlib_deflate libcrc32c nouveau ttm mxm_wmi
>>> ghash_clmulni_intel
>>> crc32c_intel i915 wmi drm_kms_helper drm i2c_algo_bit xhci_hcd button
>>> video
>>> aesni_intel cryptd aes_x86_64 fan thermal processor thermal_sys
>>> [43265.744560] Pid: 2378, comm: NetworkManager Tainted: G         C
>>> 3.4.0-rc7-2-desktop-test #1
>>
>>
>> Can you please give a try to this one ?
>>
>> http://www.spinics.net/lists/linux-wireless/msg90507.html
>
>
> Hi:
>
> Ok, I applied that patch to this kernel with an slight modification (there
> are no txq->entries but txq->skbs on this version)
>
> the system works, however trying to reproduce this problem again might not
> be so easy, according to my logs, this warning has happened only 4 times in
> 5 months..
>
>

if it is not easy to reproduce, then I would recommend to wait until
the patch gets merged so that you can get it cleanly without
modification.
