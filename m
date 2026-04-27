Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC7C224F3
	for <linux-wireless@vger.kernel.org>; Mon, 27 Apr 2026 07:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777275134; cv=none; b=WH1UnvXgKXjyd4c8WLQ90VK87ZyXVTGuSwzU9lT/13lXhuvTrkxmgFhlCi9c30sw3tgpBgyufE0MskHt0a3KYJL3JRrziwIY/6Eq4/AUYzNvA0ERs+gfIQiWB/7zeb2ChD9qcfeYFqLHqfnP2IHDcTN1YigVw7H4EJTPpHP48AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777275134; c=relaxed/simple;
	bh=kVaI1ZafgW2WNydZcia09F0nn+BL5RHrnw+J2CaICyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DTVCiEGXYPCxAG2EBEqhJd382LKej53y/kTSiHOp+4EdX6PmpMSI4EYQeEqstHaAri5XcP4ktV+4dTRAk+zAbzy0c6MG9/tDwDmHYAsFhXOi2b87HmIpshfKoLQy2EgloXL4nbp8sXlRKQtqDm7tec5cw4sh+5ecZ/M3l+a0hb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=W6f52fL7; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="W6f52fL7"
Received: (wp-smtpd smtp.wp.pl 9701 invoked from network); 27 Apr 2026 09:32:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1777275127; bh=WJweITzsNfw62ui8KsJ4TiW4LtgHPp0pRYntQr7Sujs=;
          h=From:To:Cc:Subject;
          b=W6f52fL71940uDZI4MH7mT+/efYuHfaSOWcTuTF4WjlPJhUorr8bgZA4crOUX8Ehj
           l3BuJqdr1PMIpC5oW7CRPt+ScGWR0HDFo8d0SFx+1Gz7ZVe8fugcsN+aZ3zG8jrHuc
           NAB+/V/g5dVipxuXB84Cguy+USgDIqdDiaJ9I6KETnf3fxA07m8qzvWaLttxz6qCHJ
           Ijc/MmagdEy+OalchkDfkYQBaHzeOjtDXzlvDNnZq0YMfmwW69RO98XOgVqhE6Ev8I
           obcPMIZKmuN6x0x12T7+eIpKG4BSoClONn/Y0fXaXECJiXXATB5JYc+L0orkTeu5bV
           c7lHgG4wgP6Cg==
Received: from 77-236-6-40.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.6.40])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <rosenp@gmail.com>; 27 Apr 2026 09:32:07 +0200
Date: Mon, 27 Apr 2026 09:32:06 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless-next] wifi: rt2x00: check for of_get_mac_address
 error
Message-ID: <20260427073206.GA2096@wp.pl>
References: <20260427051652.954059-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427051652.954059-1-rosenp@gmail.com>
X-WP-MailID: 54ff01ac7828ad9588e18b7f9990f55f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [QeMR]                               

On Sun, Apr 26, 2026 at 10:16:52PM -0700, Rosen Penev wrote:
> is_valid_ether_addr is already a check of of_get_mac_address, in which
> case it returns an error if false. Just set a random MAC on all errors
> except for EPROBE_DEFER.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index 2d778ea5f1b5..51b836343f07 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -991,7 +991,7 @@ int rt2x00lib_set_mac_address(struct rt2x00_dev *rt2x00dev, u8 *eeprom_mac_addr)
>  	if (ret == -EPROBE_DEFER)
>  		return ret;
>  
> -	if (!is_valid_ether_addr(eeprom_mac_addr)) {
> +	if (ret) {
>  		eth_random_addr(eeprom_mac_addr);
>  		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", eeprom_mac_addr);
>  	}
> -- 
> 2.54.0
> 
