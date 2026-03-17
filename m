Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA193346763;
	Tue, 17 Mar 2026 09:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773738466; cv=none; b=iQ+400AvAsxW2kD10K/mwpFvKmfqRrKFfbk3URfkaVU7j08apA6moxB3ZnEf6c9RpVO3M3VFvaleCnxEAbzn1eL9c+SaNQChR909b7P41jGlzuFV8yv9yNmMP3DG0wupZirgUKe2WtK2T1VZWzeEJjom7Cr9IsP3jqHHrUgQlvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773738466; c=relaxed/simple;
	bh=ZrKKE8ny7s5IpYiTG6uvqZyrDNosiYUjWstBwT2fgd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTylScv++DcFLynCltMZFPR4xJvLN1+4niBnCpGDHuFEDuYCI1gfCDPhj6VPMPPApSZVEAj+ACOaRlF1wbkNXQpx8faydmEM2OMluTgyy7oNHAVgCeYnqyFazevPxn7H6zB8yoVBgVpoKaujgsDd+KG5OgohNuLnkBkckJXuPdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndPpBm00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndPpBm00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4788EC4CEF7;
	Tue, 17 Mar 2026 09:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773738466;
	bh=ZrKKE8ny7s5IpYiTG6uvqZyrDNosiYUjWstBwT2fgd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ndPpBm00/1/NTma8rKwc9SM+YUkIDM0gVjUwn4PhvzD64ijd6S+3FlDMvccFEaGsd
	 wPVJkOxEaZGVGAslWLDul+t387VwYV4TMxw1IUnTv9wN2LdTNrt9df+llf0Sm14dSD
	 7heb3H/0QH3ZjEdlPFaIPKHnoEdkhZgT31fVlZoc=
Date: Tue, 17 Mar 2026 10:07:41 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Cc: Jakub Kicinski <kuba@kernel.org>, konradybcio@kernel.org,
	andersson@kernel.org, linux-kernel@vger.kernel.org,
	Alex Elder <elder@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Wesley Cheng <quic_wcheng@quicinc.com>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	ath11k@lists.infradead.org, ath12k@lists.infradead.org,
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-sound@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Use the QMI service IDs from the QMI header
Message-ID: <2026031717-ethanol-zoning-80b5@gregkh>
References: <20260316171419.2619620-1-daniel.lezcano@oss.qualcomm.com>
 <20260316172251.2d57d0aa@kernel.org>
 <8757aec7-8c36-446a-9a34-f0717f64202a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8757aec7-8c36-446a-9a34-f0717f64202a@oss.qualcomm.com>

On Tue, Mar 17, 2026 at 09:51:32AM +0100, Daniel Lezcano wrote:
> On 3/17/26 01:22, Jakub Kicinski wrote:
> > On Mon, 16 Mar 2026 18:14:10 +0100 Daniel Lezcano wrote:
> > > This series is based on the immutable branch [1] containing the QMI
> > > service id definitions along with some drivers using them.
> > > 
> > > How a patch can be merged ?
> > 
> > Wait for the dependency to appear in respective trees after the merge
> > window then repost the patches individually. I'm starting to get
> > annoyed with all this cross-tree QMI/MHI noise.
> 
> An ack is simpler for everyone, especially when they are trivial

Why isn't this 4 different patches, all for different branches/trees as
there does not seem to be any dependencies here?

confused,

greg k-h
