Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46319 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbcGKQAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 12:00:09 -0400
Date: Mon, 11 Jul 2016 17:59:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Colin King <colin.king@canonical.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"David S . Miller" <davem@davemloft.net>,
	Rolf Neugebauer <rolf.neugebauer@netronome.com>,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>,
	oss-drivers@netronome.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nfp: check idx is -ENOSPC before using it is an index
Message-ID: <20160711155959.GA16111@zurbaran.home> (sfid-20160711_180021_740393_2FF48DB3)
References: <1468252017-14864-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468252017-14864-1-git-send-email-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Colin,

On Mon, Jul 11, 2016 at 04:46:57PM +0100, Colin King wrote:
> diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
> index e44a7a2..d93d314 100644
> --- a/drivers/nfc/fdp/fdp.c
> +++ b/drivers/nfc/fdp/fdp.c
> @@ -345,7 +345,7 @@ static void fdp_nci_release_firmware(struct nci_dev *ndev)
>  
>  	if (info->ram_patch) {
>  		release_firmware(info->ram_patch);
> -		info->otp_patch = NULL;
> +		info->ram_patch = NULL;
>  	}
>  }
This chunk is unrelated and also already applied to my nfc-next tree.

Cheers,
Samuel.
