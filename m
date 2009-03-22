Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:13793 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbZCVR3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 13:29:13 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1804683ywb.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 10:29:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237581564.21165.5.camel@abhi-desktop>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236649234.6685.9.camel@rainbow> <1236661466.15923.53.camel@rc-desk>
	 <1236742805.6267.9.camel@rainbow>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
	 <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
	 <1237254243.13077.33.camel@rainbow> <1237427568.6943.13.camel@rainbow>
	 <c4d76b3b0903191822l5494f268h395acc4a14608239@mail.gmail.com>
	 <1237581564.21165.5.camel@abhi-desktop>
Date: Sun, 22 Mar 2009 13:29:10 -0400
Message-ID: <c4d76b3b0903221029r21282bbbs13a8af06f9d8ce2@mail.gmail.com> (sfid-20090322_182917_470107_B8549037)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch did not work.

However, I do not think it's an alignment issue.

pci_map_single on x86_64 with >3G memory and no IOMMU uses the swiotlb
by default.  swiotlb provides "bounce buffers" for physical addresses
over 4GB.  So for memory where the kmalloc value is at a physical
address over 2**32, pci_map_single will copy to a swiotlb slot.  That
means the dma_handle return value of pci_map_single is not necessarily
the physical address of the virtual address.

In iwl3945_tx_skb (iwl3945-base.c line 1099) use the pci_map_single
which copies the memory of out_cmd at that time.  However,
iwl3945_build_tx_cmd_basic, iwl3945_hw_build_tx_cmd_rate, and
iwl3945_build_tx_cmd_hwcrypto are all passed out_cmd and modify memory
located there.  These modifications are not reflected in the memory
located at txcmd_phys.

pci_map_single should only be called once the tx command structures
are completely written.

Additionally, pci_unmap_single should be called once the memory is no
longer needed to free the swiotlb entry for that command.  I am not
sure if this is currently handled for all cases.

Previous use of pci_alloc_coherent meant that memory would allocated
at an physical address below 4GB and kept in-sync both the device and
cpu.

Refer to Documentation/x86/x86_64/boot-options.txt and lib/swiotlb.c
for information on IOMMU and swiotlb

Jason

On Fri, Mar 20, 2009 at 4:39 PM, Abhijeet Kolekar
<abhijeet.kolekar@intel.com> wrote:
> Can you try this patch?
>
> Thanks
> Abhijeet
>
> On Thu, 2009-03-19 at 18:22 -0700, Jason Andryuk wrote:
>
>> There is a bug related to the use of DMA. =A0Using wireless-testing
>> 2.6.29-rc7 from ~3/15, and booting with "iommu=3Doff mem=3D2G" gives=
 me a
>> working iwl3945. =A0I also confirmed
>> 78bb4a96d0d4ab2860df5f0fdfde58cd7a3ad642 "iwl3945: use iwl3945_tx_cm=
d
>> instead of iwl_tx_cmd" plus previously posted "rb_stts and BUG to
>> WARN" patch as working when iommu is disabled.
>>
>> So swiotlb exposes iwl3945 dma breakage.
>>
>> From 78bb4a96d0d4ab2860df5f0fdfde58cd7a3ad642 "iwl3945: use
>> iwl3945_tx_cmd instead of iwl_tx_cmd" the most obvious problem is th=
e
>> change to pci_map_single from pci_alloc_consistent.
>>
>> As previously noted, problems brought along by that include the
>> modification of data to be DMAed after the _map_single call. =A0The =
lack
>> of associated un-mapping of memory may also be a problem.
>>
>> For testing, swiotlb use can be forced with "swiotlb=3Dforce" which
>> should reproduce the error.
>>
>> Jason
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wire=
less" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
