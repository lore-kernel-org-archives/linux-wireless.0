Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72E0427A0C;
	Fri, 10 Jul 2026 13:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689207; cv=none; b=rn9nRMzREaI8G1zKoYqKNU8X+UxkLyO58bvSD204C5K9vleJ9flaPBrkncUn8GworUVCUq0MIaQB1v2/XsxLt8CJd8p0Ftx0WHxQRPTAFCl8kgynY4LEUIhFHD73+LeJFz8uebE7Velv5vTsNTuSzICZJN2ouE488KPzpMcFKa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689207; c=relaxed/simple;
	bh=p1bnpcFfnpdahpit40SU+9PazJc1JIbRsqyAx4sUOSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bkBf1usQrRtXry4o8n/wywSK4po7Vhffw7/lCT+jDA9jVlfHxPH+Pk+UDqlgSNZuWRHYNVGgvCmScqG/amc8hP1rvNWCP0gXTpOOAUfwTkm6jbOsYo7f/cx10htMvdA3vn1w8SGsw3L+2Sq6vl79hf2kF3vIq9QP578CzdpNKmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlKt/KjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlKt/KjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A711F000E9;
	Fri, 10 Jul 2026 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783689205;
	bh=8SLwz8zRlgf02FS4auN5eAQ0f4RlgvLdBmLBFfMqDFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nlKt/KjWCqP4c+C1+WH5rd8CkluQch0VqzrinYyLBmwlPFCMEdw+BnIVan6HWIa1A
	 DELXpWp9EoHAz0Of2oUqda5i/Q4LoEVjOoqbvTIUX1590WLXrSkB+e+O/8p03gWz4x
	 /H9L2z0mq2X/sRX1ItwQEncZk+mb0b1caOp6pGos=
Date: Fri, 10 Jul 2026 15:13:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Gary Guo <gary@garyguo.net>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
	Johan Hovold <johan@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Petko Manolov <petkan@nucleusys.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Chas Williams <3chas3@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	driver-core@lists.linux.dev, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org,
	Manuel Ebner <manuelebner@mailbox.org>
Subject: Re: [PATCH v2 0/7] usb: fix UAF related to dynamic ID
Message-ID: <2026071051-finishing-denial-d652@gregkh>
References: <20260707-usb_dyn_id_uaf-v2-0-632dcf3adfba@garyguo.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707-usb_dyn_id_uaf-v2-0-632dcf3adfba@garyguo.net>

On Tue, Jul 07, 2026 at 01:26:39PM +0100, Gary Guo wrote:
> This is the USB version of the dynamic ID UAF fix similar to that of PCI
> [1]. usb_match_dynamic_id returns a pointer to field of usb_dynid, which
> can be freed when dynamic ID is removed via sysfs. It can be triggered with
> the following sequence:
> 
>     echo <vid> <pid> > /sys/bus/usb/drivers/<name>/new_id
>     <probe start>
>     echo <vid> <pid> > /sys/bus/usb/drivers/<name>/remove_id
>     <probe use ID>
> 
> Fix it by making a stack copy of the ID. This does mean that the lifetime
> of ID is scoped to probe (which is already the case but never spelled out
> explicitly). Drivers use these device IDs creatively, so this series also
> fix these drivers.
> 
> The following coccinelle script is used to find all cases that are deemed
> suspicious. Only useful case for IDs should be access its fields, or
> forwarding (without type cast) to functions that do so.
> 
> @usage@
> identifier fn, id;
> position p;
> @@
>   fn(..., struct usb_device_id *id, ...)
>   {
>     ...
>     id@p
>     ...
>   }
> 
> // Due to cocci isomorphism this needs to be explicit
> @bad@
> identifier fn, id;
> type T;
> position usage.p;
> @@
>   fn(..., struct usb_device_id *id, ...)
>   {
>     ...
>     (T*)id@p
>     ...
>   }
> 
> // Good use cases
> @good@
> identifier fn, id, fld;
> expression E;
> position usage.p;
> @@
>   fn(..., struct usb_device_id *id, ...)
>   {
>     ...
> (
>     id@p->fld
> |
>     E(..., id@p, ...)
> |
> // Redundant checks, but ignore
>     !id@p
> |
> // Redundant checks, but ignore
>     id ? ... : ...
> )
>     ...
>   }
> 
> @script:python depends on usage && (bad || !good)@
> p << usage.p;
> @@
> coccilib.report.print_report(p[0], "suspicious use of device ID")
> 
> There're 3 drivers that store usb_device_id, and they're converted to just
> use driver_info instead. The other fields of usb_device_id can be easily
> retrieved from usb_device via descriptor.id{Vendor,Product}.
> 
> There're also a few users that rely on pointer arithmetics. Pegaus and
> xusbatm are converted to use driver_info. All unusal USB mass storage
> drivers rely on pointer arithemtic to index into a side table, because USB
> storage subsystem is using the driver_data for flags. Luckily all these
> drivers set no_dynamic_id. Ideally these could be fixed too but their
> maintainers probably have a better idea of how.
> 
> Link: https://lore.kernel.org/driver-core/20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net [1]
> 
> Signed-off-by: Gary Guo <gary@garyguo.net>

Thanks for these.  I had an old patch series that attempted to do some
locking in this area to fix this up, but this version is much nicer.
I'll go queue it up now.

greg k-h
