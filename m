Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61041 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbZC0QWr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 12:22:47 -0400
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: reinette chatre <reinette.chatre@intel.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1237768621.8764.13.camel@rainbow>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236649234.6685.9.camel@rainbow> <1236661466.15923.53.camel@rc-desk>
	 <1236742805.6267.9.camel@rainbow>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
	 <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
	 <1237254243.13077.33.camel@rainbow> <1237427568.6943.13.camel@rainbow>
	 <c4d76b3b0903191822l5494f268h395acc4a14608239@mail.gmail.com>
	 <1237581564.21165.5.camel@abhi-desktop>
	 <c4d76b3b0903221029r21282bbbs13a8af06f9d8ce2@mail.gmail.com>
	 <1237768621.8764.13.camel@rainbow>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 09:28:16 -0700
Message-Id: <1238171296.25568.21.camel@rc-desk> (sfid-20090327_172250_452468_D97571F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jason,

I thought you may want to hear an update since it is almost a week since
your last message ...

Thanks to your digging I was able to reproduce the SYSASSERT and find
the issues you discovered through your analysis. I am working on a
different solution that has tx buffers working again. I am still
scratching my head with a rx buffer issue and will send out a patch as
soon as that is resolved.

More below ...

On Sun, 2009-03-22 at 17:37 -0700, Jason Andryuk wrote:
> On Sun, 2009-03-22 at 13:29 -0400, Jason Andryuk wrote:
> > The patch did not work.
> > 
> > However, I do not think it's an alignment issue.
> > 
> > pci_map_single on x86_64 with >3G memory and no IOMMU uses the swiotlb
> > by default.  swiotlb provides "bounce buffers" for physical addresses
> > over 4GB.  So for memory where the kmalloc value is at a physical
> > address over 2**32, pci_map_single will copy to a swiotlb slot.  That
> > means the dma_handle return value of pci_map_single is not necessarily
> > the physical address of the virtual address.
> > 
> > In iwl3945_tx_skb (iwl3945-base.c line 1099) use the pci_map_single
> > which copies the memory of out_cmd at that time.  However,
> > iwl3945_build_tx_cmd_basic, iwl3945_hw_build_tx_cmd_rate, and
> > iwl3945_build_tx_cmd_hwcrypto are all passed out_cmd and modify memory
> > located there.  These modifications are not reflected in the memory
> > located at txcmd_phys.
> > 
> > pci_map_single should only be called once the tx command structures
> > are completely written.
> > 
> > Additionally, pci_unmap_single should be called once the memory is no
> > longer needed to free the swiotlb entry for that command.  I am not
> > sure if this is currently handled for all cases.
> > 
> > Previous use of pci_alloc_coherent meant that memory would allocated
> > at an physical address below 4GB and kept in-sync both the device and
> > cpu.
> > 
> > Refer to Documentation/x86/x86_64/boot-options.txt and lib/swiotlb.c
> > for information on IOMMU and swiotlb
> > 
> > Jason
> 
> I hacked up an inelegant patch that does get the driver working.
> 
> We call pci_dma_sync_single_for_device to ensure the correct contents
> are visible to the device.  That is, we copy out_cmd to phys_addr, so
> the desired contents are viewable for the device.
> 

I don't think this is necessary ... we should just take care to have
data complete before handing it to device. In the iwlagn driver we have
to do this because the command actually contains the dma address ... so
we first need to map the data, get the address, take buffer back, and
then be able to update command with that address ... 

> I tried moving the pci_map_single call to right before the call to
> iwl_txq_update_write_ptr, but I never got that working successfully.
> Presumably that is how the problem should be fixed.  

I did something similar and it seems to work ...

> Another failed
> attempt was to map from "out_cmd + offsetof(struck iwl_cmd, hdr)"
> instead of out_cmd.  The phys_addr + offsetof(struck iwl_cmd, hdr) is
> what is passed to txq_attach_buf_to_tfd, so I thought that should work.

I think this is necessary, and I also do something similar in my patch.
The problem here is that the meta data in the command contains the bus
address. If we map that to the device then it introduces a problem ...
at the time we need to unmap the data we need to access the address in
the mapped data. We should thus only map the data starting from the
header.

> Unfortunately it did not.  The added benefit would have been that it
> moved "len" and "mapping" of struct iwl_cmd_meta out of the mapped area.
> Then losing them since they were written after the mapping would not
> have been a problem. 

yup ... but this does cause a problem at unmap time.

> 
> If struct iwl_cmd_meta's len and mapping members are read by one of the
> "reclaim" functions, then they should probably be sync'ed with
> pci_dma_sync_single_for_cpu beforehand.
> 

... but which address to give this function? Rather just not map it in
the first place. This should be possible.

I hope to have a patch for you soon.

Reinette


