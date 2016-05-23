Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46515 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbcEWGWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2016 02:22:55 -0400
Date: Mon, 23 May 2016 11:52:11 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath10k: add QCA9887 chipset support
Message-ID: <20160523062211.GA7825@atheros-ThinkPad-T61> (sfid-20160523_082317_873249_149BA188)
References: <1568876.Six5hABE57@bentobox>
 <1463755272-12912-1-git-send-email-sven.eckelmann@open-mesh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463755272-12912-1-git-send-email-sven.eckelmann@open-mesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sven,

On Fri, May 20, 2016 at 04:41:11PM +0200, Sven Eckelmann wrote:
> Add the hardware name, revision, firmware names and update the pci_id
> table.
> 
> QA9887 HW1.0 is supposed to be similar to QCA988X HW2.0 . Details about
> he firmware interface are currently unknown.
> 
> Signed-off-by: Sven Eckelmann <sven.eckelmann@open-mesh.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c      | 20 ++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/hw.h        | 10 ++++++++++
>  drivers/net/wireless/ath/ath10k/pci.c       | 20 ++++++++++++++++++--
>  drivers/net/wireless/ath/ath10k/targaddrs.h |  3 +++
>  4 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 49af624..0f4a4f6 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -69,6 +69,25 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>  		},
>  	},
>  	{
> +		.id = QCA9887_HW_1_0_VERSION,
> +		.dev_id = QCA9887_1_0_DEVICE_ID,
> +		.name = "qca9887 hw1.0",
> +		.patch_load_addr = QCA9887_HW_1_0_PATCH_LOAD_ADDR,
> +		.uart_pin = 7,
> +		.has_shifted_cc_wraparound = true,
> +		.otp_exe_param = 0,
> +		.channel_counters_freq_hz = 88000,
> +		.max_probe_resp_desc_thres = 0,
> +		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_AFTER,
> +		.cal_data_len = 2116,

[shafi] i think we can re-use QCA988X_CAL_DATA_LEN instead of a new h/w param

> +		.fw = {
> +			.dir = QCA9887_HW_1_0_FW_DIR,
> +			.board = QCA9887_HW_1_0_BOARD_DATA_FILE,
> +			.board_size = QCA9887_BOARD_DATA_SZ,
> +			.board_ext_size = QCA9887_BOARD_EXT_DATA_SZ,
> +		},
> +	},
> +	{
>  		.id = QCA6174_HW_2_1_VERSION,
>  		.dev_id = QCA6164_2_1_DEVICE_ID,
>  		.name = "qca6164 hw2.1",
> @@ -2062,6 +2081,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
>  
>  	switch (hw_rev) {
>  	case ATH10K_HW_QCA988X:
> +	case ATH10K_HW_QCA9887:
>  		ar->regs = &qca988x_regs;
>  		ar->hw_values = &qca988x_values;
>  		break;
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index aedd898..9108831 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -27,6 +27,7 @@
>  #define QCA6174_2_1_DEVICE_ID   (0x003e)
>  #define QCA99X0_2_0_DEVICE_ID   (0x0040)
>  #define QCA9377_1_0_DEVICE_ID   (0x0042)
> +#define QCA9887_1_0_DEVICE_ID   (0x0050)
>  
>  /* QCA988X 1.0 definitions (unsupported) */
>  #define QCA988X_HW_1_0_CHIP_ID_REV	0x0
> @@ -38,6 +39,13 @@
>  #define QCA988X_HW_2_0_BOARD_DATA_FILE	"board.bin"
>  #define QCA988X_HW_2_0_PATCH_LOAD_ADDR	0x1234
>  
> +/* QCA9887 1.0 definitions */
> +#define QCA9887_HW_1_0_VERSION		0x4100016d
> +#define QCA9887_HW_1_0_CHIP_ID_REV	0
> +#define QCA9887_HW_1_0_FW_DIR		ATH10K_FW_DIR "/QCA9887/hw1.0"
> +#define QCA9887_HW_1_0_BOARD_DATA_FILE	"board.bin"
> +#define QCA9887_HW_1_0_PATCH_LOAD_ADDR	0x1234
> +
>  /* QCA6174 target BMI version signatures */
>  #define QCA6174_HW_1_0_VERSION		0x05000000
>  #define QCA6174_HW_1_1_VERSION		0x05000001
> @@ -195,6 +203,7 @@ enum ath10k_hw_rev {
>  	ATH10K_HW_QCA99X0,
>  	ATH10K_HW_QCA9377,
>  	ATH10K_HW_QCA4019,
> +	ATH10K_HW_QCA9887,
>  };
>  
>  struct ath10k_hw_regs {
> @@ -247,6 +256,7 @@ void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
>  				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev);
>  
>  #define QCA_REV_988X(ar) ((ar)->hw_rev == ATH10K_HW_QCA988X)
> +#define QCA_REV_9887(ar) ((ar)->hw_rev == ATH10K_HW_QCA9887)
>  #define QCA_REV_6174(ar) ((ar)->hw_rev == ATH10K_HW_QCA6174)
>  #define QCA_REV_99X0(ar) ((ar)->hw_rev == ATH10K_HW_QCA99X0)
>  #define QCA_REV_9377(ar) ((ar)->hw_rev == ATH10K_HW_QCA9377)
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 8133d7b..b799f46 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -57,6 +57,7 @@ static const struct pci_device_id ath10k_pci_id_table[] = {
>  	{ PCI_VDEVICE(ATHEROS, QCA6174_2_1_DEVICE_ID) }, /* PCI-E QCA6174 V2.1 */
>  	{ PCI_VDEVICE(ATHEROS, QCA99X0_2_0_DEVICE_ID) }, /* PCI-E QCA99X0 V2 */
>  	{ PCI_VDEVICE(ATHEROS, QCA9377_1_0_DEVICE_ID) }, /* PCI-E QCA9377 V1 */
> +	{ PCI_VDEVICE(ATHEROS, QCA9887_1_0_DEVICE_ID) }, /* PCI-E QCA9887 */
>  	{0}
>  };
>  
> @@ -83,6 +84,8 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
>  
>  	{ QCA9377_1_0_DEVICE_ID, QCA9377_HW_1_0_CHIP_ID_REV },
>  	{ QCA9377_1_0_DEVICE_ID, QCA9377_HW_1_1_CHIP_ID_REV },
> +
> +	{ QCA9887_1_0_DEVICE_ID, QCA9887_HW_1_0_CHIP_ID_REV },
>  };
>  
>  static void ath10k_pci_buffer_cleanup(struct ath10k *ar);
> @@ -837,6 +840,7 @@ static u32 ath10k_pci_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
>  
>  	switch (ar->hw_rev) {
>  	case ATH10K_HW_QCA988X:
> +	case ATH10K_HW_QCA9887:
>  	case ATH10K_HW_QCA6174:
>  	case ATH10K_HW_QCA9377:
>  		val = (ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
> @@ -1560,6 +1564,7 @@ static void ath10k_pci_irq_msi_fw_mask(struct ath10k *ar)
>  
>  	switch (ar->hw_rev) {
>  	case ATH10K_HW_QCA988X:
> +	case ATH10K_HW_QCA9887:
>  	case ATH10K_HW_QCA6174:
>  	case ATH10K_HW_QCA9377:
>  		val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
> @@ -1583,6 +1588,7 @@ static void ath10k_pci_irq_msi_fw_unmask(struct ath10k *ar)
>  
>  	switch (ar->hw_rev) {
>  	case ATH10K_HW_QCA988X:
> +	case ATH10K_HW_QCA9887:
>  	case ATH10K_HW_QCA6174:
>  	case ATH10K_HW_QCA9377:
>  		val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
> @@ -1932,6 +1938,7 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
>  	switch (ar_pci->pdev->device) {
>  	case QCA988X_2_0_DEVICE_ID:
>  	case QCA99X0_2_0_DEVICE_ID:
> +	case QCA9887_1_0_DEVICE_ID:
>  		return 1;
>  	case QCA6164_2_1_DEVICE_ID:
>  	case QCA6174_2_1_DEVICE_ID:
> @@ -2295,7 +2302,7 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
>  
>  static int ath10k_pci_safe_chip_reset(struct ath10k *ar)
>  {
> -	if (QCA_REV_988X(ar) || QCA_REV_6174(ar)) {
> +	if (QCA_REV_988X(ar) || QCA_REV_9887(ar) || QCA_REV_6174(ar)) {
>  		return ath10k_pci_warm_reset(ar);
>  	} else if (QCA_REV_99X0(ar)) {
>  		ath10k_pci_irq_disable(ar);
> @@ -2437,7 +2444,7 @@ static int ath10k_pci_qca99x0_chip_reset(struct ath10k *ar)
>  
>  static int ath10k_pci_chip_reset(struct ath10k *ar)
>  {
> -	if (QCA_REV_988X(ar))
> +	if (QCA_REV_988X(ar) || QCA_REV_9887(ar))
>  		return ath10k_pci_qca988x_chip_reset(ar);
>  	else if (QCA_REV_6174(ar))
>  		return ath10k_pci_qca6174_chip_reset(ar);
> @@ -2982,6 +2989,10 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>  		hw_rev = ATH10K_HW_QCA988X;
>  		pci_ps = false;
>  		break;
> +	case QCA9887_1_0_DEVICE_ID:
> +		hw_rev = ATH10K_HW_QCA9887;
> +		pci_ps = false;
> +		break;
>  	case QCA6164_2_1_DEVICE_ID:
>  	case QCA6174_2_1_DEVICE_ID:
>  		hw_rev = ATH10K_HW_QCA6174;
> @@ -3180,6 +3191,11 @@ MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API5_FILE);
>  MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_BOARD_DATA_FILE);
>  MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_BOARD_API2_FILE);
>  
> +/* QCA9887 1.0 firmware files */
> +MODULE_FIRMWARE(QCA9887_HW_1_0_FW_DIR "/" ATH10K_FW_API5_FILE);
> +MODULE_FIRMWARE(QCA9887_HW_1_0_FW_DIR "/" QCA9887_HW_1_0_BOARD_DATA_FILE);
> +MODULE_FIRMWARE(QCA9887_HW_1_0_FW_DIR "/" ATH10K_BOARD_API2_FILE);
> +
>  /* QCA6174 2.1 firmware files */
>  MODULE_FIRMWARE(QCA6174_HW_2_1_FW_DIR "/" ATH10K_FW_API4_FILE);
>  MODULE_FIRMWARE(QCA6174_HW_2_1_FW_DIR "/" ATH10K_FW_API5_FILE);
> diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
> index 8e24099..aaf53a8 100644
> --- a/drivers/net/wireless/ath/ath10k/targaddrs.h
> +++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
> @@ -447,6 +447,9 @@ Fw Mode/SubMode Mask
>  #define QCA988X_BOARD_DATA_SZ     7168
>  #define QCA988X_BOARD_EXT_DATA_SZ 0
>  
> +#define QCA9887_BOARD_DATA_SZ     7168
> +#define QCA9887_BOARD_EXT_DATA_SZ 0
> +
>  #define QCA6174_BOARD_DATA_SZ     8192
>  #define QCA6174_BOARD_EXT_DATA_SZ 0
>  
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
