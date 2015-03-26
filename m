Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39196 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbbCZA3e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 20:29:34 -0400
Date: Thu, 26 Mar 2015 01:29:25 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Robert Dolca <robert.dolca@intel.com>
Cc: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/8] NFC: NCI: Allow connection close with dev down
Message-ID: <20150326002925.GA10954@ribalta.home> (sfid-20150326_012939_355874_ABB9BB2F)
References: <1424772112-27399-1-git-send-email-robert.dolca@intel.com>
 <1424772112-27399-2-git-send-email-robert.dolca@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424772112-27399-2-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Robert,

On Tue, Feb 24, 2015 at 12:01:45PM +0200, Robert Dolca wrote:
> By calling __nci_request instead of nci_request allows the driver to use
> the function while initializing the device (setup stage)
> 
> Signed-off-by: Robert Dolca <robert.dolca@intel.com>
> ---
>  net/nfc/nci/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
> index 9575a18..c4dd5d8 100644
> --- a/net/nfc/nci/core.c
> +++ b/net/nfc/nci/core.c
> @@ -558,7 +558,7 @@ static void nci_core_conn_close_req(struct nci_dev *ndev, unsigned long opt)
>  
>  int nci_core_conn_close(struct nci_dev *ndev, u8 conn_id)
>  {
> -	return nci_request(ndev, nci_core_conn_close_req, conn_id,
> +	return __nci_request(ndev, nci_core_conn_close_req, conn_id,
>  				msecs_to_jiffies(NCI_CMD_TIMEOUT));
You're fixing your problem by removing the NCI request serialization and
removing the check for your device being UP.
I assume you need to open and close a proprietary connection from your
setup hook ? Then please extend nci_request() to check for both NCI_UP
and NCI_INIT.

Cheers,
Samuel.
