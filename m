Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbbCZAaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 20:30:05 -0400
Date: Thu, 26 Mar 2015 01:29:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Robert Dolca <robert.dolca@intel.com>
Cc: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5/8] NFC: NCI: Don't call setup if previous NCI request
 failed
Message-ID: <20150326002956.GD10954@ribalta.home> (sfid-20150326_013035_283264_00BF31B5)
References: <1424772112-27399-1-git-send-email-robert.dolca@intel.com>
 <1424772112-27399-6-git-send-email-robert.dolca@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424772112-27399-6-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Robert,

On Tue, Feb 24, 2015 at 12:01:49PM +0200, Robert Dolca wrote:
> If the previous nci_request (NCI reset) failed the setup function
> was being called anyway. It shouldn't be called if the reset failed.
> 
> The result of the setup function is taken into consideration. If it
> fails the init should fail.
> 
> Signed-off-by: Robert Dolca <robert.dolca@intel.com>
> ---
>  net/nfc/nci/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
> index 1a449ac..d2e7adf 100644
> --- a/net/nfc/nci/core.c
> +++ b/net/nfc/nci/core.c
> @@ -365,8 +365,8 @@ static int nci_open_device(struct nci_dev *ndev)
>  	rc = __nci_request(ndev, nci_reset_req, 0,
>  			   msecs_to_jiffies(NCI_RESET_TIMEOUT));
>  
> -	if (ndev->ops->setup)
> -		ndev->ops->setup(ndev);
> +	if (!rc && ndev->ops->setup)
> +		rc = ndev->ops->setup(ndev);
That one makes sense.

Cheers,
Samuel.
