Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEB13E024F;
	Tue, 25 Aug 2026 14:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787667212; cv=none; b=EzsrUfw8JUOgpLVhhdLLmlXCmKayi+ughgcLBhnW2SNVsZouUOeGN3U59H1oIllPNu0uk8p+C6jN3wp+jTI1RkGJo29WN8qTpQyrEFpdfngrEvATvYx39vuQxbNt+hRx44jla4Lqm2SWt0H/00iU8PCiPzk4S+hbNKZi55WKcKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787667212; c=relaxed/simple;
	bh=tVi1RCyBjgehOdyclChALtMgn3QTqorqQ2TpHHcopPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=up8RvB7dtF+RONqnqDygeHBVTmUUfvxM+QSkA3gYo9/2vt6JD6yCcU+GURxZhhnd4YiwMKAtUwDkhudx3tAL+I2SicWngMkUpdIMYT8k+J0XN6iMd1iId+MO1ivucvYRXXgaXl1W/J5sM3eBTl41A04HmSKBug91GASuG5SHwq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQXwwnU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQXwwnU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF451F000E9;
	Tue, 25 Aug 2026 14:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787667211;
	bh=wz893wKOaGqOR5UmcHbx6usEKUUChPSx/5FquRPNT3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PQXwwnU9C38AkVhxl9Q3SkN4nZmpV1zrHvvt4izFXHITYcPFRkDAXrsRQu3GbeWCR
	 ieMYRi1qECbLNZHkhzy2ygCAIdWuj9c7MIK3C9y02eZHE0XbrdR8pE0z9YuCJMp53D
	 vBzAwzbqAV4dwZ69MdEBSOYAetQ0y0vOXm8pBDp7hkdeEH2tQ1SYhMT2vF5T13vN3k
	 +CSrA9QQQWd9Nj9BDJRNn3Qxp98HXYmFYU8lXV7VoecJhXdD/PCZuQCALUM6rRsn2l
	 WVueeGxzvKKCut0GAKgtR5Pn8GXfBAv0NNCo1iB9wauQlDPX5PWbz2p0PVdXHP0EEj
	 ZE4djtdli2YQA==
Received: from johan by xi.lan with local (Exim 4.99.4)
	(envelope-from <johan@kernel.org>)
	id 1wyru5-000000023a5-0ku2;
	Tue, 25 Aug 2026 16:13:29 +0200
Date: Tue, 25 Aug 2026 16:13:29 +0200
From: Johan Hovold <johan@kernel.org>
To: Yang Zi <2959243019@qq.com>
Cc: johannes.berg@intel.com, kees@kernel.org,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: libertas_tf: Fix slab-out-of-bounds write in
 if_usb_send_fw_pkt()
Message-ID: <ao2jCeAOxdzy-UNk@hovoldconsulting.com>
References: <tencent_E7F524BBDD4B458C2FD4C1DBE86C7C062105@qq.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_E7F524BBDD4B458C2FD4C1DBE86C7C062105@qq.com>

On Tue, Aug 25, 2026 at 05:24:06PM +0800, Yang Zi wrote:
> if_usb_send_fw_pkt() copies a firmware block into the driver's
> ep_out_buf using the length taken directly from the firmware header
> (fwdata->hdr.datalength) without any validation.  That same untrusted
> value is also used as the USB transfer length and to advance
> cardp->totalbytes.
> 
> A crafted or truncated firmware image can set datalength to a huge value,
> which makes the memcpy() into fwdata->data write far past the end of the
> 1574-byte ep_out_buf (KASAN reports a ~3.5 GiB slab-out-of-bounds write)
> and, once totalbytes has run away, makes the subsequent header memcpy()
> read past the end of the firmware image.
> 
> check_fwfile_format() only checks the cumulative length and never bounds
> an individual block, and FW_MAX_DATA_BLK_SIZE (600) is never used.
> 
> Validate the block length in if_usb_send_fw_pkt(): reject any block whose
> datalength exceeds FW_MAX_DATA_BLK_SIZE or the number of bytes remaining
> in the firmware image, and return -EINVAL before the memcpy().  Also
> enforce the per-block upper bound in check_fwfile_format() so that
> invalid images are rejected up front.
> 
> Signed-off-by: Yang Zi <2959243019@qq.com>

Missing Assisted-by tag here too?

This patch is also corrupt and cannot be applied.

Johan
