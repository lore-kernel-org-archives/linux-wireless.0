Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33584 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752651AbdHNXpV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 19:45:21 -0400
Received: by mail-pg0-f53.google.com with SMTP id u5so56575916pgn.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Aug 2017 16:45:21 -0700 (PDT)
Date: Mon, 14 Aug 2017 16:45:18 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 1/3] mwifiex: refactor device dump code to make it
 generic for usb interface
Message-ID: <20170814234517.GA71559@google.com> (sfid-20170815_014525_947772_AFA90BB4)
References: <1502713143-24373-1-git-send-email-huxinming820@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1502713143-24373-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 14, 2017 at 12:19:01PM +0000, Xinming Hu wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> This patch refactor current device dump code to make it generic
> for subsequent implementation on usb interface.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/main.c | 90 +++++++++++++++--------------
>  drivers/net/wireless/marvell/mwifiex/main.h | 11 +++-
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 13 +++--
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 14 +++--
>  4 files changed, 74 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index ee40b73..919d91a 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -1052,9 +1052,26 @@ void mwifiex_multi_chan_resync(struct mwifiex_adapter *adapter)
>  }
>  EXPORT_SYMBOL_GPL(mwifiex_multi_chan_resync);
>  
> -int mwifiex_drv_info_dump(struct mwifiex_adapter *adapter, void **drv_info)
> +void mwifiex_upload_device_dump(unsigned long function_context)

My eyes! It burns!

Most callers don't need the casting, so this looks terribly unsafe.
Please keep the casting to only where it's needed (i.e., in the
timer-related code).

Also, why can't the caller pass in the dump data/len values? You're
making PCIe and SDIO look even uglier, just because you can't figure out
how to wrap this nicely for USB.

You might do better to consider how to make this nicer by implementing
better driver callbacks, and doing most of the work in the core.
Overall, you shouldn't need so many exported symbols.

>  {
> -	void *p;
> +	struct mwifiex_adapter *adapter =
> +		(struct mwifiex_adapter *)function_context;
> +
> +	/* Dump all the memory data into single file, a userspace script will
> +	 * be used to split all the memory data to multiple files
> +	 */
> +	mwifiex_dbg(adapter, MSG,
> +		    "== mwifiex dump information to /sys/class/devcoredump start");
> +	dev_coredumpv(adapter->dev, adapter->devdump_data, adapter->devdump_len,
> +		      GFP_KERNEL);
> +	mwifiex_dbg(adapter, MSG,
> +		    "== mwifiex dump information to /sys/class/devcoredump end");
> +}
> +EXPORT_SYMBOL_GPL(mwifiex_upload_device_dump);
> +
> +void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter)
> +{
> +	char *p;
>  	char drv_version[64];
>  	struct usb_card_rec *cardp;
>  	struct sdio_mmc_card *sdio_card;
> @@ -1062,17 +1079,12 @@ int mwifiex_drv_info_dump(struct mwifiex_adapter *adapter, void **drv_info)
>  	int i, idx;
>  	struct netdev_queue *txq;
>  	struct mwifiex_debug_info *debug_info;
> -	void *drv_info_dump;
>  
>  	mwifiex_dbg(adapter, MSG, "===mwifiex driverinfo dump start===\n");
>  
> -	/* memory allocate here should be free in mwifiex_upload_device_dump*/
> -	drv_info_dump = vzalloc(MWIFIEX_DRV_INFO_SIZE_MAX);
> -
> -	if (!drv_info_dump)
> -		return 0;
> -
> -	p = (char *)(drv_info_dump);
> +	p = adapter->devdump_data;
> +	strcpy(p, "========Start dump driverinfo========\n");
> +	p += strlen("========Start dump driverinfo========\n");
>  	p += sprintf(p, "driver_name = " "\"mwifiex\"\n");
>  
>  	mwifiex_drv_get_driver_version(adapter, drv_version,
> @@ -1156,21 +1168,18 @@ int mwifiex_drv_info_dump(struct mwifiex_adapter *adapter, void **drv_info)
>  		kfree(debug_info);
>  	}
>  
> +	strcpy(p, "\n========End dump========\n");
> +	p += strlen("\n========End dump========\n");
>  	mwifiex_dbg(adapter, MSG, "===mwifiex driverinfo dump end===\n");
> -	*drv_info = drv_info_dump;
> -	return p - drv_info_dump;
> +	adapter->devdump_len = p - adapter->devdump_data;
>  }
>  EXPORT_SYMBOL_GPL(mwifiex_drv_info_dump);
>  
> -void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter, void *drv_info,
> -				int drv_info_size)
> +void mwifiex_prepare_fw_dump_info(struct mwifiex_adapter *adapter)
>  {
> -	u8 idx, *dump_data, *fw_dump_ptr;
> -	u32 dump_len;
> -
> -	dump_len = (strlen("========Start dump driverinfo========\n") +
> -		       drv_info_size +
> -		       strlen("\n========End dump========\n"));
> +	u8 idx;
> +	char *fw_dump_ptr;
> +	u32 dump_len = 0;
>  
>  	for (idx = 0; idx < adapter->num_mem_types; idx++) {
>  		struct memory_type_mapping *entry =
> @@ -1185,24 +1194,24 @@ void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter, void *drv_info,
>  		}
>  	}
>  
> -	dump_data = vzalloc(dump_len + 1);
> -	if (!dump_data)
> -		goto done;
> -
> -	fw_dump_ptr = dump_data;
> +	if (dump_len + 1 + adapter->devdump_len > MWIFIEX_FW_DUMP_SIZE) {
> +		/* Realloc in case buffer overflow */
> +		fw_dump_ptr = vzalloc(dump_len + 1 + adapter->devdump_len);
> +		mwifiex_dbg(adapter, MSG, "Realloc device dump data.");
> +		if (!fw_dump_ptr) {
> +			vfree(adapter->devdump_data);
> +			mwifiex_dbg(adapter, ERROR,
> +				    "vzalloc devdump data failure!\n");
> +			return;
> +		}
>  
> -	/* Dump all the memory data into single file, a userspace script will
> -	 * be used to split all the memory data to multiple files
> -	 */
> -	mwifiex_dbg(adapter, MSG,
> -		    "== mwifiex dump information to /sys/class/devcoredump start");
> +		memmove(fw_dump_ptr, adapter->devdump_data,
> +			adapter->devdump_len);
> +		vfree(adapter->devdump_data);
> +		adapter->devdump_data = fw_dump_ptr;
> +	}
>  
> -	strcpy(fw_dump_ptr, "========Start dump driverinfo========\n");
> -	fw_dump_ptr += strlen("========Start dump driverinfo========\n");
> -	memcpy(fw_dump_ptr, drv_info, drv_info_size);
> -	fw_dump_ptr += drv_info_size;
> -	strcpy(fw_dump_ptr, "\n========End dump========\n");
> -	fw_dump_ptr += strlen("\n========End dump========\n");
> +	fw_dump_ptr = adapter->devdump_data + adapter->devdump_len;
>  
>  	for (idx = 0; idx < adapter->num_mem_types; idx++) {
>  		struct memory_type_mapping *entry =
> @@ -1229,11 +1238,8 @@ void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter, void *drv_info,
>  	/* device dump data will be free in device coredump release function
>  	 * after 5 min
>  	 */
> -	dev_coredumpv(adapter->dev, dump_data, dump_len, GFP_KERNEL);
> -	mwifiex_dbg(adapter, MSG,
> -		    "== mwifiex dump information to /sys/class/devcoredump end");
> +	adapter->devdump_len = fw_dump_ptr - adapter->devdump_data;
>  
> -done:
>  	for (idx = 0; idx < adapter->num_mem_types; idx++) {
>  		struct memory_type_mapping *entry =
>  			&adapter->mem_type_mapping_tbl[idx];
> @@ -1242,10 +1248,8 @@ void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter, void *drv_info,
>  		entry->mem_ptr = NULL;
>  		entry->mem_size = 0;
>  	}
> -
> -	vfree(drv_info);
>  }
> -EXPORT_SYMBOL_GPL(mwifiex_upload_device_dump);
> +EXPORT_SYMBOL_GPL(mwifiex_prepare_fw_dump_info);
>  
>  /*
>   * CFG802.11 network device handler for statistics retrieval.
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> index 0aaae08..e308b8a 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.h
> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> @@ -94,6 +94,8 @@ enum {
>  
>  #define MAX_EVENT_SIZE                  2048
>  
> +#define MWIFIEX_FW_DUMP_SIZE       (2 * 1024 * 1024)
> +
>  #define ARP_FILTER_MAX_BUF_SIZE         68
>  
>  #define MWIFIEX_KEY_BUFFER_SIZE			16
> @@ -1033,6 +1035,9 @@ struct mwifiex_adapter {
>  	bool wake_by_wifi;
>  	/* Aggregation parameters*/
>  	struct bus_aggr_params bus_aggr;
> +	/* Device dump data/length */
> +	char *devdump_data;

Should be 'void *'.

> +	int devdump_len;

I really really don't like you sticking yet another transient piece of
data here. IIUC, you're just admitting that (after the first dump)
you're going to waste 2MB+ of memory forever? Please try harder than
that.

>  };
>  
>  void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
> @@ -1654,9 +1659,9 @@ void mwifiex_hist_data_add(struct mwifiex_private *priv,
>  u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
>  			    u8 rx_rate, u8 ht_info);
>  
> -int mwifiex_drv_info_dump(struct mwifiex_adapter *adapter, void **drv_info);
> -void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter, void *drv_info,
> -				int drv_info_size);
> +void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter);
> +void mwifiex_prepare_fw_dump_info(struct mwifiex_adapter *adapter);
> +void mwifiex_upload_device_dump(unsigned long function_context);
>  void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags);
>  void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
>  int mwifiex_get_wakeup_reason(struct mwifiex_private *priv, u16 action,
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index cd31494..dbc5944 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -2769,12 +2769,17 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
>  
>  static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
>  {
> -	int drv_info_size;
> -	void *drv_info;
> +	adapter->devdump_data = vzalloc(MWIFIEX_FW_DUMP_SIZE);
> +	if (!adapter->devdump_data) {
> +		mwifiex_dbg(adapter, ERROR,
> +			    "vzalloc devdump data failure!\n");
> +		return;
> +	}
>  
> -	drv_info_size = mwifiex_drv_info_dump(adapter, &drv_info);
> +	mwifiex_drv_info_dump(adapter);
>  	mwifiex_pcie_fw_dump(adapter);
> -	mwifiex_upload_device_dump(adapter, drv_info, drv_info_size);
> +	mwifiex_prepare_fw_dump_info(adapter);
> +	mwifiex_upload_device_dump((unsigned long)adapter);

How did you manage to make 4 separate function calls into 5 separate
function calls and 1 memory allocation? I'm pretty sure you're going the
wrong direction on this refactoring.

Brian

>  }
>  
>  static void mwifiex_pcie_card_reset_work(struct mwifiex_adapter *adapter)
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index fd5183c..8010109 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -2505,15 +2505,21 @@ static void mwifiex_sdio_generic_fw_dump(struct mwifiex_adapter *adapter)
>  static void mwifiex_sdio_device_dump_work(struct mwifiex_adapter *adapter)
>  {
>  	struct sdio_mmc_card *card = adapter->card;
> -	int drv_info_size;
> -	void *drv_info;
>  
> -	drv_info_size = mwifiex_drv_info_dump(adapter, &drv_info);
> +	adapter->devdump_data = vzalloc(MWIFIEX_FW_DUMP_SIZE);
> +	if (!adapter->devdump_data) {
> +		mwifiex_dbg(adapter, ERROR,
> +			    "vzalloc devdump data failure!\n");
> +		return;
> +	}
> +
> +	mwifiex_drv_info_dump(adapter);
>  	if (card->fw_dump_enh)
>  		mwifiex_sdio_generic_fw_dump(adapter);
>  	else
>  		mwifiex_sdio_fw_dump(adapter);
> -	mwifiex_upload_device_dump(adapter, drv_info, drv_info_size);
> +	mwifiex_prepare_fw_dump_info(adapter);
> +	mwifiex_upload_device_dump((unsigned long)adapter);
>  }
>  
>  static void mwifiex_sdio_work(struct work_struct *work)
> -- 
> 1.9.1
> 
