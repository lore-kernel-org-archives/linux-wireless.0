Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793418150;
	b=W6meObZ2JnHpbPeSHdbV5sjA7gUo9ge9jGPw0E/BjOOpCkmWVy5wYC5fzfJs4bVlC67p
	 1xAGP6dchIIQ5S8cX6VdpceC6wA+1LgzMxEfHthk4VDF/F3GxINJvkrDDFenTYZluFfpE
	 3IbRNXyV040AfVXmTSMja+V9pzzlghd+Tbt9J+KyPdDSKmKcfNiijup3/w62VNJryqVc8
	 +BSC4P8fyf8l19UBpsYuRS/bBr8NsMrRVRdPuK/kz5KibciN6IVgGaM6zUGjhtRDI80Hm
	 3aGGTjXdFqEfwrY1i1uToqLOSMKRyHDSGcrGDCRhqgdUdoibOxYFPtAsj/FA2m09F+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793418150;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Ot9ndK0ejKVXddWQEZ2xSPgFjOHt7YNnn7ck0sFqpGc=;
	b=ELNotG5b40ExqMIzmI18qDmyDVh00uJbwnCEUA5y5/ZMrnq3DCnzwKgb3visN+UkQ+o3
	 6eGNqCjMqo+8CL97XCGJy6BGAa+gH6JoCFZxtbJRXhxUyZf/+hFi0T0plQ3Bg3mmoocM7
	 4VmG/9XMKbWzdgREqwp2m0eK2qnPMFWajFaSVm7VS7PwUW0t8QKX4f0Jjh0juWShGnw4f
	 jBXHaWavaL1FfwfOPmXaq1gqLCOL0Iwj0OjuZBIHM6Ci3+KW39mMauypqVWrKB1XnzxDW
	 /le9/0ucsE0wzRmz4xAFCiEQkKrfhVfFdmApD5t0d5fk+xarsaPsBJzhaMLZ1ZpaQ2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iZj+Gxle;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F2B606A320;
	Sat, 31 Oct 2026 03:42:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36F2B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iZj+Gxle
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793418149; x=1824954149;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aGlr3qfr6AZBSiPKZMalF/26FFfN/4Og7QmWbsUKYaY=;
  b=iZj+GxleJQ/t80kZlt4Py+Sv9WKRZgrBIQZTZvQp368KbHLta9HgaBUY
   j2S1aCYYYlOmjY4luHoZZR6M86rcbJw1g+a5ySg6MdhaI2gB1FcTZmYV+
   iJdGLitSqKYm5c7BGKHvvuez7VOrtLKsmHW9Q8KAVaJklfiALgJdYZxB2
   YfmFc159/+mlUb18WU/hnTzuPJATQy7+K0/atGWwa+b6YsHuDKF+ORzkb
   LDUYnCN7+VmHhcUPs/A0TCe/uF89IZD2IRCGnkWGhw0HyPdjT30rD9fmQ
   c0ldRKRzlS4Pma2eccemsWgylHSViKViE8Gqi1KWmUdwsBSFROCHTZk4e
   w==;
X-CSE-ConnectionGUID: suEEYPoxRdGL3hHxVMGbQQ==
X-CSE-MsgGUID: oVcnGHnVQ6egT/K/QyFAag==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2188811"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2188811"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 20:42:29 -0700
X-CSE-ConnectionGUID: 1aS14UP0T/aO54Frxa2Eug==
X-CSE-MsgGUID: GHsu/r0hSAa7KZcwxpde2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5568194"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 30 Oct 2026 20:42:25 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMzz3-00000000cVO-2SRY;
	Sat, 31 Oct 2026 03:42:21 +0000
Date: Sat, 31 Oct 2026 11:41:43 +0800
From: kernel test robot <lkp@intel.com>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jgg@ziepe.ca,
	alex@shazbot.org, pbonzini@redhat.com, seanjc@google.com,
	bhelgaas@google.com, jjohnson@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, johannes@sipsolutions.net,
	mani@kernel.org, lpieralisi@kernel.org, kwilczynski@kernel.org,
	robh@kernel.org, vkuznets@redhat.com, kevin.tian@intel.com,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: Re: [PATCH v3 2/8] KVM: add PCI MSI hypercall for VFIO passthrough
Message-ID: <202610311038.ydvb3F1w-lkp@intel.com>
References: <20261029163713.1366077-3-jtornosm@redhat.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029163713.1366077-3-jtornosm@redhat.com>

Hi Jose,

kernel test robot noticed the following build errors:

[auto build test ERROR on pci/next]
[also build test ERROR on pci/for-linus linus/master next-20261030]
[cannot apply to kvm/queue kvm/next ath/ath-next kvm/linux-next v7.3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jose-Ignacio-Tornos-Martinez/vfio-add-helper-to-find-PCI-device-by-vendor-device-ID/20261029-173706
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git next
patch link:    https://lore.kernel.org/r/20261029163713.1366077-3-jtornosm%40redhat.com
patch subject: [PATCH v3 2/8] KVM: add PCI MSI hypercall for VFIO passthrough
config: s390-randconfig-1000-20261031 (https://download.01.org/0day-ci/archive/20261031/202610311038.ydvb3F1w-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261031/202610311038.ydvb3F1w-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610311038.ydvb3F1w-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/s390/kvm/arm64/../../../../virt/kvm/vfio.c: In function 'kvm_vfio_pci_msi_alloc':
>> arch/s390/kvm/arm64/../../../../virt/kvm/vfio.c:438:48: error: 'struct irq_data' has no member named 'parent_data'
     438 |                 for (pos = irqd; pos; pos = pos->parent_data) {
         |                                                ^~
--
   arch/s390/kvm/s390/../../../../virt/kvm/vfio.c: In function 'kvm_vfio_pci_msi_alloc':
>> arch/s390/kvm/s390/../../../../virt/kvm/vfio.c:438:48: error: 'struct irq_data' has no member named 'parent_data'
     438 |                 for (pos = irqd; pos; pos = pos->parent_data) {
         |                                                ^~


vim +438 arch/s390/kvm/arm64/../../../../virt/kvm/vfio.c

   361	
   362	/**
   363	 * kvm_vfio_pci_msi_alloc - Get physical MSI address/data for a VFIO device
   364	 * @kvm: the VM instance
   365	 * @devid: PCI vendor:device packed as (vendor << 16 | device)
   366	 * @vector: MSI vector index
   367	 * @msg: output MSI message (address + data)
   368	 *
   369	 * Walks VFIO files attached to this VM, uses vfio_file_find_pci_device()
   370	 * to find the PCI device matching the given vendor:device ID, and returns
   371	 * the host's physical MSI address/data for the requested vector.
   372	 *
   373	 * Returns 0 on success, negative errno on failure.
   374	 */
   375	int kvm_vfio_pci_msi_alloc(struct kvm *kvm, u32 devid,
   376				     unsigned int vector, struct msi_msg *msg)
   377	{
   378		struct kvm_vfio_file *kvf;
   379		struct kvm_vfio *kv = NULL;
   380		struct vfio_device *vdev;
   381		struct kvm_device *dev;
   382		struct msi_desc *desc;
   383		struct irq_data *irqd;
   384		struct pci_dev *pdev;
   385		u16 vendor = devid >> 16;
   386		u16 device = devid & 0xffff;
   387		int irq;
   388	
   389		scoped_guard(mutex, &kvm->lock) {
   390			list_for_each_entry(dev, &kvm->devices, vm_node) {
   391				if (dev->ops == &kvm_vfio_ops) {
   392					kv = dev->private;
   393					break;
   394				}
   395			}
   396		}
   397	
   398		if (!kv)
   399			return -ENODEV;
   400	
   401		guard(mutex)(&kv->lock);
   402	
   403		vdev = NULL;
   404		list_for_each_entry(kvf, &kv->file_list, node) {
   405			vdev = vfio_file_find_pci_device(kvf->file, vendor, device);
   406			if (vdev)
   407				break;
   408		}
   409	
   410		if (!vdev)
   411			return -ENODEV;
   412	
   413		pdev = to_pci_dev(vdev->dev);
   414	
   415		if (!pdev->msi_enabled && !pdev->msix_enabled) {
   416			memset(msg, 0, sizeof(*msg));
   417			return 0;
   418		}
   419	
   420		irq = pci_irq_vector(pdev, vector);
   421		if (irq <= 0) {
   422			memset(msg, 0, sizeof(*msg));
   423			return 0;
   424		}
   425	
   426		irqd = irq_get_irq_data(irq);
   427		if (!irqd) {
   428			memset(msg, 0, sizeof(*msg));
   429			return 0;
   430		}
   431	
   432		desc = irq_get_msi_desc(irq);
   433		if (desc) {
   434			*msg = desc->msg;
   435		} else {
   436			struct irq_data *pos;
   437	
 > 438			for (pos = irqd; pos; pos = pos->parent_data) {
   439				if (pos->chip && pos->chip->irq_compose_msi_msg) {
   440					pos->chip->irq_compose_msi_msg(pos, msg);
   441					break;
   442				}
   443			}
   444			if (!pos) {
   445				memset(msg, 0, sizeof(*msg));
   446				return 0;
   447			}
   448		}
   449	
   450		return 0;
   451	}
   452	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
