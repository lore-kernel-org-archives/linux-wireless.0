Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37052 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbbLTRuk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 12:50:40 -0500
Date: Sun, 20 Dec 2015 18:50:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Saurabh Sengar <saurabh.truth@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] NFC: added the sysfs entry for nfcsim workqueue
 delay
Message-ID: <20151220175036.GA3938@zurbaran.home> (sfid-20151220_185100_123390_015DADC8)
References: <1449993875-3872-1-git-send-email-saurabh.truth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449993875-3872-1-git-send-email-saurabh.truth@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Saurabh,

On Sun, Dec 13, 2015 at 01:34:35PM +0530, Saurabh Sengar wrote:
> added the sysfs entry for nfcsim workqueue delay, as tx_delay
> 
> Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>
> ---
> In case this TODO is not expected to be done, please let me know.
> I wonder after my repeated attempts since last 50 days, I am not able to get a single response.
Apologies for the delay.


> Resending this patch in hope to get some response this time.
> 
>  drivers/nfc/nfcsim.c | 38 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
> index 26ac9e5..e77be35 100644
> --- a/drivers/nfc/nfcsim.c
> +++ b/drivers/nfc/nfcsim.c
> @@ -32,6 +32,8 @@
>  #define NFCSIM_POLL_TARGET	2
>  #define NFCSIM_POLL_DUAL	(NFCSIM_POLL_INITIATOR | NFCSIM_POLL_TARGET)
>  
> +#define TX_DEFAULT_DELAY	5
> +
>  struct nfcsim {
>  	struct nfc_dev *nfc_dev;
>  
> @@ -62,12 +64,41 @@ static struct nfcsim *dev1;
>  
>  static struct workqueue_struct *wq;
>  
> +
> +static int tx_delay = TX_DEFAULT_DELAY;
2 things:

- This actually defines an rx delay as it delays the start of the
  receiving workqueue, so the name should be tx_*. I'm being picky here,
  because with this special driver an Rx delay is implicitely a Tx
  one.
- I'd prefer this to be tunable by device, so it should be defined as an
  additional field in the nfcsim structure (rx_delay ?) and set by default
  to RX_DEFAULT_DELAY from nfcsim_init_dev.

Cheers,
Samuel.
