Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38484 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbcGKPwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 11:52:39 -0400
Subject: NACK: [PATCH] nfp: check idx is -ENOSPC before using it is an index
To: Jakub Kicinski <jakub.kicinski@netronome.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S . Miller" <davem@davemloft.net>,
	Rolf Neugebauer <rolf.neugebauer@netronome.com>,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>,
	oss-drivers@netronome.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <1468252017-14864-1-git-send-email-colin.king@canonical.com>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <5783C0A2.2020405@canonical.com> (sfid-20160711_175259_626646_1380C958)
Date: Mon, 11 Jul 2016 16:52:02 +0100
MIME-Version: 1.0
In-Reply-To: <1468252017-14864-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ignore this, got some other fix included by mistake. Will resend.

On 11/07/16 16:46, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> idx can be returned as -ENOSPC, so we should check for this first
> before using it as an index into nn->vxlan_usecnt[] to avoid an
> out of bounds array offset read.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 +-
>  drivers/nfc/fdp/fdp.c                               | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> index 1e74b91..88678c1 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -2578,7 +2578,7 @@ static void nfp_net_del_vxlan_port(struct net_device *netdev,
>  		return;
>  
>  	idx = nfp_net_find_vxlan_idx(nn, ti->port);
> -	if (!nn->vxlan_usecnt[idx] || idx == -ENOSPC)
> +	if (idx == -ENOSPC || !nn->vxlan_usecnt[idx])
>  		return;
>  
>  	if (!--nn->vxlan_usecnt[idx])
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
>  
> 

