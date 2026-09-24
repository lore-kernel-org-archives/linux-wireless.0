Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B60E4A5EA8;
	Thu, 24 Sep 2026 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265519; cv=none; b=FR//zakYSlNtrTVHKeRlkYi48eUbP6bRT77hHXqLn6ZcFQQ2h0pzG+aK7ThwPsffUCYcprUE+C2LzTsmyGF7bpTvgcR2sU9+w+iVfueS76YAcxjNMIM+oYxSDVMaIZHgrxczloZtE0/8aD7AJwdgrMtl4hkS4xKt12YX06lBqP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265519; c=relaxed/simple;
	bh=YHn8oI1G1NSH7wZ6dpgnFVvrOA9GqBQ7HoSldOqR6MQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/4hcW57eZXuJDT2fN4u02rMNdRiMi2LToe+732A/Z52nqcTVAz93eO/nyHKx54h18Vg49LARlI9f7hsoZO3uWYyhkmiBhCV3Ghrwq8P86C5XtEHsQY28VTgpjTQrL3bxqKNN/LDX3aJEwkOtUQMGoJs5mrrIBVBpNX8gcD8TjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IuWWk/eh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IuWWk/eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30C51F000FF;
	Thu, 24 Sep 2026 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790265517;
	bh=ntCPRNmhHP0xEpdWDgj6ZKP31wN/fxbhz+6bG3Gb24k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IuWWk/ehkegX/ttgIRCu0DLztu+mvo32r6PgEGd9HryTT44P3aBcJxQPfSvfVY1XA
	 O4QRPNnGtQNEDb5nlxrbDmMFN240bWTyPmrY+xYGQ7+SPGRuKhqk2hgInQPV0aqMsM
	 S7NKZk+t7prFPLguTH2qrdOTYx+xxwPPbaTwFu9TpnQnjI/D2/cPpIBTci0jtORbPw
	 B70lWjPeN9I2drRegbZS9zEjSRnduMjfHz07hOCcirqwayUBsPh/ilDwDeS9LqVv7C
	 MzREzUOg0b06utFzXw50TGVLFw38rqFXOs46EIQdVfy9MmZzwPuvDbTE/mDiW1Tgzo
	 vpG8LaduoGTeQ==
Date: Thu, 24 Sep 2026 17:58:17 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Cc: Juha-Matti Tilli <juha-matti.tilli@iki.fi>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>, 
	Chris Lew <christopher.lew@oss.qualcomm.com>, Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
	Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: Re: [PATCH v2 2/4] net: qrtr: Assign unique node id for MHI endpoints
Message-ID: <ayyrvpxnxonroz6kafehepplhltnzgopgt6pn5fnpdmft6rbxm@a5sps2dnso47>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-2-27dd80d841a0@oss.qualcomm.com>
 <a16d507e-17f7-4074-8817-4b8da3a71c3b@oss.qualcomm.com>
 <8ed398ba-2ebe-488a-a213-8ca7ecbe861d@app.fastmail.com>
 <CANyhwx0hZJC6xXaSC2g4GFgUOp5n_KN4tdXksW+s8Mk_+7xEAA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANyhwx0hZJC6xXaSC2g4GFgUOp5n_KN4tdXksW+s8Mk_+7xEAA@mail.gmail.com>

On Wed, Sep 23, 2026 at 04:03:38PM +0100, Youssef Samir wrote:
> On Tue, Sep 22, 2026 at 6:24 PM Juha-Matti Tilli
> <juha-matti.tilli@iki.fi> wrote:
> >
> > On Tue, Sep 22, 2026, at 20:14, Youssef Samir wrote:
> > > On 9/21/2026 12:23 PM, Manivannan Sadhasivam via B4 Relay wrote:
> > > > +
> > > > +/* The offset is chosen carefully to not collide with the node ids allocated by
> > > > + * the remote nodes. All the remote nodes use node ids in range 0 to 0xffff.
> > > This assumption does not hold up for QRTR V1 headers where the node ids are 32bit.
> > > QAIC devices use BHI_SERIALNUM as the node ID, and it is definitely larger than
> > > 0xFFFF.> + */
> >
> > Does that mean we have to go back to my endpoint id patchset?  It's an
> > option, but a quite complex one.
> I'm not sure. Last time I tested the endpoint ID series was its v5 and it was
> functionally acceptable, and other than switching to sendmsg(2) instead of
> send(2) and sendto(2), it did not require much changing on the user-space
> side. But as you mentioned, it was/is complex compared to this one.
> >
> > However, what is the likelihood that serial number would clash with
> > these host node id values? Maybe just adjusting the comment could be
> > acceptable.
> The chance of collision is slim, but still not impossible.

When you mean collision, do you mean node id collision due to bridged nodes?
Because, even if the directly connected QAIC devices use 32bit node ids, the
collision won't affect the functionality.

Also, there is a collision with SMD and TUN endpoints, but that's out of scope
for this series.

> I think a solution would be to treat qrtr_host_node_id(idx) as the
> preferred id, not
> the one that will actually be assigned to the node. And before
> assigning the nid,
> we check it against the radix tree, and if it exists, we try to probe
> the next available
> id (so an IDA). This will also require exposing the nid to the user in
> sysfs (i.e. /sys/bus/mhi/devices/mhix/mhix_IPCR/nid).
> 

I guess the QAIC userspace tooling needs the allocated node id. This can be
added.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
