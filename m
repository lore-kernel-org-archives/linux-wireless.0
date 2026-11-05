Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793891373;
	b=GGED4VF4KfgVYHs79Z//51w/FIh9SAaeylW+yIjkPWDHEemK/kXA+wXV8JMvxdw0+qzG
	 TVNP0HprWB7vpFM5kxfsbDBgj5y+TvWC31IHcvViQYH5TsHGXIy9nrQZFGFpuhUqnTsdJ
	 a+xyZbZUPehhJv4FAjs0ENC8TtfoXT5pY+rSY590CeoC+Arpu1BTYo1k+5BXV5qT8R9/P
	 ByVsCP1TMDPZJD831XsYiMtI7BVy5nmsZO62sUjVCiPtfspRCbVm4A4ErKVRJXV8uDrC/
	 GBIWS5ZZTPpn1FIb3VW09bZlMIgQ0bTYqUe6MtjvJK9+tabXuji2+2008otjNxsr4Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793891373;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=lH1ltevs83dtmov7AeoaOtzW5b1IMJNtetcxHKo5Ado=;
	b=Nz9cD+DF2P1kDqyExlOnCa67nVDrWZMK9t36SVIIix6GZMR9cb4vSI2sNzQSRmr3F24E
	 gJSnfqkDM3OCWtqESpyBId9r7IWa25Is8BdOvYlXCYuRfqKTpui7jbpzWjS+gw/Fg746A
	 62tmh73biVPmC8RobupqkZvDEI3JgxQ+RpvJsRaXd2Mq3+hgMiOyRb2t3jKVpodm4kO1m
	 /FZYtdjQKEGQ9izS94KXkpN6q5CsSYFpgMQ0L4sXagawk1W3FeTdeHgNglpBTxPj6lzZY
	 lSFhKrx3RhrTly47dLXifF4gK8sRM1bKWQh7JrQtzx/ItsgQuzzcwuHLO/jPCgyiHTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VCP6qIrz;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB6B606A329;
	Thu,  5 Nov 2026 15:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EB6B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VCP6qIrz
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A05CA168F;
	Thu,  5 Nov 2026 07:09:28 -0800 (PST)
Received: from [10.57.91.118] (unknown [10.57.91.118])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AE573F628;
	Thu,  5 Nov 2026 07:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793891371; bh=pW1v+SUP5iuAtVIsaHMltHU2oqWWAZHypp8kLCcZOHA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VCP6qIrzd+r56KzOdIi37J2n2fCroMEvtLphSONkfOUnirk8EYH4j0XtxQdX/3TBt
	 PP5lb+xbOY5mzrqL9Iqv1osvgW7aH1zNLJNnaAz9y/U8PgTn9C7kkI5uoRggE/hXKm
	 6WM/59iEZkWbcJPHfUfA3mpaWUMPnq36yUF0B9XQ=
Message-ID: <7b9329ab-01a7-45ae-b774-aec4e91da863@arm.com>
Date: Thu, 5 Nov 2026 15:09:22 +0000
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
To: Andrew Lunn <andrew@lunn.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
 <54c9476c-9f76-4ea1-a73a-c9937d6b463c@lunn.ch>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <54c9476c-9f76-4ea1-a73a-c9937d6b463c@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-11-05 2:43 pm, Andrew Lunn wrote:
>> Yup, and that's true even in the PCI TDISP case - there's a major amount of
>> "communication" and "configuration" involved in that. The principle which
>> should (hopefully) generalise is that a bus/host controller driver can
>> always interrogate its child device to perform whatever attestation and
>> general configuration is appropriate, but we won't hand off any _control_ of
>> that device to a specific device driver (nor enable potentially-impactful
>> bus-level features like DMA, interrupts, etc. if relevant) without the
>> requisite agreement between the bus code and the user.
> 
> Maybe it would be good to list subsystems which the bus driver can
> use, and cannot use.
> 
> You list interrupts as potentially being dangerous.

Nope, "impactful" - as in "things the hardware may do by itself that 
could impact the rest of the system". If it has wired interrupts, it may 
assert them at will as an attempt at some mild DoS or to try to hit some 
kind of known timing condition; if it has MSIs then it can effectively 
attempt to write at least one arbitrary word of data to an arbitrary 
address.

If the bus does happen to provide some way to physically prevent any 
such device-initiated behaviour from propagating until we OK it, then 
that's a nice thing to be able to include in our trust model.
> What about reset
> controllers, GPIOs, regulators? At least in the embedded world, the
> bus driver might need to enable power, set a clock ticking, and take
> the device out of reset via a GPIO, before the device pops into
> existence and will enumerate on the bus.

External resources that a device only _consumes_ should not need to 
factor into the trust of that device itself. If you want to worry from 
the PoV of the device whether _it_ trusts those external providers, that 
would be a whole other can of worms that I for one will run screaming 
from as fast as possible :)

Thanks,
Robin.

> I don't see why interrupts are dangerous, which makes it hard for me
> to determine if GPIOs and clocks, and regulators are also dangerous?
> 
>     Andrew

