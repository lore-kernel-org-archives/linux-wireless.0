Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793887599;
	b=lupGrf5exaz/r2mWj2BNN54d3sl/6OKz9wjl4KEG1s7AxzXEAAeDNihA20rtiS28H4ji
	 9N4zJIDqR0KYZn0MD4JKRHJP+I8OQrHioXLXFqVRmA8q7hjpOG9KNlAvC6KIcitpAtSWA
	 KYYOXsj9QMJj0Yy7hkGjIN84NQ4aXjBhrxNkSw1DwACEWlKj/UOJKORDBQnFuWiJFoOKH
	 oD9185oje3caGBa5j0MpPDFnD1pjV7ujiKFGb6zFOToUZme87iK9wPk7E+WwseO1vVBMf
	 lgXCgZH9VwPTBBu2/z5tC3zL5pVmitcnkNAYV0VC7z9YkkziwQoYiAwUC8dMM0Xlh2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793887599;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=+bxiPLBqzkOz0GIdUWUmBLaUitvgttuw9ZH2qvbUZkg=;
	b=dQsQO6caXCnHwKlX0zbbRGWZeHpBnErKrKj7q0PCbi9WL3QKhOGHz/CWxeuortFYWOqf
	 ms70B+WjZuEreaNSZXnOwb3yAQ0UWLOIaVXE1zlirvQIjj0/Fpr1BEZHYXV45hWY4PsRz
	 kFji7X9WV18nIu11OBbv9gOkUJmW0QKFItKZAYG9lvBRdXizVnU++4yj3Gy4CTA82yibg
	 BjQ3wsCG2tcoWjAaC4BgWOlBTUOJZESKSc0vTe7za+/d542PT6v/79iX44Pnlrg5lSPwI
	 xz5KXgVecPH03s1GDpDTqipJ2u9i3Ocasg60rkjruDOsnVTLd4YXLNV+IIqB+PLGTQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=RnR9WnLw;
	arc=none smtp.remote-ip=209.85.221.178
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AF8606A328
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 14:06:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02AF8606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=RnR9WnLw
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5eafaeb8684so578915e0c.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 06:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793887593; x=1794492393; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+bxiPLBqzkOz0GIdUWUmBLaUitvgttuw9ZH2qvbUZkg=;
        b=RnR9WnLw6ZCMoaFK9OfD+Z3SyEdhvj+uf0rMG8hHCJ508GqyJ6ANwZoUk4+aGiOUw2
         /BkiFTe3GFbXdlDhgGNTyo1p8KbFcLTeuViDrXT0G8rPqBzVVo12Ao+p4Nr1qmRZcl61
         4eaArBRyBLbC70PWW9D8DSwCjUpFcwxnrtfrVG8awSc3G2DLBl7ue9/tyD5BZlfo0PwR
         zdxT7MPa5WtJxCqrk+LMM1B4PGIKPha9YDx2d3ZgVPNqHnLfPw9K0SbdoIeozyBU6kJV
         fXJaMOJT5b2NTv+4F4NS5Cw1swAwWPhfu1r6zxddYwAc/lzTbX1ed12Z3pRWm4FFq8m7
         OBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793887593; x=1794492393;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+bxiPLBqzkOz0GIdUWUmBLaUitvgttuw9ZH2qvbUZkg=;
        b=SurmgYeiUoHrUka2Q2GD1P7b0gQVjmCpXGEjNQfiuoStso52ad07FTpNQsCbQ+tbJn
         2k8kRTsOS38gZgP4nDwvEGQTNMHOSmI3WBQg8IF0AH3Pm88l46Q2IZoR/mZXkcP2JDpZ
         Ak5q3KHnNP0ky0nU5SW4MBuQvqCAoYlo/H5Juj9H1HvNCgwqCZk+Hi+ITvCAgdUrgAph
         D0yCe8IuPJ6w+tMsK3q1vcVl11hLpF7vmrdUsofBFWH8BlnyG0dMG5/fl559oQeIMRBi
         N3a60OZH1LEcJYhbmimgah8akT2RRL6C9ndIM1fTgF2cv99orYtZgoUvclPToSFg/P6z
         L1oQ==
X-Forwarded-Encrypted: i=1; AKwUvBwx6APLy1YtoIyG+t/nUuZJjaAfN15UzFZhDyTZKmjNTIJO+FAaSj+qUMlvnmN8koiVH6k01UV/vtpkDpxgig==@vger.kernel.org
X-Gm-Message-State: APuU4Z+aB8BAnEog0KLjXw6qpqngJgqfHDixdt/wo8crFNEdlYEWDnlk
	qIXsfRwTF/pJ7GV/BVavWWPv2vaQ1EURYN0egUFpNyN06jqLu6yc5mKgItFvyF0PvMo=
X-Gm-Gg: AYBFou0H2SMb0AbA7SvNAlUZO2qNlsTRBw7ScsPXMchCDSOHz3rJnxhfR5P9zx1a+n8
	j+SKgCu/Sag9n+st4O68MADtl1eZoz8vfDtYT5qh62+z6XLvmR0ZCpDXnobczVUfFHLQ0mi4MQZ
	NdPqImT3r8EdssKcPB6dme5p52S2OOIKcEMsc/iM6ni7LgzaPndkdn8DYtLJygqA5dNv+M3VWq9
	+8XrVIE83XDqZ0Y8R4ImNp8/QeHTqgPK/STngHtCxzM1FavdaU2Ui0KFtZTcf0zmw3fMjWpPrX5
	WbmKSSu0x43btZf8my/S+BegdaV9ax19iLLQcIagMo9H76aCiHjSXwNqKWgHGZZrBobdJRofzNr
	quOxrphMBNGyDXkF2zX+JPCBlqQJaRnh8vmlCUU+0WCjNk8Zom6tR8XgqJ5d/rfLY47cE8alNR8
	Ujz/2oi8aGkCLr6hMDr7861uPd/yLjAen11Ljd3FpAQts/HF/bGh8lTe+Bqj/tvHh6A5Bcxmnmq
	UBLCaIUn433y/4CGW5Bb+bYvROWNS0EHrFJPJSbT91FxILIuo6//hpqgfeBJsufKcBgKQ9re3bF
	MKR6sojR5ScyGrj18bG4Hr4m4loK9tvdr73rik/hjHyaU79+27jDTqkcI32H5rge+fc5fnSlpD0
	6I0ed7SQxqw==
X-Received: by 2002:a05:6122:4f9f:b0:5ea:389c:51fe with SMTP id 71dfb90a1353d-5ec68949c50mr9274698e0c.17.1793887592873;
        Thu, 05 Nov 2026 06:06:32 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d9d62bsm4161881e0c.8.2026.11.05.06.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:06:32 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xOy6p-00000002ezu-00ao;
	Thu, 05 Nov 2026 10:06:31 -0400
Date: Thu, 5 Nov 2026 10:06:30 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Leon Romanovsky <leon@kernel.org>,
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
Subject: Re: [PATCH 10/17] driver core: Expose device trust authorization
 through sysfs
Message-ID: <20261105140630.GG3889730@ziepe.ca>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
 <20261105-device-trust-core-v1-10-1e536825b4eb@nvidia.com>
 <2026110514-bunkhouse-handset-6a3a@gregkh>
 <20261105132729.GB8298@unreal>
 <2026110535-engulf-precut-cf10@gregkh>
 <9d896ebb-6892-4cac-a7c5-41def47f0be0@arm.com>
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
In-Reply-To: <9d896ebb-6892-4cac-a7c5-41def47f0be0@arm.com>

On Thu, Nov 05, 2026 at 01:59:20PM +0000, Robin Murphy wrote:
> Yup, and that's true even in the PCI TDISP case - there's a major amount of
> "communication" and "configuration" involved in that. The principle which
> should (hopefully) generalise is that a bus/host controller driver can
> always interrogate its child device to perform whatever attestation and
> general configuration is appropriate, but we won't hand off any _control_ of
> that device to a specific device driver (nor enable potentially-impactful
> bus-level features like DMA, interrupts, etc. if relevant) without the
> requisite agreement between the bus code and the user.

+1, I think that captures the idea very well.

Jason
