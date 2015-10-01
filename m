Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54779 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbbJAOax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 10:30:53 -0400
Subject: Re: [PATCH v2] ath9k: feeding entropy in kernel from ADC capture
To: miaoqing@codeaurora.org, linville@tuxdriver.com
References: <1443582568-1216-1-git-send-email-miaoqing@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, lkp@intel.com
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <560D4392.4060107@openwrt.org> (sfid-20151001_163056_733969_CC0CEC93)
Date: Thu, 1 Oct 2015 16:30:42 +0200
MIME-Version: 1.0
In-Reply-To: <1443582568-1216-1-git-send-email-miaoqing@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-09-30 05:09, miaoqing@codeaurora.org wrote:
> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> This patch is derived from
> commit 6301566e0b2d ("ath9k: export HW random number generator"),
> 
> We evaluated the entropy of the ADC data on QCA9531, QCA9561, QCA955x,
> and AR9340, and it has sufficient quality random data (at least 10 bits
> and up to 22 bits of min-entropy for a 32-bit value). We conservatively
> assume the min-entropy is 10 bits out of 32 bits. Thus, ATH9K_RNG_BUF_SIZE
> is set to 320 (u32) i.e., 1.25 kilobytes of data is inserted to fill up
> the pool as soon as the entropy counter becomes 896/4096 (set by random.c).
> Since ADC was not designed to be a dedicated HW RNG, we do not want to bind
> it to /dev/hwrng framework directly. This patch feeds the entropy directly
> from the WiFi driver to the input pool. The ADC register output is only
> used as a seed for the Linux entropy pool. No conditioning is needed,
> since all the conditioning is performed by the pool itself.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath9k/Kconfig  |  11 ++++
>  drivers/net/wireless/ath/ath9k/Makefile |   1 +
>  drivers/net/wireless/ath/ath9k/ath9k.h  |  22 +++++++
>  drivers/net/wireless/ath/ath9k/main.c   |   4 ++
>  drivers/net/wireless/ath/ath9k/rng.c    | 106 ++++++++++++++++++++++++++++++++
>  5 files changed, 144 insertions(+)
>  create mode 100644 drivers/net/wireless/ath/ath9k/rng.c
> 

> diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
> new file mode 100644
> index 0000000..93a7485
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> [...]
> +static int ath9k_rng_kthread(void *data)
> +{
> +	int bytes_read;
> +	struct ath_softc *sc = data;
> +	u32 *rng_buf;
> +
> +	rng_buf = kmalloc_array(ATH9K_RNG_BUF_SIZE, sizeof(u32), GFP_KERNEL);
> +	if (!rng_buf)
> +		goto out;
> +
> +	while (!kthread_should_stop()) {
> +		bytes_read = ath9k_rng_data_read(sc, rng_buf,
> +						 ATH9K_RNG_BUF_SIZE);
> +		if (!bytes_read) {
> +			msleep_interruptible(10);
> +			continue;
> +		}
> +
> +		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
> +					   ATH9K_RNG_ENTROPY(bytes_read));
Polling every 10 milliseconds seems a bit excessive to me. Think about
all those useless wakeups per second that this will produce on battery
powered devices.
How about polling more data without sleeping when the thread starts, and
then afterwards only poll once every few seconds?

- Felix
