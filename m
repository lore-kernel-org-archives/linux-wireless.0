Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8AF3F3288;
	Mon,  5 Oct 2026 10:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791197659; cv=none; b=RISnlF7nTLfl72O7e9n5lSQM02os/4kNdmeIUF3NTuiEt647zUdLexlMKGNoEWfJKMUEKoAmiiLlceRiQrQbxDfxR7yxxZCK62xGZbcBE1zcY7a//0uIRtfwcRvFjMUfZuHbJ0Ku6bawdU5aWwd27jpByYX183m6ldg4lY/Zl58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791197659; c=relaxed/simple;
	bh=+//hYyvLY1DidjCEU7sxZkNJSTLyKSvxNh9bpxViUGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KYr/yGobK/1YM6JccUB/RWCyRm7wARXvittU3wCIcB3frWEZ0uVm6e4c/2erAr0QrpMbzRTjHSp5RIXuynGW/L8jhYys67LF5nBo1FsRLNW2vpZRrZNF0FSiJoCKuO7u7l7IcZ/d/fPDCfR+VbYLe5vEjpWkv80riEeWaqXt2I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4tsBxty; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4tsBxty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D521F000FF;
	Mon,  5 Oct 2026 10:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791197658;
	bh=DlXqLXFJuHkMFPT6bbBQ261SgyEfBKQ0u4A57YX9D4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G4tsBxty14TiYT6Cr3osmdiah0awyE/VYsFVuIPBUMYijujZdUrEpdIaScW1GPEYQ
	 ZMJpbydKmXjDV51XWuC+Iwyf6IX98abRcoEveFxaT/lRI0ILxvZ/U8lZdKnNXfI1bf
	 UN3znBTaepyZhZ4CwH9bQKR5e+St1XsMgoFPF+LUbUKyYNQyCTHdWZOpsj98akUuhy
	 j2h879gzDUAOMR7cmKIGAqx/8CVh78DrpiRdJenEPNSkge0UgbqUiof6GxfecUnK+H
	 YQjerSx8t9DsBDGFS1bV2rXj9a8w+kGIp1piK7jD2zGx8cjeOvPIunkuMqir5oqB+W
	 bjNIvYCTnEFDg==
Date: Mon, 5 Oct 2026 12:54:14 +0200
From: Nathan Chancellor <nathan@kernel.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com
Subject: Re: -Wconstant-conversion in
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
Message-ID: <20261005105414.GA1018014@ax162>
References: <20260916064454.GA3635613@ax162>
 <1a107d87260.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <1a107e21b08.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a107e21b08.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>

On Sun, Oct 04, 2026 at 07:07:01PM +0200, Arend van Spriel wrote:
> Op 16 september 2026 08:45:59 schreef Nathan Chancellor <nathan@kernel.org>:
> 
> > Hi Arend,
> > 
> > After [1] landed in clang main, I am seeing the following warning
> > (turned error with CONFIG_WERROR=y / W=e):
> > 
> > drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:224:18:
> > error: implicit conversion from 'int' to 's8' (aka 'signed char')
> > changes value from 128 to -128 [-Werror,-Wconstant-conversion]
> > 224 |         {0, 0, 0, 0, 0, 128},
> > |         ~               ^~~
> > 
> > As far as I can tell, this has been present since the original commit
> > that added brcm80211 to the tree
> > 
> > a9533e7ea3c4 ("Staging: Add initial release of brcm80211 - Broadcom
> > 802.11n wireless LAN driver.")
> > 
> > based on my reading of drivers/staging/brcm80211/phy/wlc_phy_n.c. Should
> > this final value be changed to -128 or should there be some other fix?
> 
> To be honest I don't know. If I looked at the proprietary driver code that
> table entry is still there with exactly the same values. So to be type
> correct while preserving the same value it should be -128. However, looking
> at the table entry struct it is an index so that sounds odd.

Thanks a lot for the input! I sent a patch to change it to -128 to clear
up the warning since it will be the same bit representation and
presumably things are working properly with that:

  https://lore.kernel.org/20260916064454.GA3635613@ax162/

-- 
Cheers,
Nathan
