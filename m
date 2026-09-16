Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81296369D4A;
	Wed, 16 Sep 2026 06:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541099; cv=none; b=m5oTQBO4/RdshYUarPw67tuzg5Q4p0aXoW4VE/gOfwlGwXdNlyy04w7NkdHiMNL5HG/RML3ci4CP/S87kW8jP2P5o4YbQ7XPOdxOp/DWaayQgiff8m2DvZ8euwEKnI0LrLMWrPY2bZquC0J9/WM3CdPM74Eio/t1zatXkadHdP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541099; c=relaxed/simple;
	bh=xyKHrPrM3E1TLZPiLZR2KI0zu6dOOgOPDDDiFvCWNj4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=L8lNL/jXhlSDHW1po0Vkjy+a3oD+uH33SWLKAH/2pJv2EnPqJMfa30hzDRrkqRg5CbM2T3e5nktUrKFrYSuapkTXZsuA9+f6fHJXdBUvY6j2ZphgkKuYTmKF48dxl5Po0dhlFNiHKHgqmg2MMnCDl7IIvkLs0WCYVtu2G/VnvYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DD1fI4Js; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DD1fI4Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAF61F00898;
	Wed, 16 Sep 2026 06:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789541098;
	bh=ofm3x8EXEeMhTeJNsoZLbkp3mXtc6PQaLuhTfDxjCsk=;
	h=Date:From:To:Cc:Subject;
	b=DD1fI4Js+dNwuAh8T0HhLAyBPagTfatNxxqIU2Z75SBSk0SRxgSjSsMQ2X4Uc1HLD
	 JoJwUI6zQmBn8e7iWPvQOZgKGe1KBoCmBgzOwAX3WPYIA2vDrpyBcLJlK+ul+kr/G3
	 cCzFtuBZo2lNIYsjVLVIVDCiFmVo/ef4gXRStQa7rsSKy1xfXi2+WgXQke1G84nROo
	 rjuplSjUx8sCrigEo2uprkzhoHyl2QIF9K7fYsAWCQAoTlKnm/9Lk5HubXNSPz85PZ
	 LjicLJ3pn1sUgAVTuRWDLa622z/wMmamhrPMoEgsVneF5xomoYxwHRK10QvOlpk4FF
	 bG5r0abn95Iug==
Date: Tue, 15 Sep 2026 23:44:54 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com
Subject: -Wconstant-conversion in
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
Message-ID: <20260916064454.GA3635613@ax162>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Arend,

After [1] landed in clang main, I am seeing the following warning
(turned error with CONFIG_WERROR=y / W=e):

  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:224:18: error: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 128 to -128 [-Werror,-Wconstant-conversion]
    224 |         {0, 0, 0, 0, 0, 128},
        |         ~               ^~~

As far as I can tell, this has been present since the original commit
that added brcm80211 to the tree

  a9533e7ea3c4 ("Staging: Add initial release of brcm80211 - Broadcom 802.11n wireless LAN driver.")

based on my reading of drivers/staging/brcm80211/phy/wlc_phy_n.c. Should
this final value be changed to -128 or should there be some other fix?

[1]: https://github.com/llvm/llvm-project/commit/a5ef934a8d295dc03be3960f2b3744ec2e53238e

-- 
Cheers,
Nathan
