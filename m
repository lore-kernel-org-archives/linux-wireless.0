Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182AbaBUBAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 20:00:50 -0500
Date: Fri, 21 Feb 2014 02:00:44 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] NFC: trf7970a: Add ISO/IEC 15693 Support
Message-ID: <20140221010044.GT18868@zurbaran> (sfid-20140221_020101_015253_7A323164)
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
 <1391206631-9862-3-git-send-email-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391206631-9862-3-git-send-email-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark,

Just one nitpick here:

> +static int trf7970a_is_iso15693_write_or_lock(u8 cmd)
> +{
> +	int ret;
> +
> +	switch (cmd) {
> +	case ISO15693_CMD_WRITE_SINGLE_BLOCK:
> +	case ISO15693_CMD_LOCK_BLOCK:
> +	case ISO15693_CMD_WRITE_MULTIPLE_BLOCK:
> +	case ISO15693_CMD_WRITE_AFI:
> +	case ISO15693_CMD_LOCK_AFI:
> +	case ISO15693_CMD_WRITE_DSFID:
> +	case ISO15693_CMD_LOCK_DSFID:
> +		ret = 1;
return 1;

and return 0 on the default case.
Simpler code and you don't need the ret variable.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
