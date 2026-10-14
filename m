Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B23D541445
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 15:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791990074; cv=none; b=h1k0IexZUYS7W28waz3M10hfP9iICR55K9faG80HIyE+ay5d3JAsuz1Rr4U5z6PJY4htlvpcid0Tpvg3wyQlm5RgVCEcnOdaLvDG8TNnHlzzN65fHii10fgvGUlieP1mE9Vu+D/tzbZWWT0nskZmBcay/e47yxhthHHQzv84vZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791990074; c=relaxed/simple;
	bh=8g5YPROFbXovZy51qk1EUD+4yKUqmBWrOG1unTPzGBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DMyoKIxSb7Dl7GonbEKC7ZAUo2vE7zu2Gzlt7kfo8ZCQGZC5Ycnjq3WAiaIreP9yv4OaVjLa9q6pVrILtD5+uT69mQk47UZXNcTNRP/PhLQz/gZa+jurKraafMiXHDtFTW4AR3Ml4CF05Ll1/lDE32PUz5gawSk0vOIGYCIKLzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=c/L4eDC/; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="c/L4eDC/"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93e4c00d71aso323850085a.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 08:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1791990068; x=1792594868; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6U1pWqVZ/sYyDpZ17hoiGN1gvUUpCMFUWiI8c+hfh3o=;
        b=c/L4eDC/ilK+pwNu/b3oZKcwjKQfKjbG8wHCV7h26jdI70N/i/0q3qeHxxopZkP2Jz
         ULn5RpxfWjveWcGH4mkjKwGpkwJdL9d8TDS2tlpKfJNMpz6w80Orq2KoB+9tkQGn/ol0
         rEE7DalP5B+bfnVj5vp2L322axO3+0tkrRwbL2Fn7TU+vVjbVSRRQPfdF+nG9MyLCGvE
         klKul9eMoYzwGrQvbRxNp+Rx9yHUvwFEpH/EujqC7wEU7hsPqvPSm6oqsulQC1l+uX8O
         zHH+SwbYarcwF7pwpY1M185BTJNegKJRQuVhLvl4MZp7ZcvwpED18wgYRQn3pyCrFN70
         eO3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791990068; x=1792594868;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6U1pWqVZ/sYyDpZ17hoiGN1gvUUpCMFUWiI8c+hfh3o=;
        b=c/iieb3AhN8OF3bT/NKMuWQ1IEawTPCLDAvy9vP/US8xzafgmHbWGRI5peEy0/D3Zy
         0WG7YPrRDiLP2xsOnM6vbaBZ99G/BfvAVs7KbPNLLRM2tEowKuK04fDyqP0nvFZpp7yE
         zIS6JloPbgpnR6EJaFphiblcdhbd9zo5m0GGtTSI5DmdabJ39/mVJ4Vjjt98jfZ5mUSj
         siuI0x7UKN65hqIodaLayJ4oxB4bSZoe+rUzbbNpAGb1R0zc0xHhAgFFqvQccUJBQ0Ix
         FMGL7XVyBtGRUNfCVT7brp02XF2OPxL183qnwk4hsEXiTNjrWvIv3ZuiWdBmIA1AmRwv
         aaBQ==
X-Forwarded-Encrypted: i=1; AKwUvBx8RcwB7OiFMvJBryDrZF65fAxSvMrgvpi4G212jk9hC0YW7HlIOHgbeCBK91+Vy027Za+8yFdGQm8ILjI8sA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIJjcBFDviYzbAvcEuvPS8gAVqVTYLoBWOchpX0PX2vS4gP0gpT
	A59Je/jv2jVWxbGyS0t6xVsW9m3mqLm6NMV1aCN/P/DAc4yJQYzmo8nLA0sHunTBRC8=
X-Gm-Gg: AYBFou38mokSioosNnHEnkC/0SeYHvzt7rzQmSThIe0fjV14wcnOl+UvPNZPsRIWRgE
	9p7WqueNF5P6x8rsrhxvtb/l3pG5Iir2ViTbFXLwkRFjWT7DBy9WTdqqCeJ5REs348jha7m6c00
	FL/a4aVYDPgcMhzs+wFgi4CxdBnhjJ8QM4UheON6P54RE1cAK8h0M6n95I09EtUmmh7tEsBOWTR
	5qKWBUBZiYfy8I/wjk22c2ThYnHzw22eoFyQuXIQ4tV+juappbYf8ppQNdKdxE3JnLPvtK9aKGk
	xfoDvtIg5XM2zACPmL960vxbFF26VNUkJXNlFXoOZnz+SMk3DdyGaGalEjEfy8XbM+/8O160eX+
	owAIwQhFyEgDVoTqcLarSzXZOp7cXzfFvAaie/By+skQ5w088kLd1CpAYtiCm2WnQyzO/LK9+fr
	2Nv16UOKN9U4pAuQIqJCnIG37l0M/70664WZNd8SOARvEFnE3t1vI6k2vT4b6dfk39QNkKVu/lD
	lcA8OJu/Pjx7NPwqbFKJ0mimFlvakRw7JXj79/cM5ccgT2h3yME77x3
X-Received: by 2002:a05:620a:2b8b:b0:93e:c12c:f12a with SMTP id af79cd13be357-93ec12d08ebmr2509664885a.69.1791990049913;
        Wed, 14 Oct 2026 08:00:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b387e0sm54524706d6.12.2026.10.14.08.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:00:48 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xH0TH-0000000DJ4g-1rzV;
	Wed, 14 Oct 2026 12:00:47 -0300
Date: Wed, 14 Oct 2026 12:00:47 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: alex@shazbot.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, bhelgaas@google.com,
	jjohnson@kernel.org, johannes@sipsolutions.net,
	kevin.tian@intel.com, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	mani@kernel.org, skolothumtho@nvidia.com, yishaih@nvidia.com
Subject: Re: [PATCH 0/7] Enable Qualcomm WiFi PCIe passthrough to VMs
Message-ID: <20261014150047.GO14213@ziepe.ca>
References: <20261013140345.GK14213@ziepe.ca>
 <20261013154225.214531-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261013154225.214531-1-jtornosm@redhat.com>

On Tue, Oct 13, 2026 at 05:42:25PM +0200, Jose Ignacio Tornos Martinez wrote:
> Thank you for the direction on device MSI domains. The Hyper-V
> reference is difficult for me to follow for this case. Could
> you point me to some existing KVM/VFIO equivalent, or similar
> example for my use case? Any pointers to relevant code,
> documentation, or previous discussions on this topic would be
> very helpful to get started in the right direction.
> 
> Also, where would this need to be implemented? Kernel only
> because it is already supported in QEMU in a general way, or
> kernel and QEMU for some specifics?

I spent some time with AI to research this and drafted up some slop
for you that outlines a bunch of ideas and explains how some of the
bits work today. Not saying this is something to follow but it should
be a good starting point to come up with a good idea.

It is quite interesting that amd virtual interrupt remapping in the
iommu is very close to being able to solve the problem without any
guest changes. Maybe that is the right thread to pull on, if AMD can
be fixed fully then maybe there is an option to negotiate something
within the Intel spec, or build a similar idea with a 'virtio
interrupt remapping'

Nevertheless this looks reasonably tractable to me, assuming you have
some strong AI to help understand the whole picture and baroque
hardware details it is even almost approachable..

Jason

Host-managed MSI: the Hyper-V flow and a virtio proposal
========================================================

Goal: make device-specific MSI storage work for devices assigned to KVM guests.
Such storage is outside the PCI MSI/MSI-X capability. In Linux it is driven
through a per-device MSI domain, today via
platform_device_msi_init_and_alloc_irqs(). A PCI device needs a PCI counterpart
of that helper, which does not exist yet and must be written. The VMM cannot
trap this storage, so the guest must write host-valid MSI messages into it
directly, as Hyper-V guests do for MSI-X. The guest obtains those messages, and
routes the interrupts, through a paravirtual (virtio) interface.

Sections 1–4 describe how Hyper-V does this through the Linux IRQ domain
hierarchy. Section 5 maps that onto the KVM/VFIO host stack and assesses the
virtio proposal. Section 6 looks at an alternative with no paravirtual
interface: the host mirrors the guest's vIOMMU interrupt remapping (or vITS)
entries 1:1.

0. Why host-managed MSI exists at all
-------------------------------------

On a normal VFIO/KVM system the VMM traps guest writes to a passthrough device's
MSI/MSI-X registers. The guest writes a virtual message (a guest APIC address
and a guest vector). The VMM then programs the physical device and the physical
interrupt remapping (IR) table on the guest's behalf. The guest never sees a
host-valid message.

Hyper-V does not do that. In the vPCI and root-partition cases, the guest writes
the device's MSI capability and MSI-X table directly. Writes are not trapped and
emulated (see the comment above hv_pci_restore_msi_state()). The IOMMU and its
interrupt remapping table are owned by the hypervisor. The value the guest
writes must therefore already be a host-valid, remapped message, and only the
host can produce one. Hyper-V has the guest ask the host for each message.

Every design decision below follows from that premise:

  The guest chooses a destination (vCPU + vector, or a guest interrupt line).
  The host allocates a remapping entry for (source device → destination) and
  returns the MSI address/data that selects it. A Linux IRQ domain hands that
  pair to the MSI core, which writes it into the device using the normal PCI MSI
  writer.

For device-specific storage on KVM there is no trap to remove: the storage was
never trappable. Adopting this premise is the only way it can work in a guest.
Section 5.2 shows that the KVM half (stable host-composed messages, IRTE-only
retargeting, posting) already exists. The missing pieces are host IRQs without
host-side storage in VFIO, and an MSI parent in the guest that serves both the
PCI MSI-X domain and per-device MSI domains.

1. Separate the destination from the message
--------------------------------------------

  -------------------------------------------------------------------------------
  Identity                Meaning
  ----------------------- -------------------------------------------------------
  Linux IRQ number (virq) The guest kernel's software handle. Never visible to
                          the host.

  Destination             What the guest wants to receive: on x86 a vCPU set +
                          IDT vector; on Hyper-V ARM64 a GIC SPI number

  Source identity         The requester whose MSI writes the host will accept for
                          this mapping

  Host mapping            Host state binding (source, message) → destination; on
                          hardware, an IR table entry

  MSI address/data        What is written into the device; on IR hardware this
                          effectively selects the host mapping
  -------------------------------------------------------------------------------

In a hierarchical domain, one Linux IRQ has an irq_data at each level, linked by
parent_data, and each level keeps private state in chip_data. For host-managed
MSI:

-   the parent (receive) domain allocates the guest destination;
-   the host-managed MSI parent domain obtains the message from the host and
    owns the mapping's lifetime;
-   the device MSI domain writes the message into the device.

The guest must treat the returned pair as host-defined. It must not reconstruct
an APIC-format address from the CPU number, substitute its own vector into the
data, or assume an ITS doorbell. The only structure the guest may rely on is
what the protocol explicitly defines. Hyper-V's one example is conventional
multi-message MSI, where the data of vector n is base data + n (section 4).

2. The common Linux path: compose, then write
---------------------------------------------

Root-partition hierarchy on x86:

    PCI device MSI/MSI-X domain     writes device registers / MSI-X table
                 |
    Hyper-V MSI parent domain       obtains message from host, owns mapping
                 |
    x86 vector domain               allocates guest CPU + vector

Allocation walks down the hierarchy to reserve receive resources. Activation
walks parents first, then the MSI device domain's msi_domain_activate() does:

    msi_domain_activate(device_domain, irq_data)
      +-- irq_chip_compose_msi_msg(irq_data, msg)
      |     walks irq_data -> parent_data to the first level with
      |     .irq_compose_msi_msg  -> Hyper-V callback returns host pair
      +-- irq_chip_write_msi_msg(irq_data, msg)
            -> pci_msi_domain_write_msg() -> __pci_write_msi_msg()
                 MSI:   config-space address/data registers
                 MSI-X: the entry in the device's MSI-X table

Notes:

-   The Hyper-V compose callback never touches device registers; the write
    belongs to the PCI MSI layer.
-   __pci_write_msi_msg() caches the message in msi_desc->msg. If the device is
    not in D0 or is disconnected, it skips the hardware write.
-   irq_compose_msi_msg returns void. msi_domain_activate() and
    msi_domain_set_affinity() start from a zeroed msg. If the provider fails, it
    simply leaves (or sets) 0/0, and a zero message is written to the device.
    Nothing reports the failure to the caller.
-   msi_domain_set_affinity() asks the parent to change destination. Unless the
    parent returns IRQ_SET_MASK_OK_DONE, it composes and writes again. Every
    affinity change therefore re-runs the Hyper-V compose callback.
-   Both Hyper-V x86 chips set IRQCHIP_MOVE_DEFERRED. On x86 the affinity change
    is applied from the interrupt's own handler context (irq_move_masked_irq()).
    Any host interaction done in compose therefore runs in hard-IRQ context with
    the descriptor lock held.

3. Hyper-V root partition: direct hypercalls
--------------------------------------------

Code: arch/x86/hyperv/irqdomain.c.

Here Linux is the root partition. It sees the physical PCI topology, but the
hypervisor owns the IOMMU.

Installing the domain
~~~~~~~~~~~~~~~~~~~~~

hv_init.c sets x86_init.irqs.create_pci_msi_domain = hv_create_pci_msi_domain
when running as root. That creates a single system-wide MSI parent domain over
x86_vector_domain. hv_msi_domain_alloc() only allocates parent vectors and
installs hv_pci_msi_controller. It does no host work; a TODO says the mapping
should move there.

Supported flags are generic + MSI-X. Conventional multi-message MSI is not
supported, and each mapping has vector_count = 1, edge-triggered.

Mapping: all work happens in compose
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    hv_irq_compose_msi_msg(irqd, msg)
      if irqd->chip_data:                  # already mapped (affinity change)
          HVCALL_UNMAP_DEVICE_INTERRUPT(old entry); kfree
      entry = kzalloc(GFP_ATOMIC)
      hv_map_msi_interrupt()
         source = physical segment/BDF, after walking DMA aliases;
                  PCI-X bridges add a bus-range "shadow"
         cpu    = first CPU of the effective affinity (single CPU)
         vector = parent vector (irqd_cfg()->vector)
         HVCALL_MAP_DEVICE_INTERRUPT  -> hv_interrupt_entry
      irqd->chip_data = entry
      msg = { address_hi = 0,
              address_lo = entry.msi_entry.address,
              data       = entry.msi_entry.data }

The hypercall returns the 32-bit address and 32-bit data. Linux copies them
verbatim. address_hi = 0 is a property of this interface, not a guest encoding
choice.

Affinity change
~~~~~~~~~~~~~~~

The hypervisor does not let the root partition change the vector or move the
interrupt to VPs outside the originally mapped set. For that reason, root does
not use RETARGET. Every affinity change is unmap, then map, followed by a device
rewrite with the possibly new pair.

This has consequences:

-   Between the unmap and the device rewrite, the device holds a message that
    refers to a released mapping.
-   If the map fails, compose returns with chip_data == NULL and a zero msg, and
    the device is programmed with 0/0. The IRQ is now dead and nothing reports
    it.
-   All of this runs in the deferred-move path, in hard-IRQ context (section 2).

Teardown
~~~~~~~~

hv_msi_domain_free() → hv_teardown_msi_irq() issues
HVCALL_UNMAP_DEVICE_INTERRUPT with the stored entry. The mapping is a host
resource; forgetting the pair in the guest leaks it.

4. Hyper-V guest vPCI: CREATE over VMBus, RETARGET by hypercall
---------------------------------------------------------------

Code: drivers/pci/controller/pci-hyperv.c.

Here Linux is an ordinary guest with passthrough devices exposed on a synthetic
PCI bus. Each vPCI bus is a VMBus device with its own channel.

Two control paths
~~~~~~~~~~~~~~~~~

This split is the most important thing to understand before designing a virtio
version:

CREATE (PCI_CREATE_INTERRUPT_MESSAGE{,2,3})

-   Transport: VMBus request/response
-   Called from: hv_compose_msi_msg()
-   Context: IRQ descriptor lock held; polls the channel

DELETE (PCI_DELETE_INTERRUPT_MESSAGE)

-   Transport: VMBus, fire-and-forget
-   Called from: compose (replace) and hv_msi_free()

RETARGET (x86 only)

-   Transport: HVCALL_RETARGET_INTERRUPT, synchronous hypercall
-   Called from: hv_irq_unmask()
-   Context: atomic

Slow, rare operations use the message transport. The operation that must
complete inside an IRQ chip callback uses a synchronous trap. VMBus is not used
for that.

Domain setup
~~~~~~~~~~~~

hv_pcie_init_irq_domain() creates one MSI parent domain per vPCI bus, and
dev_set_msi_domain() binds it to that bus's host bridge. Device-to-domain
selection is therefore by topology: every device on that synthetic bus uses that
domain. Source identity is likewise implicit. The host already knows which
physical function sits behind each slot (wslot) on that channel.

Parent receive domain:

-   x86: x86_vector_domain. Destination = vCPU(s) + IDT vector.
-   ARM64: a private hv_vpci_arm64 domain over the GIC. It hands out SPIs
    64–1019 from a bitmap in power-of-two aligned blocks. Destination = SPI
    number, sent to the host as the "vector". CPU routing of that SPI is done by
    the guest's virtual GIC distributor, which Hyper-V already emulates. So
    hv_arch_irq_unmask() is empty on ARM64, and no retarget is ever needed.

CREATE
~~~~~~

hv_compose_msi_msg():

1.  For multi-MSI with existing chip_data, return the cached pair (no host
    call).
2.  If a previous int_desc exists (single MSI / MSI-X), send DELETE for it.
3.  Build a v1/v2/v3 CREATE request: slot, vector, vector count, and one "dummy"
    vCPU (first online CPU of the affinity; round-robin for multi-MSI).
4.  Send it with vmbus_sendpacket_getid(). Disable the channel tasklet. Spin
    calling hv_pci_onchannelcallback() with udelay(100) until the completion
    fires, the device disappears (vendor ID 0xFFFF), or the channel is torn
    down.
5.  Store the returned tran_int_desc in chip_data. Return
    address_hi:lo = int_desc.address (64-bit) and data = int_desc.data.

On any failure it returns a zero message.

The vCPU in CREATE is not cosmetic. Hyper-V picks the physical CPU that services
the interrupt based on it, and (as of the comment in the driver) RETARGET does
not reselect the pCPU. The vector in CREATE is the real vector for single
MSI/MSI-X, but a dummy 32 for multi-MSI.

RETARGET at unmask (x86)
~~~~~~~~~~~~~~~~~~~~~~~~

hv_irq_unmask() → hv_arch_irq_unmask() → hv_irq_retarget_interrupt(). This
issues HVCALL_RETARGET_INTERRUPT with:

-   device id: built from the vPCI bus instance GUID + PCI function;
-   the existing message (address_lo, data) used as the key that identifies the
    mapping;
-   the new vector and the full effective-affinity vCPU set.

The message is unchanged; the host updates its IR entry behind it. Note that
Hyper-V uses the address/data pair itself as the mapping handle. There is no
separate handle.

Nested root (Linux is root under a nested hypervisor) calls
hv_map_msi_interrupt(data, NULL) instead and discards the returned entry.

Affinity in practice (x86)
~~~~~~~~~~~~~~~~~~~~~~~~~~

An affinity change goes through msi_domain_set_affinity() → recompose. For
single MSI/MSI-X that means DELETE + CREATE over VMBus, polled in hard-IRQ
context, then a device rewrite, then RETARGET on the next unmask. Multi-MSI
skips the recompose (cached) and relies on RETARGET alone. All vectors of a
multi-MSI device therefore share whatever pCPU the host picked at CREATE.

Multi-message MSI
~~~~~~~~~~~~~~~~~

Conventional MSI has one address and a base data value; the device ORs in the
vector index. The host allocates an aligned block for nvec_used vectors during
the first IRQ's CREATE. Later IRQs derive data = base + (irq - first_irq)
without asking the host. This works only because the host guarantees block
semantics. Independent per-vector pairs cannot be advertised as multi-MSI.

Free and resume
~~~~~~~~~~~~~~~

hv_msi_free() sends DELETE for the stored descriptor. On resume, a cached MSI-X
table replay is useless because the host's IR entries are gone.
hv_pci_restore_msi_state() therefore calls hv_compose_msi_msg() for every
descriptor to re-CREATE.

What the Hyper-V code itself admits is wrong
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-   Both providers have a TODO to move host allocation out of compose and into
    .alloc.
-   Failure in compose silently programs 0/0.
-   vPCI CREATE runs a polled, unbounded message round-trip under IRQ locks,
    including from the deferred affinity-move path.

5. Applying this to KVM/VFIO: device MSI storage in a guest
-----------------------------------------------------------

5.1 The functional problem
~~~~~~~~~~~~~~~~~~~~~~~~~~

Many devices keep MSI address/data in device-specific storage: a context table
in device memory, or a field in a queue context that lives in DMA'd host memory.
The PCI MSI/MSI-X capability is not involved. (The PCI/IMS proposal used to
cover this; the current tree does it with per-device MSI domains, see below.) A
guest driver for an assigned device has to write a message into that storage,
and:

-   the VMM cannot trap it. The format is device-specific, and the storage may
    be in guest RAM that the device reads by DMA;
-   a guest-format message (guest APIC ID + guest vector) is wrong. On a host
    with interrupt remapping, the device must emit a remappable-format message
    that selects a host IRTE belonging to this device.

So device-specific MSI storage cannot work in a KVM guest today. The only fix is
the Hyper-V model: the guest asks the host for a host-valid message and writes
it itself. This is "Model B": a host-provided message that the guest programs
into the storage.

The generic Linux side already exists.
platform_device_msi_init_and_alloc_irqs(dev, nvec, write_msi_msg) creates a
DOMAIN_BUS_DEVICE_MSI domain on dev, parented on dev->msi.domain, and allocates
nvec interrupts. The parent composes each message and the core hands it to the
driver's write_msi_msg(desc, msg), which stores it wherever the device wants it.
ARM ITS/MBI and the irq-msi-lib parents (e.g. RISC-V IMSIC) accept this bus
token. The x86 parents (x86_vector_msi_parent_ops, DMAR, AMDVI) accept only
DOMAIN_BUS_PCI_DEVICE_MSI{,X}, which is one of the gaps this work fills.

Two properties of the helper shape the design:

-   The platform helper is the wrong API for a PCI device. It is built for
    devices whose only MSI domain is the device MSI domain. It always uses
    MSI_DEFAULT_DOMAIN, and MSI_MAX_DEVICE_IRQDOMAINS is 1. A PCI function's own
    MSI/MSI-X domain already occupies that slot. A PCI device therefore needs a
    new pci_device_msi_init_and_alloc_irqs(pdev, nvec, write_msi_msg) (and a
    matching pci_device_msi_free_irqs_all()). Neither exists in the tree yet;
    both must be written as part of this work. The new helper uses the same
    DOMAIN_BUS_DEVICE_MSI template and driver write callback, but places the
    domain in a second per-device domain slot that the core must add, so it
    coexists with MSI-X on the same struct device. Both domains are then
    parented on the function's dev->msi.domain, and the source identity is
    simply the function itself.
-   The device MSI chip has no mask of its own (irq_chip_mask_parent), no
    affinity callback, and no feature flags. Masking and retargeting are the
    parent's job, which suits a host-managed parent.

5.2 What the KVM/VFIO host already provides
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    VFIO_DEVICE_SET_IRQS(MSI-X, index i, eventfd)
       host: pci_msix_alloc_irq_at(i) / request_irq(vfio_msihandler)
       host IR domain composes a remappable msg (IRTE index [+ subhandle])
       host writes that msg into the physical MSI-X entry i
       irq_bypass_register_producer(eventfd, host_irq)
    KVM_SET_GSI_ROUTING(gsi -> guest-format msg) + KVM_IRQFD(eventfd, gsi)
       kvm_pi_update_irte(): post the IRTE to the vCPU PI descriptor + guest vector,
       or leave it remapped to a host vector and let KVM inject

Properties to reuse:

-   The host message is stable for the life of the host IRQ.
    intel_ir_compose_msi_msg() returns the cached ir_data->msi_entry. Host
    affinity changes (intel_ir_set_affinity(), amd_ir_set_affinity()) rewrite
    only the IRTE and return IRQ_SET_MASK_OK_DONE. Posting changes
    (irq_set_vcpu_affinity()) also rewrite only the IRTE.
-   Guest retargeting is host-only. It is a KVM routing update followed by an
    IRTE rewrite. The device is never touched.

The KVM half (irqfd, GSI routing, posting) works on any host IRQ that has an IR
parent. It does not care whether the host IRQ came from MSI-X or from somewhere
else. The missing piece is entirely on the VFIO/host-IRQ side. VFIO can only
create host IRQs for MSI-X table indices. A device MSI interrupt needs a host
IRQ that has an IRTE but no host-side storage.

5.3 Security: what makes guest-written messages safe
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The guest controls the device's DMA. It can already make the device write any
value to 0xFEEx_xxxx with its requester ID. VFIO's isolation therefore already
rests on interrupt remapping:

-   Intel: source-ID-checked IRTEs (set_msi_sid()), and compatibility-format
    MSIs blocked;
-   AMD: per-device remap tables.

Letting the guest write host-valid messages into device storage adds no new
requirement, provided the whole requester ID belongs to that one guest. The
guest can only reach IRTEs whose source-ID check passes for its own RID, and all
of those are its own.

This breaks for shared-RID assignment (SIOV/ADIs). Several guests' ADIs emit
MSIs with the same RID, and IR checks only the RID, not the PASID. A guest could
put another guest's IRTE handle into its own storage entry and inject interrupts
into that guest. That is why SIOV designs kept this storage host-programmed.
Guest-written messages are safe only for whole-function assignment (a PF or a VF
with its own RID). The proposal must state this scope, and the host must refuse
CREATE for devices whose RID is shared.

5.4 Protocol
~~~~~~~~~~~~

  ----------------------------------------------------------------------------------
  Op           Request                     Response                    Transport
  ------------ --------------------------- --------------------------- -------------
  CREATE       device, domain (MSI-X /     per vector: handle, address virtqueue;
               device MSI), index, count,  (64-bit), data (32-bit);    can sleep
               storage address/data widths count granted               

  RETARGET     handle, guest-format MSI    status; host message        synchronous
               message composed by the     unchanged                   trapped
               guest's parent vector                                   register
               domain                                                  

  DESTROY      handle                      status; no further delivery virtqueue;
                                                                       can sleep

  (host →      config-change notification  all handles stale; guest    config
  guest)                                   must re-CREATE and rewrite  interrupt
  INVALIDATE                               storage                     
  ----------------------------------------------------------------------------------

Design points:

-   The message is stable and destination-independent. The host IR already
    guarantees this (5.2). CREATE therefore carries no destination and can run
    from the guest's .alloc, which can sleep and fail cleanly. Compose copies
    the cached pair. Affinity changes never touch device storage. That matters
    for device MSI in particular: writing a queue context from hard-IRQ context
    is often impossible, and the device MSI chip has no affinity callback of its
    own anyway.
-   The RETARGET destination is the guest-format message. The guest's virtio-msi
    level composes it by calling the parent x86_vector_domain (APIC ID, vector,
    extended destination ID). The VMM puts it unchanged into KVM routing, so no
    new destination encoding is needed.
-   RETARGET is synchronous. It runs from irq_set_affinity (hard-IRQ context
    with IRQCHIP_MOVE_DEFERRED) and from activation. Use a write to a trapped
    virtio config/MMIO register and read back status. The vCPU waits in the exit
    until the VMM has updated routing. A virtqueue cannot provide this. Hyper-V
    uses the same split: VMBus for CREATE, a hypercall for RETARGET.
-   The device MSI index is only a name. The host does not interpret the guest's
    msi_index or storage slot. It only scopes handles, so that DESTROY and
    INVALIDATE are well defined. (MSI-X differs, see 5.6(c).)
-   Width negotiation. The x86 remappable message has a 32-bit address_lo
    carrying the IRTE index, address_hi = 0, and data carrying the subhandle.
    Device storage may be narrower. The guest declares the widths it has, and
    the host fails CREATE if its message cannot fit.

5.5 Host-side work (VFIO + IR)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.  Storage-less host IRQs. A VFIO device needs a way to allocate host IRQs with
    an IR parent but no host writer. The same device MSI mechanism fits: VFIO
    calls the new (not yet written) pci_device_msi_init_and_alloc_irqs() on the
    assigned function, under its existing IR parent, with a write callback that
    only records the composed message. The host cannot mask storage it doesn't
    own; masking stays at the IR/eventfd level and the guest owns device-side
    masking. This needs:
    -   writing pci_device_msi_init_and_alloc_irqs() and adding the second
        per-device domain slot (5.1), shared with the guest side,
    -   the x86 vector, DMAR and AMDVI parents accepting DOMAIN_BUS_DEVICE_MSI
        (x86_init_dev_msi_info(), x86_msi_prepare()), with an allocation type
        that programs the PCI function's source ID (set_msi_sid()) as for MSI-X,
    -   the host refusing it without isolated MSI.
2.  New VFIO uAPI. "Allocate N storage-less interrupts on this device, attach
    eventfds, return each host message." This could be a new IRQ index or a new
    ioctl. It needs a quota, and the irq bypass producer is registered exactly
    as for MSI-X, so KVM posting works unchanged.
3.  Scalability. Device-specific storage exists largely to go beyond MSI-X's
    2048 vectors. Each guest interrupt here costs:
    -   a host IRQ and a host vector, because the IR domain allocates a
        vector-domain parent even when posted. That is about 200 per host CPU.
    -   a KVM GSI route. KVM_MAX_IRQ_ROUTES is 4096, and KVM_SET_GSI_ROUTING
        replaces the whole table, with expedited SRCU, on every RETARGET.
    -   an IRTE. Intel has 64K per IOMMU, shared host-wide; AMD has a
        512/2048-entry per-device table.

    Thousands of device MSI interrupts per guest need posted-only IRTEs without
    a host vector, and an incremental single-route KVM update (or a KVM-side
    RETARGET). Neither exists today. Without them the design tops out at roughly
    MSI-X scale, which defeats much of the point.

5.6 Guest-side work
~~~~~~~~~~~~~~~~~~~

(a) Device storage through a device MSI domain. Once the new helper exists
(5.1), the device driver calls
pci_device_msi_init_and_alloc_irqs(pdev, nvec, write_msi_msg) alongside its
normal pci_alloc_irq_vectors() MSI-X allocation. The callback receives the
msi_desc and uses desc->msi_index to find the queue/context to write. The domain
is a fixed-size block allocated up front and is torn down with
pci_device_msi_free_irqs_all(). Apart from the new PCI entry point and the
second slot, this is the existing platform MSI mechanism unchanged.

(b) The virtio-msi domain is the device's MSI parent.
msi_create_device_irq_domain() parents every per-device domain on
dev->msi.domain, so the function's MSI-X domain and its device MSI domain share
one parent. For a served device that parent must be the virtio-msi domain. It
supplies its own init_dev_msi_info accepting DOMAIN_BUS_PCI_DEVICE_MSIX and
DOMAIN_BUS_DEVICE_MSI (the x86 helper rejects both a non-x86 real parent and the
device MSI token), its own msi_prepare that tags CREATE with the domain type,
and irq_mask/irq_unmask, because the device MSI chip forwards masking to the
parent. MSI-X is then also guest-written. VFIO's host writes to entry i write
the same value, and the VMM must stop emulating the MSI-X table for that device.
This is consistent and simpler than splitting MSI-X and device MSI across two
models.

(c) MSI-X entries must be bound to the host index. The host masks, restores and
refreshes MSI-X entry i (in vfio_msi_set_vector_signal() and
pci_restore_msi_state()). CREATE for MSI-X therefore names index i, and the
guest must write that message only into entry i. Ownership must be defined:

-   address/data: the guest, with the host only rewriting the identical value;
-   the per-vector mask bit: the guest, once set-up completes.

Device MSI has no host writer, so there is no conflict there.

(d) Domain binding on KVM. Hyper-V gives each passthrough device its own
synthetic bus, so dev_set_msi_domain() on the bridge selects the provider. A q35
guest mixes emulated devices, which keep normal MSI, with assigned ones, and x86
has no firmware mechanism such as DT msi-map or ACPI IORT to choose an MSI
parent per device. Put the assigned devices behind a dedicated host bridge (e.g.
pxb-pcie) and bind virtio-msi to that bridge. The device MSI domain lives on the
same function, so it gets the same parent.

(e) Probe ordering and bootstrap. The virtio-msi control device takes its own
interrupts from ordinary emulated MSI, not from its own domain. Its domain must
exist before any served device allocates vectors. A dedicated bridge enumerated
after virtio-msi probes, or -EPROBE_DEFER on the domain's absence, handles that.

(f) Callbacks.

    struct virtio_msi_irq {
            u32 handle;
            struct msi_msg msg;     /* host message, stable until INVALIDATE */
    };

-   .alloc: allocate parent vectors, then CREATE (sleeping). On failure, unwind
    and return the error, so pci_alloc_irq_vectors() or
    pci_device_msi_init_and_alloc_irqs() fails cleanly. Hyper-V instead programs
    0/0.
-   .activate: the parent activates first. Compose the guest-format message from
    the parent and RETARGET.
-   .irq_set_affinity: call the parent, compose its new guest-format message,
    RETARGET, and return IRQ_SET_MASK_OK_DONE so the device storage is never
    rewritten. If RETARGET fails, restore the parent and return an error.
-   .irq_compose_msi_msg: *msg = m->msg.
-   .free: DESTROY (sleeping) after the core has shut the IRQ down.

5.7 Migration and invalidation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The destination host allocates different IRTEs, so every message the guest has
written becomes invalid. For MSI-X the guest can rewrite from cached
descriptors. For device MSI the storage is device-specific, possibly in guest
RAM. Only the driver's write_msi_msg callback can update it, and it must happen
before the device raises interrupts on the destination. Options:

-   INVALIDATE + re-CREATE + rewrite. The core walks each served domain's
    descriptors, recomposes and calls irq_chip_write_msi_msg(), which reaches
    the driver callback. That is a new requirement on device MSI drivers: the
    callback must work outside the normal activation path, and the driver must
    tolerate it while queues are live or quiesced.
-   Host preserves the messages. This is impractical with Intel's global IRTE
    table. It may be feasible with AMD's per-device remap table, because indices
    are per device and the destination's table is empty.

Device-state migration (VFIO migration v2) must also be ordered with this: the
device must not resume before its stored messages are valid. The same path
handles host suspend/resume and control-device reset.

5.8 Points the proposal must settle
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.  Scope: whole-function assignment only (5.3), x86 only. ARM64 with a vITS has
    an architectural path (doorbell mapping plus guest EventIDs installed in the
    physical ITT) and does not need a paravirtual message allocator.
2.  Host-side scale (5.5.3): without vector-less posted IRTEs and incremental
    KVM routing, device MSI in a guest is limited to roughly MSI-X scale.
3.  The write_msi_msg callback contract for migration and invalidation (5.7).
4.  Domain binding: a dedicated bridge (5.6(d)).
5.  Whether RETARGET stays a VMM register (simple, the same cost as today's
    trapped MSI-X write) or becomes a KVM-side operation (scales, new uAPI).

5.9 Prototype order
~~~~~~~~~~~~~~~~~~~

1.  Host: storage-less IR-backed IRQs in VFIO plus message readback. Verify that
    posting through kvm_pi_update_irte works on them.
2.  Guest: virtio-msi parent with MSI-X only (index-bound, guest-written, VMM
    table trap disabled). Verify that the written value equals the host's
    composed message, and that affinity changes cause RETARGET without any
    device rewrite.
3.  Device MSI: add the second per-device domain slot and write
    pci_device_msi_init_and_alloc_irqs(), then allocate a device MSI domain next
    to MSI-X on a test device, or on an emulated device with its own message
    storage in QEMU backed by a real VFIO function.
4.  Failure injection (CREATE/RETARGET), CPU hot-unplug, FLR, guest driver
    unbind with live interrupts.
5.  INVALIDATE/rewrite, then live migration.
6.  Scale tests at thousands of device MSI vectors per guest.

6. Alternative: mirror the guest's interrupt remapping 1:1
----------------------------------------------------------

6.1 The idea
~~~~~~~~~~~~

Sections 4–5 make the host choose the message and teach the guest to ask for it.
The alternative turns this around: the guest chooses the message with its own,
unmodified interrupt remapping driver, and the host makes the physical remapping
hardware match.

With a vIOMMU that does interrupt remapping (VT-d IR, AMD IR), or a vITS on ARM,
a guest driver's device MSI domain is parented on the guest's own remapping
domain. The message it composes is already in remappable form: an IRTE index
(x86) or an EventID (ITS). It names an entry in a guest-owned table, not a
destination. If the host installs, at the same index, a physical entry for the
same source device that delivers to the destination the guest's entry names,
then the guest-written message works on real hardware unchanged. The device
storage needs no trap and no host-provided message, so virtio-msi is
unnecessary.

The destination translation already exists. KVM's posted-interrupt and GICv4
paths turn a guest-format destination into a physical IRTE or vLPI mapping
(5.2). The new requirement is that the host index is chosen by the guest rather
than by the host allocator.

    guest driver:  device MSI domain -> guest IR domain (vIOMMU) -> vector domain
                   composes {IRTE index i}, writes it into device storage
    guest IR:      writes vIRTE[i] = (vBDF, APIC, vector); invalidates index i
    VMM:           traps the invalidation, reads vIRTE[i], maps vBDF -> VFIO device
    host:          allocates a storage-less host IRQ at IR index i for that RID,
                   KVM routing gsi -> (APIC, vector), irqfd, posting as today
    device:        emits {index i} with its RID -> physical IRTE[i] -> vCPU

Retargeting needs nothing new. A guest affinity change rewrites vIRTE[i] and
invalidates it. The VMM updates the KVM route, and kvm_pi_update_irte() rewrites
the physical IRTE. The index, and so the device storage, never changes. That is
the stability property section 5.4 relied on, obtained here without a protocol.

What the host needs in every variant:

-   Storage-less host IRQs (5.5.1), with the extra ability to allocate at a
    caller-specified remapping index or EventID. Today alloc_irte() (Intel),
    alloc_irq_index() (AMD) and its_alloc_device_irq() (ITS) all pick the first
    free slot.
-   A uAPI to request that index, e.g. VFIO "allocate a storage-less IRQ on this
    device at remapping index i", with failure reported if i is not available.
-   A guest that can parent a device MSI domain on its vIOMMU IR domain. That is
    the same x86 gap as on the host (DMAR/AMDVI accepting
    DOMAIN_BUS_DEVICE_MSI), plus the new pci_device_msi_init_and_alloc_irqs()
    (5.1). No paravirtual driver is needed, apart from VT-d's index allocation
    callback (6.2).

Whether the scheme is viable depends entirely on whether the guest's index space
can be made to coincide with a host index space that the host can dedicate to
this device. That differs sharply by architecture.

6.2 Intel VT-d: one global index space per IOMMU
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

How the VMM learns the guest's entry. The guest writes IRTEs into a table in its
own memory, then issues an interrupt entry cache (IEC) invalidation through the
queued-invalidation interface (modify_irte() → qi_flush_iec(), index-selective).
QEMU already traps this. vtd_iec_notify_all() fans it out to IEC notifiers, and
today kvm_update_msi_routes_all() uses it to refresh KVM routes for trapped
MSI/MSI-X. A mirror would add a notifier that, for index i, reads vIRTE[i], uses
its SID (Linux always programs source-ID verification, set_msi_sid()) to find
the VFIO device, and allocates or updates the host IRQ at index i. The guest's
invalidation waits on a QI wait descriptor, so the host update completes before
the guest goes on to write device storage. Ordering is correct for free.

The problem: index collisions. A VT-d message carries a 16-bit handle into the
IOMMU's single interrupt remapping table. There is no per-device or per-domain
table and no offset. The physical table on that IOMMU is shared by the host's
own interrupts, by every other assigned device behind it, and by every other
guest. The guest's IR driver allocates from index 0 upward
(bitmap_find_free_region()), exactly as the host's does and as every other
guest's does. Guest index i will often already be taken on the host.

VT-d gives the vIOMMU no way to tell the guest "that index is busy". IEC
invalidation cannot fail. The best the VMM can do is leave the interrupt dead
and perhaps log a fault, which is the silent-failure mode section 4 criticised
in Hyper-V.

The fix: a paravirtual index allocation callback. The guest must not pick the
index itself. It asks the host. The vIOMMU advertises a PV capability, and the
guest's alloc_irte() calls it instead of searching its own bitmap:

    guest alloc_irte(SID, count)
       -> PV ALLOC(SID, count)         trapped vIOMMU register (or hypercall)
       host: find a free, count-aligned block on the physical IOMMU behind the
             device with that SID; reserve it for that RID; return index i
       guest marks i..i+count-1 used in its bitmap, writes vIRTE[i], flushes IEC
       -> existing IEC trap: VMM reads vIRTE[i], programs physical IRTE[i]
    guest clear_entries(i)
       -> PV FREE(i)                   host releases the reservation

-   Only allocation is paravirtual. The IRTE format, the remappable message, IEC
    invalidation, retargeting and posting all stay architectural VT-d, and they
    reuse the QEMU trap points above. This is far thinner than virtio-msi: there
    is no host-composed message, no CREATE/RETARGET protocol and no new guest
    IRQ domain. The change is a hook in the guest's Intel IR driver.
-   Allocation can fail cleanly. The PV call returns an error, so alloc_irte()
    fails and the IRQ allocation unwinds. That is the failure path IEC
    invalidation lacks.
-   It must be synchronous and cheap. alloc_irte() runs under irq_2_ir_lock (a
    raw spinlock) during IRQ domain allocation. A trapped vIOMMU register write
    with status readback fits that context; a virtqueue does not. Alternatively
    the guest calls out before taking the lock.
-   All guest allocations go through it. Indices for emulated devices need no
    physical IRTE, but they must not collide with indices the host later hands
    out for assigned devices in the same vIR table. Letting the host hand out
    every index keeps the guest's table and the reservations consistent. For an
    emulated SID the host just allocates from a per-VM bitmap without touching
    hardware.
-   MSI-X can use the same path. If the host IRQ for MSI-X entry k is allocated
    at the guest-obtained index, the guest-written MSI-X message equals the
    host's, as in the AMD case (6.3).

Alternatives considered, all worse:

-   One mirroring guest per physical IOMMU. The host allocates its own IRTEs
    from the top of the table, and one guest gets the low indices. This is
    deterministic but unscalable, and it depends on the platform's DRHD
    topology.
-   Pre-reserve a static window. Boot the vIOMMU with IR pre-enabled and every
    vIRTE outside a host-reserved window marked present, so that the guest's
    iommu_load_old_irte() avoids them. That path runs only in a kdump kernel, so
    it still needs a guest change, and it fixes the window size at boot.
-   Host IRTE window per guest, plus a fixed offset. Not possible: the device
    emits the guest's index verbatim, and VT-d has no per-source index offset.

Smaller issues:

-   Multi-vector blocks: alloc_irte() aligns count to a power of two and uses
    the handle mask in invalidations. The host must reserve the same aligned
    block.

-   The guest may use a global IEC invalidation (also issued when IRTA is
    written). The VMM then has to rescan up to 64K vIRTEs.

-   Scale is unchanged from 5.5.3: each mirrored entry is still a host IRQ, a
    host vector and a KVM route.

-   Migration: the indices are guest state (in vIRTEs and in device storage).
    The destination host must reserve the same indices on its physical IOMMU,
    and with a global table they may already be in use there. Fixing that needs
    either a per-VM index range coordinated across the migration pool, or a host
    → guest "reallocate" event that makes the guest rewrite device storage. The
    latter is the 5.7 problem again.

Verdict: VT-d needs one PV hook, an index allocation callback in the guest's IR
driver, because its handle space is global. With that hook, the rest of the
mirroring scheme is architectural and reuses existing QEMU and KVM paths.
Migration remains the weak point.

6.3 AMD-Vi: per-device index space
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

AMD remaps through a per-DeviceID interrupt table referenced from the DTE (512
entries, or 2048 with MAX_IRQS_PER_TABLE_2K). The message's data field carries
the index, and the IOMMU looks it up in the table belonging to the requester's
DeviceID. QEMU's AMD vIOMMU likewise gives the guest a per-device table and
traps INVALIDATE_INTERRUPT_TABLE (AMDVI_CMD_INVAL_INTR_TABLE), calling the same
IEC notifier chain.

For whole-function assignment (5.3) the physical table belongs to that one
device. No other device, guest or host consumer shares it. The guest's index i
and the host's index i live in the same private namespace, so the collision
problem from 6.2 does not arise for device MSI.

The one sharer is the host itself, for the same device's MSI-X: VFIO allocates
host MSI-X IRTEs in the same per-device table, at indices chosen by
alloc_irq_index(). The guest's IR driver also allocates its MSI-X vIRTEs in its
per-device table. Two consistent options:

-   Mirror everything. When the guest writes a remappable MSI-X message (data =
    vIRTE index i), VFIO allocates the host MSI-X IRQ at IRTE i too. The
    host-composed message then equals the guest-written one, and MSI-X table
    trapping is no longer needed for correctness either.
-   Partition. The host keeps MSI-X in a range the guest's allocator will not
    use. The guest allocator, like Intel's, gives no such guarantee without a
    hint, so this is the weaker option.

Caveats:

-   The table is per DeviceID, which is the alias after DMA aliasing. A function
    behind a PCIe-to-PCI bridge shares its table with its siblings, so only
    functions with their own DeviceID qualify. This is the same condition as
    5.3.
-   Capacity is 512 or 2048 entries per device. That is enough for many
    device-MSI uses, though well short of the "thousands per device" goal.
-   The AMD vIOMMU in QEMU must emulate interrupt remapping completely enough
    for the guest to use it (including x2APIC and the table-length encoding),
    and the guest must enable IR on it.

Verdict: AMD-Vi fits the mirroring model well. The host work is index-pinned,
storage-less host IRQs plus a VMM notifier. No guest PV interface is needed.

6.4 ARM GICv3/v4 ITS: per-device EventID space
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ITS is architecturally the closest match. A device's MSI is a write of an
EventID to the ITS doorbell (GITS_TRANSLATER). The DeviceID comes from the bus
(RID → StreamID → DeviceID through IORT / msi-map), not from the message.
Translation is per DeviceID: a device table entry points to that device's ITT,
indexed by EventID. EventIDs are therefore a private namespace per device, like
AMD-Vi and unlike VT-d.

The guest drives a vITS. It issues MAPD (virtual DeviceID → ITT) and MAPTI
(DeviceID, EventID → vLPI, collection), then writes the EventID into device
storage. For that write to reach the guest on real hardware:

1.  EventID. The host ITT for the physical DeviceID must contain the guest's
    EventID e, mapped to a host LPI, and with GICv4 forwarded (VMAPTI) to the
    guest's vLPI. The host ITS allocates events with its_alloc_device_irq(), the
    first free region of lpi_map. It would need to allocate at a requested
    EventID. The obvious rule for the device MSI domain is EventID = msi_index,
    which VFIO sets to e.
2.  ITT sizing. its_msi_prepare() reuses an existing its_device for the DeviceID
    ("shared") and keeps the ITT size from first creation. If MSI-X created the
    ITT with 32 events, a device MSI domain on the same DeviceID cannot place
    events beyond that. The ITT has to be sized for the whole guest-visible
    EventID range at the first allocation, or be grown.
3.  Doorbell address. The device writes to the guest's vITS doorbell address.
    That is a GPA (no vSMMU), or an IOVA the guest's stage 1 maps to that GPA
    (nested vSMMU). Host stage 2 must map that GPA to the physical
    GITS_TRANSLATER page of the ITS serving the device. Today the host maps the
    physical doorbell at the reserved SW_MSI window (MSI_IOVA_BASE) that the
    host itself chose (iommufd_sw_msi), and the guest's vITS doorbell sits
    elsewhere. One of two things is needed: either the VMM places the vITS
    doorbell where the host maps the physical one, or there is a new uAPI to map
    the physical doorbell at a VMM-chosen IPA. iommufd has neither today.
4.  Learning the guest's events. With the in-kernel vITS, MAPTI is handled by
    KVM (vgic_its_cmd_handle_mapi()), not QEMU. KVM already resolves (DeviceID,
    EventID) → vLPI and calls its_map_vlpi() when an irqfd route is attached
    (kvm_vgic_v4_set_forwarding()). But it does that lazily: forwarding happens
    at route time, and MAPTI only creates the vLPI. Two options:
    -   The VMM pre-allocates host events 0..N-1 for the device, with routes for
        each (DeviceID, e). This is a quota-sized upfront cost. KVM then
        forwards whichever ones the guest maps.
    -   KVM (or a KVM → VMM exit on MAPTI/DISCARD for assigned DeviceIDs) drives
        host event allocation on demand. That is new KVM ↔ VFIO plumbing.
5.  Retarget is MOVI/VMOVI, already handled by KVM for forwarded vLPIs. The
    EventID, and so device storage, never changes.

Security matches 5.3. The guest can only name EventIDs in its own device's ITT,
and the DeviceID is fixed by the hardware path. A shared DeviceID (aliasing, or
SIOV-style sharing) breaks it the same way.

Verdict: the ITS model supports mirroring without collisions. The work lies in
the host ITS driver (allocating at an EventID, ITT sizing), in the doorbell
mapping uAPI, and in how KVM/VMM learn guest events. As 5.8 noted, this is also
the native ARM answer that never needed a message allocator.

6.5 Comparison with virtio-msi
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  --------------------------------------------------------------------------------------
              virtio-msi (5) Mirror on VT-d       Mirror on AMD-Vi  Mirror on ITS
  ----------- -------------- -------------------- ----------------- --------------------
  Guest PV    virtio-msi IRQ index alloc/free     none              none
  interface   domain +       callback in the IR                     
              protocol       driver                                 

  Who picks   host           host, via PV         guest             guest
  the index                  callback                               

  Collision   none           none: host allocates none: per-device  none: per-device ITT
  risk                       in the global table  table             

  Failure     CREATE status  PV ALLOC status      none, but cannot  none, but cannot
  reporting                                       collide           collide
  to guest                                                          

  Retarget    trapped        existing IEC trap →  existing trap →   existing KVM vITS
              register       KVM route            KVM route         

  Main new    storage-less   PV alloc/free,       index-pinned      EventID-pinned
  host work   IRQs, protocol index-pinned IRTEs,  IRTEs, QEMU       alloc, ITT sizing,
                             QEMU notifier        notifier          doorbell mapping,
                                                                    event discovery

  Migration   INVALIDATE +   destination must     destination       destination
              guest rewrite  reproduce indices:   reproduces        reproduces
              (5.7)          fragile with a       per-device        per-device EventIDs:
                             global table, even   indices: feasible feasible
                             with PV alloc                          
  --------------------------------------------------------------------------------------

Migration deserves emphasis. With mirroring, the guest's indices are part of the
guest state, held in guest memory and in device storage that only the guest
driver can rewrite. The destination host must recreate exactly those indices.
That works for per-device namespaces (AMD-Vi, ITS), because the destination
device's table is empty. With VT-d's global table it fails whenever the
destination IOMMU already uses one of them. This is the mirror image of 5.7,
where virtio-msi needs the guest to rewrite storage instead.

Overall: 1:1 mirroring removes the need for virtio-msi where the remapping index
space is per device: AMD-Vi and the ARM ITS. On Intel VT-d the global handle
space needs one PV hook, an index allocation callback in the guest's IR driver.
That is still much smaller than virtio-msi, because the message format,
retargeting and posting stay architectural. Migration on VT-d remains fragile
without a coordinated per-VM index range, a guest rewrite path, or a hardware
change (per-device or per-domain IR tables).

Source reading map
------------------

arch/x86/hyperv/hv_init.c

-   Functions: create_pci_msi_domain hook
-   What they establish: Root-partition provider selection

arch/x86/hyperv/irqdomain.c

-   Functions: hv_irq_compose_msi_msg, hv_map_interrupt,
    hv_build_devid_type_pci, entry_to_msi_msg, hv_teardown_msi_irq
-   What they establish: Hypercall output becomes the message; unmap+map on move

drivers/pci/controller/pci-hyperv.c

-   Functions: hv_pcie_init_irq_domain, hv_compose_msi_msg,
    hv_irq_retarget_interrupt, hv_arch_irq_unmask, hv_msi_free,
    hv_pci_vec_irq_domain_alloc (ARM64), hv_pci_restore_msi_state
-   What they establish: VMBus CREATE, hypercall RETARGET, per-bus binding, SPI
    model, resume

kernel/irq/chip.c

-   Functions: irq_chip_compose_msi_msg
-   What they establish: Finding the composer in the hierarchy

kernel/irq/msi.c

-   Functions: msi_domain_activate, msi_domain_set_affinity
-   What they establish: Compose → write; recompose on move unless OK_DONE

kernel/irq/migration.c

-   Functions: irq_move_masked_irq
-   What they establish: Deferred moves run in interrupt context

drivers/pci/msi/irqdomain.c

-   Functions: pci_msi_domain_write_msg
-   What they establish: Device domain write callback

drivers/pci/msi/msi.c

-   Functions: __pci_write_msi_msg
-   What they establish: Config-space / MSI-X table programming

drivers/vfio/pci/vfio_pci_intrs.c

-   Functions: vfio_msi_set_vector_signal, vfio_msi_alloc_irq
-   What they establish: Host IRQ per MSI-X index, message refresh, irq bypass
    producer

drivers/iommu/intel/irq_remapping.c

-   Functions: intel_ir_compose_msi_msg, fill_msi_msg, intel_ir_set_affinity,
    intel_ir_set_vcpu_affinity, set_msi_sid
-   What they establish: Stable remappable message; IRTE-only retarget;
    source-ID isolation

drivers/iommu/amd/iommu.c

-   Functions: amd_ir_set_affinity, amd_ir_set_vcpu_affinity
-   What they establish: Same properties on AMD

drivers/base/platform-msi.c

-   Functions: platform_device_msi_init_and_alloc_irqs, platform_msi_template,
    platform_device_msi_free_irqs_all
-   What they establish: Device MSI domain with a driver write callback; masking
    forwarded to the parent. Model for the new PCI helper

kernel/irq/msi.c, include/linux/msi_api.h

-   Functions: msi_create_device_irq_domain, msi_domain_ids
-   What they establish: Per-device domain parented on dev->msi.domain; only one
    slot per device today

drivers/irqchip/irq-msi-lib.c

-   Functions: msi_lib_init_dev_msi_info
-   What they establish: How non-x86 parents accept DOMAIN_BUS_DEVICE_MSI

arch/x86/kernel/apic/msi.c

-   Functions: x86_init_dev_msi_info, x86_msi_prepare
-   What they establish: x86 parents accept only PCI MSI/MSI-X device domains

arch/x86/kvm/irq.c

-   Functions: kvm_pi_update_irte, kvm_arch_update_irqfd_routing
-   What they establish: Guest routing change → posted IRTE update

drivers/iommu/intel/irq_remapping.c

-   Functions: alloc_irte, modify_irte, qi_flush_iec, iommu_load_old_irte,
    fill_msi_msg
-   What they establish: Global first-fit IRTE allocation; IEC invalidation per
    index; pre-enabled IR copy (kdump only)

drivers/iommu/amd/iommu.c

-   Functions: alloc_irq_index, irq_remapping_alloc
-   What they establish: Per-DeviceID interrupt table, 512/2048 entries

drivers/irqchip/irq-gic-v3-its.c

-   Functions: its_msi_prepare, its_alloc_device_irq, its_map_vlpi
-   What they establish: Per-DeviceID ITT, first-fit EventIDs, ITT size fixed at
    first use, GICv4 forwarding

arch/arm64/kvm/vgic/vgic-its.c, arch/arm64/kvm/vgic/vgic-v4.c

-   Functions: vgic_its_cmd_handle_mapi, kvm_vgic_v4_set_forwarding
-   What they establish: In-kernel vITS commands; vLPI forwarding set up at
    irqfd route time

QEMU hw/i386/intel_iommu.c, hw/i386/amd_iommu.c, target/i386/kvm/kvm.c

-   Functions: vtd_iec_notify_all, AMDVI_CMD_INVAL_INTR_TABLE,
    kvm_update_msi_routes_all
-   What they establish: VMM trap points for guest IRTE changes
