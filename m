Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB16C4BF946;
	Fri, 25 Sep 2026 15:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349516; cv=none; b=kjJg5vZk8ee9UArzuiZ7LIy4l0wSQheN4SsabGkj9+1TlN8XKzkilTvXXgRCdNqxBom+zbNLOTiUcBavWePEDBoLonlfIkjcVXBNtqq7joX44BurlPEKubICjuIoF04V6ULxCJgDtlp4uWc61hsNmf3Iqaf63E/EtRo70S+G7qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349516; c=relaxed/simple;
	bh=IH8ov+Ny4Yl3CxsDzA5zFMquww5cDFHY9xZ0fLM7iog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j81BpkICWTE6v6EdQttjlT0FkvwB+G9d7Zp1+D/4Eyo8GEluQL0PtesGzwZ9OtkA+qPMRXwiER21KlkTBTcD+AeUyXu/mHldwCOwY/PobJbVMWOdNASfGrsIqBZzlB7T3x8ZfLJTjUojULswTn/qQK1TtV582HE7teHNFBiNAPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTSdc2s1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTSdc2s1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFD11F000FF;
	Fri, 25 Sep 2026 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790349496;
	bh=/Oqj7B1TcaON877H4SXvrAAE63yKPFQybY15jqtw0w0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DTSdc2s1DCtiTNLgefTpjk1yzNz422Yg5tTaQTrljnQGIQr7tHw+IE2y2IXiOvzGc
	 pnJ+ziSlkScuozdyKCRnNfEumWNuppLZYJxVY89fM96yAcF9W32nLhmwRbWMO3h+1g
	 cgTNP9A2JlNrpiVxlW2cUWitmwBRXjaLZpuJW4KX5ctIfbrLWnYSPt/nZzZtrQjgir
	 icic68KAWBT3fh+iYn66MexUD2hkjC1EqsYaod0sDZ1zozJDUkT29ksAUYOwx/Toxb
	 hq1A8yNbcTQK1UWLlIQRhA083X0ZRJHoSkwY0BALIL2H+vkY0rFEJdZBY7DEPekwC1
	 eMWD3ciNo2g9w==
Date: Fri, 25 Sep 2026 17:18:00 +0200
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
Message-ID: <pnt3alevvps5rx2av3r72j6xlky4wlrvzedfs4apnsnpq7cu7x@5begxgw5vsju>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-2-27dd80d841a0@oss.qualcomm.com>
 <a16d507e-17f7-4074-8817-4b8da3a71c3b@oss.qualcomm.com>
 <8ed398ba-2ebe-488a-a213-8ca7ecbe861d@app.fastmail.com>
 <CANyhwx0hZJC6xXaSC2g4GFgUOp5n_KN4tdXksW+s8Mk_+7xEAA@mail.gmail.com>
 <ayyrvpxnxonroz6kafehepplhltnzgopgt6pn5fnpdmft6rbxm@a5sps2dnso47>
 <CANyhwx1EG=2FyBm150wrKpj=kQ1066iwZWndx=ZL3BKNoZUhVA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANyhwx1EG=2FyBm150wrKpj=kQ1066iwZWndx=ZL3BKNoZUhVA@mail.gmail.com>

On Fri, Sep 25, 2026 at 01:46:34PM +0100, Youssef Samir wrote:
> On Thu, Sep 24, 2026 at 4:58 PM Manivannan Sadhasivam <mani@kernel.org> wrote:
> >
> > On Wed, Sep 23, 2026 at 04:03:38PM +0100, Youssef Samir wrote:
> > > On Tue, Sep 22, 2026 at 6:24 PM Juha-Matti Tilli
> > > <juha-matti.tilli@iki.fi> wrote:
> > > >
> > > > On Tue, Sep 22, 2026, at 20:14, Youssef Samir wrote:
> > > > > On 9/21/2026 12:23 PM, Manivannan Sadhasivam via B4 Relay wrote:
> > > > > > +
> > > The chance of collision is slim, but still not impossible.
> >
> > When you mean collision, do you mean node id collision due to bridged nodes?
> > Because, even if the directly connected QAIC devices use 32bit node ids, the
> > collision won't affect the functionality.
> As in ep_nid of one device matching the nid of another device. In MHI,
> that shouldn't
> really matter since this patch moves away from using QRTR_EP_NID_AUTO in node
> assignment, but as you mentioned below, it could clash with TUN and SMD EPs that
> are already registered with their ep_nid.

Ok, this clarifies. But as I mentioned before, there is no current
usecase/requirement to support attaching identical SMD/TUN devices. When the
requirement arises, we can extend this node id assignment scheme to global or
some other method.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
