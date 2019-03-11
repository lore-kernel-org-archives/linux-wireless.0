Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9DFC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B065920657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfCKPrp convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:47:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:14797 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbfCKPrp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 11:47:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2019 08:47:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,468,1544515200"; 
   d="scan'208";a="202818140"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga001.jf.intel.com with ESMTP; 11 Mar 2019 08:47:44 -0700
Message-ID: <e0630ae9d9bee73d8a1ce3499ea9f77900e9cdfa.camel@linux.intel.com>
Subject: Re: [PATCH] iommu/amd: fix sg->dma_address for sg->offset bigger
 than PAGE_SIZE
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Rosen Penev <rosenp@gmail.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, jan.viktorin@gmail.com
Date:   Mon, 11 Mar 2019 08:47:44 -0700
In-Reply-To: <20190311090314.GB3310@redhat.com>
References: <20190226103450.GA2989@redhat.com>
         <20190226104413.GH20740@8bytes.org> <20190226112407.GB2989@redhat.com>
         <20190228090411.GA24938@redhat.com> <20190228104223.GA2749@redhat.com>
         <20190228121948.GD6072@redhat.com> <20190228134029.GC1594@8bytes.org>
         <20190304071037.GA2787@redhat.com>
         <CAKxU2N-k-9DCYBv6W3CohL963dr3AeY3VHyt8FrUuo=BfacDsw@mail.gmail.com>
         <20190311084319.GA3310@redhat.com> <20190311090314.GB3310@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-03-11 at 10:03 +0100, Stanislaw Gruszka wrote:
> Take into account that sg->offset can be bigger than PAGE_SIZE when
> setting segment sg->dma_address. Otherwise sg->dma_address will point
> at diffrent page, what makes DMA not possible with erros like this:
> 
> xhci_hcd 0000:38:00.3: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000fdaa70c0 flags=0x0020]
> xhci_hcd 0000:38:00.3: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000fdaa7040 flags=0x0020]
> xhci_hcd 0000:38:00.3: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000fdaa7080 flags=0x0020]
> xhci_hcd 0000:38:00.3: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000fdaa7100 flags=0x0020]
> xhci_hcd 0000:38:00.3: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000fdaa7000 flags=0x0020]
> 
> Additinally with wrong sg->dma_address unmap_sg will free wrong pages,
> what what can cause crashes like this:
> 
> Feb 28 19:27:45 kernel: BUG: Bad page state in process cinnamon  pfn:39e8b1
> Feb 28 19:27:45 kernel: Disabling lock debugging due to kernel taint
> Feb 28 19:27:45 kernel: flags: 0x2ffff0000000000()
> Feb 28 19:27:45 kernel: raw: 02ffff0000000000 0000000000000000 ffffffff00000301 0000000000000000
> Feb 28 19:27:45 kernel: raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
> Feb 28 19:27:45 kernel: page dumped because: nonzero _refcount
> Feb 28 19:27:45 kernel: Modules linked in: ccm fuse arc4 nct6775 hwmon_vid amdgpu nls_iso8859_1 nls_cp437 edac_mce_amd vfat fat kvm_amd ccp rng_core kvm mt76x0u mt76x0_common mt76x02_usb irqbypass mt76_usb mt76x02_lib mt76 crct10dif_pclmul crc32_pclmul chash mac80211 amd_iommu_v2 ghash_clmulni_intel gpu_sched i2c_algo_bit ttm wmi_bmof snd_hda_codec_realtek snd_hda_codec_generic drm_kms_helper snd_hda_codec_hdmi snd_hda_intel drm snd_hda_codec aesni_intel snd_hda_core snd_hwdep aes_x86_64 crypto_simd snd_pcm cfg80211 cryptd mousedev snd_timer glue_helper pcspkr r8169 input_leds realtek agpgart libphy rfkill snd syscopyarea sysfillrect sysimgblt fb_sys_fops soundcore sp5100_tco k10temp i2c_piix4 wmi evdev gpio_amdpt pinctrl_amd mac_hid pcc_cpufreq acpi_cpufreq sg ip_tables x_tables ext4(E) crc32c_generic(E) crc16(E) mbcache(E) jbd2(E) fscrypto(E) sd_mod(E) hid_generic(E) usbhid(E) hid(E) dm_mod(E) serio_raw(E) atkbd(E) libps2(E) crc32c_intel(E) ahci(E) libahci(E) libata(E) xhci_pci(E
 ) xhci_hcd(E)
> Feb 28 19:27:45 kernel:  scsi_mod(E) i8042(E) serio(E) bcache(E) crc64(E)
> Feb 28 19:27:45 kernel: CPU: 2 PID: 896 Comm: cinnamon Tainted: G    B   W   E     4.20.12-arch1-1-custom #1
> Feb 28 19:27:45 kernel: Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./B450M Pro4, BIOS P1.20 06/26/2018
> Feb 28 19:27:45 kernel: Call Trace:
> Feb 28 19:27:45 kernel:  dump_stack+0x5c/0x80
> Feb 28 19:27:45 kernel:  bad_page.cold.29+0x7f/0xb2
> Feb 28 19:27:45 kernel:  __free_pages_ok+0x2c0/0x2d0
> Feb 28 19:27:45 kernel:  skb_release_data+0x96/0x180
> Feb 28 19:27:45 kernel:  __kfree_skb+0xe/0x20
> Feb 28 19:27:45 kernel:  tcp_recvmsg+0x894/0xc60
> Feb 28 19:27:45 kernel:  ? reuse_swap_page+0x120/0x340
> Feb 28 19:27:45 kernel:  ? ptep_set_access_flags+0x23/0x30
> Feb 28 19:27:45 kernel:  inet_recvmsg+0x5b/0x100
> Feb 28 19:27:45 kernel:  __sys_recvfrom+0xc3/0x180
> Feb 28 19:27:45 kernel:  ? handle_mm_fault+0x10a/0x250
> Feb 28 19:27:45 kernel:  ? syscall_trace_enter+0x1d3/0x2d0
> Feb 28 19:27:45 kernel:  ? __audit_syscall_exit+0x22a/0x290
> Feb 28 19:27:45 kernel:  __x64_sys_recvfrom+0x24/0x30
> Feb 28 19:27:45 kernel:  do_syscall_64+0x5b/0x170
> Feb 28 19:27:45 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Cc: stable@vger.kernel.org
> Reported-and-tested-by: jan.viktorin@gmail.com
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/iommu/amd_iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index 6b0760dafb3e..949621f33624 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -2604,7 +2604,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
>  
>  	/* Everything is mapped - write the right values into s->dma_address */
>  	for_each_sg(sglist, s, nelems, i) {
> -		s->dma_address += address + s->offset;
> +		s->dma_address += address + (s->offset & ~PAGE_MASK);
>  		s->dma_length   = s->length;
>  	}
>  

You should add a comment calling out that this is needed because the
sg_phys(s) call above this is masked with PAGE_MASK. Then this makes
much more sense. Otherwise I would have assumed you needed either the
full offset or none.

Other than that, from that I can tell the code itself looks to be
correct, but just difficult to read.

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

