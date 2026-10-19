Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ADF3F0749
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792419238; cv=none; b=j6D82PTBzj8XrlDitRjSh5dG3PSUGp3mbjeOv8cB+aM6hnROEafBpERfgUWpAhsN9PG2sm7FVEylLphAItPeM5ppLjI/n0OaMtiqU30E82nghp2vLDvxb/fSx+m4k4AWc7wv/dVScYPwzrfdVqbn93hdr4hUO9on6Eg7pV9QtZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792419238; c=relaxed/simple;
	bh=f3nM9/wpYUDajKbunoxaoJWS4hjZkoK/T70Qgz1xgcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvJLWZKfkDxTrahZabhczb1F3KCiIL0uibl2ddsMZUiTv8CvlbIqMMxuJRnyIOPGhrCRJ0FN3kMgGUr5fivgl9USnNaiB3kw9eHpn5Xh3BEqlnms7po6MMa15+F28phIeytN79xp5L1w8/1wyYE53lJBit+6Bt97OLIHn0yrikU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=fryzmNSt; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="fryzmNSt"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 3B1DA1FC13;
	Mon, 19 Oct 2026 16:13:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1792419231;
	bh=7uaanhLXAytiaWC8vQPynOWgjs506wcLhc2ZDaxmaFg=; h=From:To:Subject;
	b=fryzmNSt98BRKfAzrvPDfY0qe2iwIfydY7dbQU+z9w2ivPVyqBjKMspuADPfg+gtm
	 cJE0j1/GwOUP41qOMnQCZxOv/y4vxUC6eZlSbYZ+/YBtAJSK2T0rHOMFmRLIQ/KlM+
	 RT7Fm0XnhCQl+Dfxbz6SqgOO+vPdL3/E5VTePjxDeXdHCICjOq6Fwpc1oWMYltcpkH
	 f2QMeFtqQ5JXmvgmU/+D+33FMbUBiAmJRL0FQIdf4pKLkloWVBBhstT2gM/UxoZi0Z
	 amPbDyjj2lCaVjL3ITfIOL1V56tITJZYOFK+It7U9uXrdWTnuqdO8v+gm45bPrgZ/d
	 m1Syh5PAbX+VQ==
Date: Mon, 19 Oct 2026 16:13:47 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: jeff.chen_1@oss.nxp.com
Cc: linux-wireless@vger.kernel.org, briannorris@chromium.org,
	johannes@sipsolutions.net, francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: Re: [PATCH wireless-next v2 1/2] wifi: mwifiex: append hotfix number
 to firmware version string
Message-ID: <20261019141347.GA118352@francesco-nb>
References: <20261012123624.3147417-1-jeff.chen_1@oss.nxp.com>
 <20261012123624.3147417-2-jeff.chen_1@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012123624.3147417-2-jeff.chen_1@oss.nxp.com>

Hello Jeff,
thanks for the patch

On Mon, Oct 12, 2026 at 08:36:23PM +0800, jeff.chen_1@oss.nxp.com wrote:
> From: Jeff Chen <jeff.chen_1@nxp.com>
> 
> mwifiex_ret_get_hw_spec() parses and logs the FW_HOTFIX_VER_ID TLV,
> but the hotfix value is not stored in the adapter structure. As a
> result, the hotfix number never appears in the firmware version string
> returned by mwifiex_drv_get_driver_version().
> 
> Store the hotfix version from FW_HOTFIX_VER_ID and append it to the
> firmware version string.
> 
> Assisted-by: LLM sparse
> Fixes: 7715d79553de ("wifi: mwifiex: Support firmware hotfix version in GET_HW_SPEC responses")
> Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c    | 10 ++++++++--
>  drivers/net/wireless/marvell/mwifiex/fw.h        |  6 ++++++
>  drivers/net/wireless/marvell/mwifiex/init.c      |  1 +
>  drivers/net/wireless/marvell/mwifiex/main.h      |  1 +
>  drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |  3 ++-
>  5 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> index 29e0f274575e..268a795db486 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> @@ -1594,11 +1594,17 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
>  						    api_rev->major_ver,
>  						    api_rev->minor_ver);
>  					break;
> -				case FW_HOTFIX_VER_ID:
> +				case FW_HOTFIX_VER_ID: {
> +					struct hw_spec_fw_hotfix_ver *hf;

All the other cases in the switch declare the variable at top.
I would do the same for consistency here.

> +
> +					hf = (void *)tlv;

I would not abuse the void*, you know the type you want

 hf = (struct hw_spec_fw_hotfix_ver *)tlv 

	
> +	adapter->fw_hotfix_ver = 0;

With this change we will always report `0` as the hotfix version, even
when nothing is provided by the fw. Is this generally ok? I assume so,
asking just to have an explicit confirmation.

Francesco
