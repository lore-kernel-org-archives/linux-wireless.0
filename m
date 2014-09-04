Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:57329 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbaIDD4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 23:56:24 -0400
Date: Thu, 4 Sep 2014 13:47:58 +1000
From: James Cameron <quozl@laptop.org>
To: Avinash Patil <patila@marvell.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	akarwar@marvell.com, huxm@marvell.com, yangyang@marvell.com,
	cluo@marvell.com, maithili@marvell.com
Subject: Re: [PATCH 17/17] mwifiex: add rx workqueue support
Message-ID: <20140904034758.GZ27002@us.netrek.org> (sfid-20140904_055628_023425_59ADB44E)
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
 <1409576345-13717-18-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409576345-13717-18-git-send-email-patila@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 01, 2014 at 06:29:05PM +0530, Avinash Patil wrote:
> This patch adds RX work queue support to mwifiex.
> Packets received are queued to internal queue which are then
> processed by scheduling a work item for RX process.
> 
> RX work is enabled only on SMP systems.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Marc Yang <yangyang@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/11n_rxreorder.c | 14 ++++
>  drivers/net/wireless/mwifiex/init.c          | 19 ++++++
>  drivers/net/wireless/mwifiex/main.c          | 95 ++++++++++++++++++++++++++++
>  drivers/net/wireless/mwifiex/main.h          | 14 ++++
>  drivers/net/wireless/mwifiex/pcie.c          | 12 +++-
>  drivers/net/wireless/mwifiex/sdio.c          | 11 +++-
>  6 files changed, 163 insertions(+), 2 deletions(-)
> 
> [...]
> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
> index fb38d81..2ed59a0 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> [...]
> @@ -784,6 +858,15 @@ mwifiex_add_card(void *card, struct semaphore *sem,
>  	adapter->cmd_wait_q.status = 0;
>  	adapter->scan_wait_q_woken = false;
>  
> +	if (num_possible_cpus() > 1) {
> +		adapter->rx_work_enabled = true;
> +		pr_debug("info: %s rx work enabled, cpus %d :\n", __func__,
> +			 num_possible_cpus());
> +		/*to ensure this is seen in dmesg logs*/
> +		pr_err("info: %s rx work enabled, cpus %d :\n", __func__,
> +		       num_possible_cpus());

Either pr_debug or pr_err, but not both.

(Would love to test, but stuck on 3.5, and don't know how to
backport mwifiex.)

-- 
James Cameron
http://quozl.linux.org.au/
