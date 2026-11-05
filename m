Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793887440;
	b=HYPJANUjN7/Z7md8W908sa3uVXYSzBxteKDt0Iny1i8Rsdh5hlB/Dp21YeaOp992q7/j
	 kGF1OO5dYR39M7/Fy787AOD75W6zoGpYd1xtoFRD9jjhnJ2vZWi5Un2hga9voBbcVlHJi
	 GWwdG7Ungvb99H98mIntedPEH4nlZx/+PSWYMvdKoloftdIZ/JGOvKnsBf2XVrKxIpLJ9
	 Iz7TMOUWN4huUse2mGknVw126BtQferRCqNvZ8PezXfUmaPHSC5PRzp+IEUQ5uXxR7uLn
	 J5S5duivtinUpQgeg7ZpQKA4XzLuDouISvWsJGK8iGsUXzpVq1V4XzNCoI0wfu7xKaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793887440;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=aHvVt/C+p86HW0thhKORyrpJuSX9G1Rk+ExvThy6OxA=;
	b=ScVv7Lt8DZbIozZUHbaBDVqZxUpJ+VZZZu5qIyVH9PoKC+VuB61M8XW9GctfB/yL9I4K
	 OEMWNXlD5uP7bPZK4NbYiJpFjtGoBCsKW6/lIx5ZcCHJ6LpGcFfITSlDwZU4DdGYpMTHz
	 agt+ZK/eMuNCTnHGmrrsVdBKnSY5pf/SiuHO1KTkIY5i6PQGWTA5amFTG6tTpT43xfe+w
	 PZ/n8vCw7VN+sFnQf/R2NOm7k0oKyQh6OlgLur/iiioQZYg3/XisliJH2foGn4QtyCMr3
	 cXoxyGfclwml2skNQkKemB8KJXgyPgqITXZlGFnCPHFeA2rOpLyxAIU7uV1/YPz1Xgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	arc=none smtp.remote-ip=209.85.221.171
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64945606D80D
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 14:03:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64945606D80D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5eabf7d5bbeso682810e0c.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 06:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793887434; x=1794492234; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aHvVt/C+p86HW0thhKORyrpJuSX9G1Rk+ExvThy6OxA=;
        b=kz1XgIBbrvBVV82jfLwzl2boDjAIVUbeNVQas9Wo1Dk5Xdi6H+C3KcpCevzEdclNJ0
         lzsSeS+uRFo6w/gIJIYGLA5nYX/ZA7GDEfg8ye+MEqBYoDAQ+XWmrXIScd3vjjxi3P0s
         TM9V8bmM9C1gt69mu+eIyGDX/aC+cI4xa87K7AUD6ZNwyr7bJjPSJ34eRy3oL+DhO4T4
         z9GIW8q+b2I5fYq6rzeAUUwY6D1cOnVfqLouPYFCQGVgJUGlc0n72Hhgr3e5/i+LRsW4
         Jqs+IOHbUmP6UlpI+ifiIR6Yqw/evL4R0NFbQH8ocPPe+5gcxWg4oty37gZrialLDEod
         LNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793887434; x=1794492234;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aHvVt/C+p86HW0thhKORyrpJuSX9G1Rk+ExvThy6OxA=;
        b=RiaNhZFSj8ITY8Sp/+VjSCTkocicNa621kPACmmm41iU6Q8ykaX3g5uKMig0vd4Z5t
         qG5HV3nJ9OTMKHWmvyO6Efp9kF7u+H1cY7TpxJYMAF22vuzf3QXFXp+BQBpHaDT0aPo3
         7NX5lDhV2nLtraB23gdrktjp9L0QfL0zJrUsqAqBHhzge5ICTUDwZhfGqQzpZL/805sj
         E/a8I/X8DthPOClyt7oQ2OIjWSP1ZBmxuitTCeU6jAU82iZfdJrYeijB8s1kVVk46YnB
         mDjy1jhwcToqn9Ok9GQwoWIbGltR3lci+yU4Cg4RZlYN/pRYKDBj/l6s1oaWkLkzXir6
         WcJA==
X-Forwarded-Encrypted: i=1; AKwUvBxQ1nObImQozwOLQayxm+2kymKgQZXKc4+8bkLlQ53IQ1BjOeFeg6BMXjvcynH2xJBffDqSptCFMLnPjtUVLQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+mziHmVFGYGd6G04nwQZ2mEn0snbMq3be3n675cT2BHLySK154
	dwLC9mPV3IefbageOQwEIwdLb9kY60KDskgTZVnN3O0bR32leq/UX5Fee/iJ+iXa7IY=
X-Gm-Gg: AYBFou0V3e7jnNFnKB7KsoGudWfP6zg8V/uAyW+HgBJ/JkLCHiuqyc8pYPZsqX7eV2R
	0CON5s3b6q3spxiHLngso/mqHKsymISeJQ6u8KWoQSoN86lulKuMWKkPKhle7PdKlBslw9Pn/a6
	m86oJRh1L6t+X8DTxMODYiqDu4mWFqGCQmRaYJXNqzm9F9JPB/dnTsB6a6K97rA4zw7DEDf28eU
	mxKjrZAGhLYJHUs+o92mXa1MozaioqezpvZMa3QCAjzE0IOkcFtbi3xI+gmaNvYojQjpPErUbmz
	rB8Q/GA2hbyjvMhD1ygcX8Br3dN4TpyztyTd1AnFJDnRDtHTXoNszFedQE97kLWnGA8sOMYQ8Ig
	EFJKiIoBuc2yccPDeTrI5Fh9VhJrAq0YuWMO0iOtCcQ3MvKPwIxb9Smr8yVhwENnG9yatOirkFP
	YQxkwT7rxNkOiEGdZdGaVmzBJtVVDuQiCTXnRLmpZld4nDT1/2S54+gpuBPri58bQkT+JSsR5Iz
	1kKIjqhn2NocLWlil6fFbBWx8BpYbtZwo76TEBhFtTOTd3FSvkT81YZC2a/fwwiw6N53fGIyg2W
	6C1XbhXeKN+RFrAbAGy9/6gKqP5WPvKWji5U3e1D3IrL4NxcfwMXwtNjCvZ++VBbyY8SxAUTbpO
	U5FoYAWtByA==
X-Received: by 2002:a05:6122:8f88:b0:5ea:cfd9:8fbd with SMTP id 71dfb90a1353d-5ec689b0f30mr9760208e0c.17.1793887433885;
        Thu, 05 Nov 2026 06:03:53 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8de4908sm4235128e0c.15.2026.11.05.06.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:03:53 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xOy4G-00000002ecj-0pCb;
	Thu, 05 Nov 2026 10:03:52 -0400
Date: Thu, 5 Nov 2026 10:03:52 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Johan Hovold <johan@kernel.org>, Eric Dumazet <edumazet@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
	linux-input@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH 17/17] PCI: Replace untrusted state with device trust
Message-ID: <20261105140352.GF3889730@ziepe.ca>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-17-1e536825b4eb@nvidia.com>
 <2026110526-aerobics-correct-4c06@gregkh>
 <20261105131856.GA8298@unreal>
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
In-Reply-To: <20261105131856.GA8298@unreal>

On Thu, Nov 05, 2026 at 03:18:56PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 05, 2026 at 08:12:51AM -0500, Greg Kroah-Hartman wrote:
> > On Thu, Nov 05, 2026 at 01:42:30PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Convert the PCI specific untrusted to use the common device trust
> > > level. Adversarial means the same thing untrusted does.
> > 
> > What about for USB?  Will that "move" to use this common trust level?
> > If not, I don't think it's very "common" :)
> 
> It supposed to work for all buses out-of-the box, at least this is the
> intention.

You mean DISABLED/FULL should work with this patch series on USB
right? Meaning the core code will not bind a USB driver when DISABLED?

I was wondering if some of the broader things we are doing on PCIe
also apply to USB, like device authentication. I don't know alot about
USB, but I got AI to help me find some relavent spec information.

 https://usb.org/authentication

This looks like the parallel to PCIe SPDM device authentication. I
would expect it to work broadly the same way as PCIe if anyone wanted
to implement it:

1) USB discovery discovers authentication support and creates an
   attestation subsystem device for it
2) The struct device starts up with trust = DISABLED
3) Userspace runs the crypto flow through attestation subsystem. This
   is extremely similar looking to PCIe SPDM:
    1. GET_DIGESTS -> device returns a hash for each certificate chain
       slot it has.
    2. GET_CERTIFICATE -> device returns its certificate chain, read
       in pieces.
    3. CHALLENGE (nonce) -> device returns CHALLENGE_AUTH: the chain
       hash, a salt, a hash of its descriptors, and a signature over the
       challenge and the response.
4) Userspace inspects the above and approves the device
5) trust = FULL, driver is probed.

But I supposed Greg is asking about /sys/bus/usb/devices/DEVICE/authorized ..

Jason
