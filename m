Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E3F2EB84E;
	Fri, 31 Jul 2026 13:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505876; cv=none; b=Yy34pVqJngEoXio2R7nRnUq+JxVlY344lwaA18ed3pHDpcae/LdlgyLgku+ZmayBQ0hKPif8O6RJwd8PrIYAeqk60enWiZFKlU/J/iXkdi2eqXpRg0VJiMSmOewejPndBgPmpFLY83emMykn5LO7XI53uq0Uwt66UZVvhFqG0k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505876; c=relaxed/simple;
	bh=85HMa1urLda3H4SQPW9fwOAUmAEVpJSRJQ/BJG+jc48=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MC5V8uQURPgkhs08O+SR0u5/K0HAFwzdGcl3thsDW8PUUv0pPQWhB7/vDkJfGPVX7fCrz6qxnLYxpN4/ABegPxUgaHaaKLjzkxtN64fJbClOi7sEtVXHaD0kKarhIpbSOHW31qdYg82fjW714oprToU2vNmwtjBvfuJ/TKKhz0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=Pg7oTqYB; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="Pg7oTqYB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1785505874; x=1817041874;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=85HMa1urLda3H4SQPW9fwOAUmAEVpJSRJQ/BJG+jc48=;
  b=Pg7oTqYBhak1Bf4blb7s+VHLw6Lqfu9S2Q18tuSO9kG5C7cXuLTAz2JT
   Cn7VNraBIpcpu0ZSnQTY3QWVIFGnml9r7mQBfVy4aeW1vsTYgniCK0mYa
   k+1rBP644UCZ/ah6T3/l9w2yeiRh8+Wck8ZJS6mkmflUAK3vqSOdrVX4g
   M=;
X-CSE-ConnectionGUID: pjTlxk6kTnG+t57lGJdSnQ==
X-CSE-MsgGUID: QYQxC+awQ966qSjpJ5goBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="154010874"
X-IronPort-AV: E=Sophos;i="6.25,196,1779141600"; 
   d="scan'208";a="154010874"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 15:51:06 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 31 Jul
 2026 15:51:05 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 31 Jul 2026 15:51:02 +0200
Date: Fri, 31 Jul 2026 13:50:53 +0000
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
CC: Arend van Spriel <arend.vanspriel@broadcom.com>,
	<linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>,
	<wlan-kernel-dev-list@infineon.com>
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external
 SAE AP
Message-ID: <fn7xsi3b5k6bshyueeybjdb4vzudsdwt6arjn3swj3lszew5nv@v5xtmaxhslbm>
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
 <5cf57b2d-2bcc-481c-87bf-3a034d5f99be@broadcom.com>
 <CA+ORkNQntwC4k2arcngGdYB3mwsbJCkCRNTJRJ2GoRxjdGXLzA@mail.gmail.com>
 <c452116c-6215-4d62-b96b-72ae23a478e1@broadcom.com>
 <CA+ORkNSsb8Z5eUVH1GRvWtO_he6A+_b67ov2Cm6VJuWciJeKZQ@mail.gmail.com>
 <CA+ORkNSG45LrTu09AiHNwTZ882Yybq-3E-=enwe+2eA36fEO4g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+ORkNSG45LrTu09AiHNwTZ882Yybq-3E-=enwe+2eA36fEO4g@mail.gmail.com>
X-ClientProxiedBy: MUCSE802.infineon.com (172.23.29.28) To
 MUCSE827.infineon.com (172.23.29.20)

On 07/29, Bogdan Nicolae wrote:
> Gokul,
> 
> Looks like this is also missing, can you please add it in your patch:

sure, we will include the quoted patch while submitting our "extsae_pwe" patchset
for community review.

Kindly avoid top-posting while sending your email replies.
Need to use interleaved quoting.
https://en.wikipedia.org/wiki/Posting_style#Interleaved_style

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index d32b35ce0..455f5619f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -77,6 +77,11 @@
> 
> #define        DOT11_BCN_PRB_FIXED_LEN         12      /* beacon/probe
> fixed length */
> 
> +#define WL_IOV_OP_BSSCFG_DISABLE               0
> +#define WL_IOV_OP_BSSCFG_ENABLE                        1
> +#define WL_IOV_OP_MANUAL_STA_BSSCFG_CREATE     2
> +#define WL_IOV_OP_MANUAL_AP_BSSCFG_CREATE      3
> +
> #define BRCMF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS   320
> #define BRCMF_SCAN_JOIN_PASSIVE_DWELL_TIME_MS  400
> #define BRCMF_SCAN_JOIN_PROBE_INTERVAL_MS      20
> @@ -5260,6 +5265,19 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy,
> struct net_device *ndev,
>                if ((brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS)) && (!mbss))
>                        brcmf_fil_iovar_int_set(ifp, "mbss", 1);
> 
> +               if (!test_bit(BRCMF_VIF_STATUS_AP_CREATED,
> &ifp->vif->sme_state)) {
> +                       bss_enable.bsscfgidx = cpu_to_le32(ifp->bsscfgidx);
> +                       bss_enable.enable =
> +                               cpu_to_le32(WL_IOV_OP_MANUAL_AP_BSSCFG_CREATE);
> +                       err = brcmf_fil_iovar_data_set(ifp, "bss", &bss_enable,
> +                                                      sizeof(bss_enable));
> +                       if (err < 0) {
> +                               bphy_err(drvr, "bss_enable config failed %d\n",
> +                                        err);
> +                               goto exit;
> +                       }
> +               }
> +
>                err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 1);
>                if (err < 0) {
>                        bphy_err(drvr, "setting AP mode failed %d\n",
> 
> Thanks,
> Bogdan
> 
> On Wed, Jul 29, 2026 at 8:19 AM Bogdan Nicolae <bogdan.nicolae@gmail.com> wrote:
> >
> > Gokul,
> >
> > Great to hear. Are there any other changes you are planning to submit?
> > I found this to be the minimal working config at least for WPA3 personal,
> > but would like to know if I am missing anything else.

Could you help us with the exact version of 43455 firmware, Raspbian distro and
kernel that you are currently using in your RPi ? 

Regards,
Gokul
