Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793886168;
	b=ur51AVUyuE9gBab6aTcF8G1+RaTzy7XZYokcJLzZ6HuaKdNURopBSNbCV2agBkIfBokn
	 mTkuSZ37UfaEDgBAK4gn5qS5zr57QhFaEd+s2kgJTPfyUbunwuwpNDqwy5l6tecuu78Xo
	 HxYUp0LCtfML9533fwU5doosSRar+WZtPSKerwp2GJu82cFukyVoCppCxJ1TE0cusAJb8
	 EKKj0a+puIOA/SpEbb3lWNnBsNnGLvKIV620jWHZE6iOroXQ7ZoA7PlMnywVUq0gEPtpQ
	 M/4yTGrOp6WL64Ek0iNWX52C1v1OsSOC2KbVCJqGp0Lk05t0DcYtN3eBPMriTNslrUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793886168;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=5JtIMbH8bYb+/uBp8MYmywFxXn4OxXIrKJE7bqVu5FQ=;
	b=Q//rn5YYaHE8WA63BPxwEOGwitmnhHmGFb5PW5emndUq5kLipj3e6zqeahjEYKE8U7oW
	 e/mfK0WhRMZnwfA0nHlIyJwWGI1wKwHRqb2cj62Xzf4RnbvlItWwY3awr3zvbfti69d7E
	 RYPItrLnBkWZkuG8x9Az5h7oNmqnvJK2vKOmCStZhOEssIRW6BuLXUNcCvK3YtBURQSgN
	 7OO6/xmZ4r2JGoU1Q7uDjYsVqUTChs+gWQAFwxQcEQ/aiKKupn01gkUe3Bf1BpRoFs15M
	 IW0YqNJcBq93DGGGOyWn8auHt6o5ZvD4zFSpwREMVBBXUjmJY4a62j/rAidgacGZMfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KNWXrjUt;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EEF2606A328;
	Thu,  5 Nov 2026 13:42:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EEF2606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KNWXrjUt
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 380F41650;
	Thu,  5 Nov 2026 05:42:43 -0800 (PST)
Received: from [10.57.91.118] (unknown [10.57.91.118])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60A813F628;
	Thu,  5 Nov 2026 05:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793886166; bh=LveRI2qxSsupfhBJHDyhXy7DoKCO1CvAkdTDvg906zs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KNWXrjUtNKtutWMxTDb6oou+QYOV4dLBHiS5rUJsEnDvfiDU1x3OfmQand0VegEod
	 UOK5Sv9i74jXcnRzH9HeBpwpKOepeebwy93Qohp+Tnba+eYsw0g6ifDRMYL5b7ZtFG
	 0+0UWxjwJlwl05oorBvOj1xVVcR9Kgdz1hgMMXEs=
Message-ID: <9b43db9e-4eaf-4cac-a203-4b444202160b@arm.com>
Date: Thu, 5 Nov 2026 13:42:37 +0000
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
To: Leon Romanovsky <leon@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
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
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20261105132729.GB8298@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-11-05 1:27 pm, Leon Romanovsky wrote:
> On Thu, Nov 05, 2026 at 08:10:14AM -0500, Greg Kroah-Hartman wrote:
>> On Thu, Nov 05, 2026 at 01:42:23PM +0200, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>
>>> An initrd must authorize a disabled device after attestation even if a
>>> built-in driver already attempted to probe it.
>>>
>>> Expose requested trust_policy and read-only active trust. Allow explicit
>>> disabled policy to advance once to adversary or full, fixing that decision
>>> immediately. Reject later policy changes, including for a device claimed
>>> before registration, while allowing same-value writes on live devices.
>>> Keep initial unrestricted selection separate from explicit authorization
>>> and bind-time commitment. Serialize writes with probing under the device
>>> lock. Include the attributes in device ownership changes.
>>>
>>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>>> ---
>>>   Documentation/ABI/testing/sysfs-devices-trust |  51 +++++++++++++
>>>   MAINTAINERS                                   |   1 +
>>>   drivers/base/base.h                           |   6 ++
>>>   drivers/base/core.c                           |  15 +++-
>>>   drivers/base/trust.c                          | 102 ++++++++++++++++++++++++++
>>>   5 files changed, 174 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-devices-trust b/Documentation/ABI/testing/sysfs-devices-trust
>>> new file mode 100644
>>> index 0000000000000..97e07a174769c
>>> --- /dev/null
>>> +++ b/Documentation/ABI/testing/sysfs-devices-trust
>>> @@ -0,0 +1,51 @@
>>> +What:		/sys/devices/.../trust
>>> +Date:		September 2026
>>> +Contact:	driver-core@lists.linux.dev
>>> +Description:
>>> +		(RO) The active trust level for the device. The values are
>>> +		"disabled", "adversary", and "full". Driver core resolves
>>> +		the level before DMA configuration and probe, and retains it
>>> +		through removal and DMA cleanup. Outside a bind transaction
>>> +		the level is "disabled". This does not imply that policy is
>>> +		writable or that the device has never operated.
>>> +
>>> +What:		/sys/devices/.../trust_policy
>>> +Date:		September 2026
>>> +Contact:	driver-core@lists.linux.dev
>>> +Description:
>>> +		(RW) The requested trust policy for the device. The initial
>>> +		value may be selected by the bus before the device is
>>> +		registered; otherwise it is "default". The policy is resolved
>>> +		to an active trust level before the device is probed.
>>> +
>>> +		The values are "default", "disabled", "adversary", and
>>> +		"full". "default" lets the bus select the active trust level.
>>> +		"disabled" prevents a functional driver from binding.
>>> +		"adversary" requests operation with the restrictions that the
>>> +		bus and DMA layers can enforce for a potentially malicious
>>> +		device; it does not isolate DMA by itself. "full" requests
>>> +		normal operation.
>>> +
>>> +		Before an operating level is committed, policy may change
>>> +		freely until "disabled" is selected. Explicit "disabled"
>>> +		blocks binding while allowing a later write of "adversary" or
>>> +		"full". Repeated rejected probes preserve this opportunity.
>>> +		Authorization immediately fixes the requested policy.
>>> +		Returning to "default" or "disabled", or selecting another
>>> +		mode, fails.
>>> +
>>> +		Successful resolution to an allowed level commits policy
>>> +		and operating level before driver or DMA setup. Both remain
>>> +		fixed for the device object's lifetime, including through
>>> +		failed or deferred probes, unbind, reset, and driver reload.
>>> +		Later binds must resolve to the same level, including when
>>> +		the policy is "default". A resolver error or disabled result
>>> +		before commitment leaves the policy's writability unchanged.
>>
>> I understand you are aproaching this from a PCI point-of-view, but many
>> busses do not care or have DMA at all, and need to actually talk to the
>> device before being able to even "add" it to the kernel.  So you are
>> making a driver core-specific policy based on mentioning DMA here, when
>> really that should only be a bus-specific thing, right?  Some busses
>> might require DMA to happen (i.e. USB needs their host controllers to
>> use DMA to even talk to the device at all).
>>
>> So can this be written to be more vague and generic and then put the
>> specifics in the bus-specific portion?
> 
> Yes, of course. The main point is that drivers must not communicate with
> or configure hardware before attestation is approved. DMA is the PCI
> way to communicate with hardware.

Indeed the principle of "I trust that this device is what it claims to 
be" should be universal, and that's really the thing we should represent 
here, it's just that most existing buses (especially simpler lower-level 
ones like I2C/SPI/etc.) are unlikely to ever have any kind of mechanism 
to be able to usefully attest that.

DMA is simply the biggest and most prominent attack surface for 
malicious devices, as it gives them the means to attempt to access 
arbitrary addresses; however even a non-DMA-capable device is still 
potentially capable of maliciously doing the "wrong" thing with data 
that a kernel driver explicitly gives it - imagine something pretending 
to be a USB network adapter that's actually clever enough to MITM your 
data at the packet level...

Thanks,
Robin.
