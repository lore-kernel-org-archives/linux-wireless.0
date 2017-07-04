Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54842 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbdGDNxz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 09:53:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON_ONCE(work > weight) in napi_poll()
Date: Tue, 4 Jul 2017 13:49:53 +0000
Message-ID: <87wp7oia6j.fsf@kamboji.qca.qualcomm.com> (sfid-20170704_155429_192959_90E3A9FD)
References: <26670dce-4dd2-f8e4-0e14-90d74257e739@virtuozzo.com>
In-Reply-To: <26670dce-4dd2-f8e4-0e14-90d74257e739@virtuozzo.com> (Andrey
        Ryabinin's message of "Fri, 30 Jun 2017 19:34:44 +0300")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Ryabinin <aryabinin@virtuozzo.com> writes:

> I occasionally hit WARN_ON_ONCE(work > weight); in napi_poll() on a
> laptop with ath10k card.
>
>
> [37207.593370] ------------[ cut here ]------------
> [37207.593380] WARNING: CPU: 0 PID: 7 at ../net/core/dev.c:5274
> net_rx_action+0x258/0x360
> [37207.593381] Modules linked in: snd_hda_codec_realtek snd_soc_skl
> snd_hda_codec_generic snd_soc_skl_ipc snd_soc_sst_ipc snd_soc_sst_dsp
> snd_hda_ext_core snd_soc_sst_match snd_soc_core rtsx_pci_sdmmc
> mmc_core snd_pcm_dmaengine x86_pkg_temp_thermal snd_hda_intel uvcvideo
> kvm_intel videobuf2_vmalloc kvm snd_hda_codec snd_hwdep btusb
> videobuf2_memops btintel snd_hda_core videobuf2_v4l2 bluetooth
> irqbypass snd_pcm videobuf2_core crc32c_intel videodev mei_me mei
> rtsx_pci intel_lpss_pci intel_lpss_acpi intel_vbtn intel_lpss mfd_core
> tpm_tis intel_hid tpm_tis_core tpm efivarfs
> [37207.593430] CPU: 0 PID: 7 Comm: ksoftirqd/0 Not tainted 4.11.7 #28
> [37207.593432] Hardware name: Dell Inc. XPS 13 9360/0839Y6, BIOS 1.3.5 05=
/08/2017

What firmware and hardware versions exactly? The dmesg output when
ath10k loads is preferred. As you are using XPS 13 I'm guessing it's one
of QCA6174 family.

--=20
Kalle Valo=
