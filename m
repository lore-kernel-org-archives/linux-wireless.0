Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54894 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbbA3ALE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 19:11:04 -0500
Date: Fri, 30 Jan 2015 01:10:48 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: clement.perrochaud@effinnov.com
Cc: linux-nfc@lists.01.org,
	=?iso-8859-1?Q?Cl=E9ment?= Perrochaud
	<clement.perrochaud@nxp.com>, sunil.jogi@nxp.com,
	jerome.pele@nxp.com, Charles.Gorand-Effinnov@nxp.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	davem@davemloft.net, grant.likely@linaro.org, lefrique@marvell.com,
	christophe.ricard@gmail.com, cuissard@marvell.com,
	bzhao@marvell.com, hirent@marvell.com, akarwar@marvell.com,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] NFC: nxp-nci: Add support for NXP NCI chips
Message-ID: <20150130001048.GD20998@ribalta.ger.corp.intel.com> (sfid-20150130_011146_637265_B95A4AEC)
References: <1421940460-14049-1-git-send-email-clement.perrochaud@effinnov.com>
 <1421940460-14049-3-git-send-email-clement.perrochaud@effinnov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421940460-14049-3-git-send-email-clement.perrochaud@effinnov.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Clement,

On Thu, Jan 22, 2015 at 04:27:38PM +0100, clement.perrochaud@effinnov.com wrote:
> @@ -686,7 +686,7 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
>  W:	http://blackfin.uclinux.org/
>  S:	Supported
>  F:	sound/soc/blackfin/*
> - 
> +
Unneeded change, please remove it.

> +config NFC_NXP_NCI
> +	tristate "NXP-NCI NFC driver"
> +	depends on NFC_NCI
> +	default n
> +	---help---
> +	  Generic core driver for NXP NCI chips.
It usually is nice to be more specific and describe which chipsets
(e.g. NPC100) this driver supports among all the NXP NCI chipsets.

> +struct nxp_nci_phy_ops {
> +	int (*enable)(void *id);
> +	int (*fw_enable)(void *id);
Wouldn't a int (*enable)(void *id, enum nxp_nci_mode mode); hook be
enough ?

Cheers,
Samuel.
