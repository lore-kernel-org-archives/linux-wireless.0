Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793888810;
	b=lLkcs0CvCNBhu2N7zJdN05bnhiweoyqe12MXrFdY6OngzG6LQOVI13JkROKPNVCfyXym
	 6FrEAHgyTK4n4W9e/o7LPB5g8QidxeSLT22LsJkhrYNdr0/Araw21tfXqVgMHID02OWpy
	 g7uNgWsk+V8vxSKDS2NfC7jWyrwf8BewmWgc1dxdm+ZM/Ha/wAAcH6y/sSrH2qawoJWLe
	 jOaF3KF5w+j4Cnf8515SMfw+nUn26aiiB42zOEuG/+/j7Fbjnp9o2+4P3vFv5ezMop5B9
	 csL4MDlLJEbEFtIq2klIfs5dLTn8wZWPDwN/dAfPmkkcnHE1muD1NwertxGE989Og5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793888810;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=8tdn6dFMYzvjD1/tcuOzz3T5ZY4fgIEe/XSJ/yOC0VU=;
	b=lCx8OCW3LzeyYfCdkZwvOwZaGX8ZUJBPSmsW5ltm4Yb63wShO02CID3PsIbZnqVefRB+
	 lnJc1Sn0lLQd5F03ddF79B6PS9ZAhMW5issZY4vk8Wc6PQPz7CEJ/Wedc3jrTPMaln9Jg
	 zeScBcTmP1/H3e1Gg1h/pHCHdpM5uo6ckwuhQ10SnewFH4pEO71PGIEIq4p+74ya84T/u
	 z3pKUCWqZIPhaqO2M5aThpto6Ok/FPi0d2gN66D6DGQU6wGpu8fg+NdjCgO5sU6BhYZM8
	 V3dWxTB7ZBB6iiqCWVJpf/PrZevmPiK2hC1nMksolzky0Jh5vzGnDP8OnhjjoJsqSaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cJWAmd8Q;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B04606A334;
	Thu,  5 Nov 2026 14:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4B04606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cJWAmd8Q
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B3A2168F;
	Thu,  5 Nov 2026 06:26:46 -0800 (PST)
Received: from [10.57.91.118] (unknown [10.57.91.118])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 130253F673;
	Thu,  5 Nov 2026 06:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793888809; bh=S2PpLzqNd6JkA5UshEwL2dUlGxdSp5aBcBkcVghGE4w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cJWAmd8Q2UsNZWHQoK2zLyPyp1panymsoh5cGokf/cTF0mOzqj0pJ/HQKfw4vOOF6
	 kcsPHroHUBVIkbtWoKbz4TQR8JeIK5Bn+5oJ0YbUt1S+GSWmGK7EJLSO3pkCjh1Ue/
	 3QhpmR0AXAzkV765UiaqgUwErSvy04Af3Zj59n1k=
Message-ID: <0438755d-dc1f-4c8c-b274-5555ef3d49a3@arm.com>
Date: Thu, 5 Nov 2026 14:26:39 +0000
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/17] driver core: Expose device trust authorization
 through sysfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
 Heiner Kallweit <hkallweit1@gmail.com>, Russell King
 <linux@armlinux.org.uk>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Johan Hovold <johan@kernel.org>, Eric Dumazet <edumazet@kernel.org>,
 Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Nipun Gupta <nipun.gupta@amd.com>, Nikhil Agarwal <nikhil.agarwal@amd.com>,
 Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-input@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-pci@vger.kernel.org, iommu@lists.linux.dev,
 Jason Gunthorpe <jgg@ziepe.ca>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-10-1e536825b4eb@nvidia.com>
 <2026110514-bunkhouse-handset-6a3a@gregkh> <20261105132729.GB8298@unreal>
 <2026110535-engulf-precut-cf10@gregkh>
 <9d896ebb-6892-4cac-a7c5-41def47f0be0@arm.com>
 <2026110556-sculpture-immovable-ca8b@gregkh>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <2026110556-sculpture-immovable-ca8b@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-11-05 2:03 pm, Greg Kroah-Hartman wrote:
> On Thu, Nov 05, 2026 at 01:59:20PM +0000, Robin Murphy wrote:
>> On 2026-11-05 1:40 pm, Greg Kroah-Hartman wrote:
>>> On Thu, Nov 05, 2026 at 03:27:29PM +0200, Leon Romanovsky wrote:
>>>> On Thu, Nov 05, 2026 at 08:10:14AM -0500, Greg Kroah-Hartman wrote:
>>>>> On Thu, Nov 05, 2026 at 01:42:23PM +0200, Leon Romanovsky wrote:
>>>>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>>>>
>>>>>> An initrd must authorize a disabled device after attestation even if a
>>>>>> built-in driver already attempted to probe it.
>>>>>>
>>>>>> Expose requested trust_policy and read-only active trust. Allow explicit
>>>>>> disabled policy to advance once to adversary or full, fixing that decision
>>>>>> immediately. Reject later policy changes, including for a device claimed
>>>>>> before registration, while allowing same-value writes on live devices.
>>>>>> Keep initial unrestricted selection separate from explicit authorization
>>>>>> and bind-time commitment. Serialize writes with probing under the device
>>>>>> lock. Include the attributes in device ownership changes.
>>>>>>
>>>>>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>>>>>> ---
>>>>>>    Documentation/ABI/testing/sysfs-devices-trust |  51 +++++++++++++
>>>>>>    MAINTAINERS                                   |   1 +
>>>>>>    drivers/base/base.h                           |   6 ++
>>>>>>    drivers/base/core.c                           |  15 +++-
>>>>>>    drivers/base/trust.c                          | 102 ++++++++++++++++++++++++++
>>>>>>    5 files changed, 174 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/Documentation/ABI/testing/sysfs-devices-trust b/Documentation/ABI/testing/sysfs-devices-trust
>>>>>> new file mode 100644
>>>>>> index 0000000000000..97e07a174769c
>>>>>> --- /dev/null
>>>>>> +++ b/Documentation/ABI/testing/sysfs-devices-trust
>>>>>> @@ -0,0 +1,51 @@
>>>>>> +What:		/sys/devices/.../trust
>>>>>> +Date:		September 2026
>>>>>> +Contact:	driver-core@lists.linux.dev
>>>>>> +Description:
>>>>>> +		(RO) The active trust level for the device. The values are
>>>>>> +		"disabled", "adversary", and "full". Driver core resolves
>>>>>> +		the level before DMA configuration and probe, and retains it
>>>>>> +		through removal and DMA cleanup. Outside a bind transaction
>>>>>> +		the level is "disabled". This does not imply that policy is
>>>>>> +		writable or that the device has never operated.
>>>>>> +
>>>>>> +What:		/sys/devices/.../trust_policy
>>>>>> +Date:		September 2026
>>>>>> +Contact:	driver-core@lists.linux.dev
>>>>>> +Description:
>>>>>> +		(RW) The requested trust policy for the device. The initial
>>>>>> +		value may be selected by the bus before the device is
>>>>>> +		registered; otherwise it is "default". The policy is resolved
>>>>>> +		to an active trust level before the device is probed.
>>>>>> +
>>>>>> +		The values are "default", "disabled", "adversary", and
>>>>>> +		"full". "default" lets the bus select the active trust level.
>>>>>> +		"disabled" prevents a functional driver from binding.
>>>>>> +		"adversary" requests operation with the restrictions that the
>>>>>> +		bus and DMA layers can enforce for a potentially malicious
>>>>>> +		device; it does not isolate DMA by itself. "full" requests
>>>>>> +		normal operation.
>>>>>> +
>>>>>> +		Before an operating level is committed, policy may change
>>>>>> +		freely until "disabled" is selected. Explicit "disabled"
>>>>>> +		blocks binding while allowing a later write of "adversary" or
>>>>>> +		"full". Repeated rejected probes preserve this opportunity.
>>>>>> +		Authorization immediately fixes the requested policy.
>>>>>> +		Returning to "default" or "disabled", or selecting another
>>>>>> +		mode, fails.
>>>>>> +
>>>>>> +		Successful resolution to an allowed level commits policy
>>>>>> +		and operating level before driver or DMA setup. Both remain
>>>>>> +		fixed for the device object's lifetime, including through
>>>>>> +		failed or deferred probes, unbind, reset, and driver reload.
>>>>>> +		Later binds must resolve to the same level, including when
>>>>>> +		the policy is "default". A resolver error or disabled result
>>>>>> +		before commitment leaves the policy's writability unchanged.
>>>>>
>>>>> I understand you are aproaching this from a PCI point-of-view, but many
>>>>> busses do not care or have DMA at all, and need to actually talk to the
>>>>> device before being able to even "add" it to the kernel.  So you are
>>>>> making a driver core-specific policy based on mentioning DMA here, when
>>>>> really that should only be a bus-specific thing, right?  Some busses
>>>>> might require DMA to happen (i.e. USB needs their host controllers to
>>>>> use DMA to even talk to the device at all).
>>>>>
>>>>> So can this be written to be more vague and generic and then put the
>>>>> specifics in the bus-specific portion?
>>>>
>>>> Yes, of course. The main point is that drivers must not communicate with
>>>> or configure hardware before attestation is approved. DMA is the PCI
>>>> way to communicate with hardware.
>>>
>>> That's a very vague statement of "must not communicate with".  Busses
>>> HAVE to talk to the device to determine what the device even is before
>>> it can add it to its internal bus list.  That's just how the hardware
>>> works, you can't say "no talking at all" otherwise that means that you
>>> never even know if a device is there (and for some busses, you'll miss
>>> the device entirely as they can only be found when the "host controller"
>>> tells the kernel that a device showed up, not later by manually
>>> scanning.)
>>>
>>> Think about reading PCI device ids, or USB configuration information,
>>> that's a bus-core thing.  Are you really thinking that non of this can
>>> be read from a device under this "policy"?
>>
>> Yup, and that's true even in the PCI TDISP case - there's a major amount of
>> "communication" and "configuration" involved in that. The principle which
>> should (hopefully) generalise is that a bus/host controller driver can
>> always interrogate its child device to perform whatever attestation and
>> general configuration is appropriate, but we won't hand off any _control_ of
>> that device to a specific device driver (nor enable potentially-impactful
>> bus-level features like DMA, interrupts, etc. if relevant) without the
>> requisite agreement between the bus code and the user.
> 
> I agree, that's fine, the bus core should always be able to talk to the
> device, the "barrier" is where the device is handed to a driver for that
> bus.  That's what I'm trying to say here, DMA is often needed before
> that can ever happen, so no claims of "no dma is happening" should be
> here.

For the case of USB and co. it's also still fine - just perhaps wants 
some clearer wording - since the endpoint itself is not performing DMA 
operations. It might send some message which causes the host controller 
device to DMA to/from a buffer owned by the host controller driver, but 
that's perfectly OK since the host controller itself is not on its own 
bus, and must have already been accepted by the PCI/platform/whatever 
code to get to that point.

Now if we had some bonkers kind of bus where the only way to identify an 
endpoint was to give it DMA addresses to have it read a command 
descriptor and write out its own data directly, then indeed there would 
be little hope of being able to enforce much of a trust model for that...

Thanks,
Robin.
