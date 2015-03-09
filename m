Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:43454 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753475AbbCISUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 14:20:53 -0400
Message-ID: <1425925248.5428.39.camel@perches.com> (sfid-20150309_192056_469151_0E98B7E8)
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
From: Joe Perches <joe@perches.com>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Date: Mon, 09 Mar 2015 11:20:48 -0700
In-Reply-To: <1425920453-25099-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1425920453-25099-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1425920453-25099-2-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-09 at 13:00 -0400, Jes.Sorensen@redhat.com wrote:
> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
> from scratch utilizing the mac80211 stack.

Mostly trivial comments:

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> +RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
> +M:	Jes Sorensen <Jes.Sorensen@redhat.com>
> +L:	linux-wireless@vger.kernel.org
> +W:	http://intellinuxwireless.org
> +T:	git git://git.Mkernel.org/pub/scm/linux/kernel/git/jes/linux.git
> +	git branch rtl8723au-mac80211

please keep this on one line

T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git rtl8723au-mac80211

> diff --git a/drivers/net/wireless/rtl8xxxu.c b/drivers/net/wireless/rtl8xxxu.c

[]

> +static struct usb_device_id dev_table[] = {

Please use const where appropriate.


> +static struct ieee80211_rate rtl8xxxu_rates[] = {
[]
> +static struct ieee80211_channel rtl8xxxu_channels_2g[] = {
[]
> +static struct ieee80211_supported_band rtl8xxxu_supported_band = {
[]
> +static struct rtl8xxxu_reg8val rtl8723a_mac_init_table[] = {
[]
> +static struct rtl8xxxu_reg32val rtl8723a_phy_1t_init_table[] = {
[]
> +static struct rtl8xxxu_reg32val rtl8723a_agc_1t_init_table[] = {
[]
> +static struct rtl8xxxu_rfregval rtl8723au_radioa_rf6052_1t_init_table[] = {

> +static u8 rtl8723au_read8(struct rtl8xxxu_priv *priv, u16 addr)

> +	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_REG_READ)
> +		dev_info(&udev->dev, "%s(%04x)   = 0x%02x, len %i\n",
> +			 __func__, addr, data, len);

Probably better to use a local rtl_dbg which use
 whatever flag you want (or no flag at all)

#define rtl_dbg(dev, flag, fmt, ...)
do {
	if (rtl8xxxu_debug & RTL8XXX_DEBUG_##flag)
		dev_dbg(dev, fmt, ##__VA_ARGS__);
} while (0)

so this becomes

	rtl_dbg(&udev->dev, REG_REG, "%s(%04x)   = 0x%02x, len %i\n",
		__func__, addr, data, len);

though you could remove the __func__ here as
dynamic_debug can add it for you.


> +static bool rtl8xxxu_simularity_compare(struct rtl8xxxu_priv *priv,
> +					int result[][8], int c1, int c2)

similarity ?

> +{
[]
> +	if (simubitmap == 0) {
> +		for (i = 0; i < (bound / 4); i++) {
> +			if (candidate[i] >= 0) {
> +				for (j = i * 4; j < (i + 1) * 4 - 2; j++)
> +					result[3][j] = result[candidate[i]][j];
> +				retval = false;
> +			}
> +		}
> +		return retval;
> +	} else if (!(simubitmap & 0x0f)) {

Maybe remove the else

> +		/* path A OK */
> +		for (i = 0; i < 4; i++)
> +			result[3][i] = result[c1][i];
> +	} else if (!(simubitmap & 0xf0) && is_2t) {
> +		/* path B OK */
> +		for (i = 4; i < 8; i++)
> +			result[3][i] = result[c1][i];
> +	}
> +
> +	return false;
> +}

[]

> +static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv, bool configpathb)

It might be helpful to describe the return
flags here as it's not negative error

> +	if (!(reg_eac & BIT(28)) &&
> +	    ((reg_e94 & 0x03ff0000) != 0x01420000) &&
> +	    ((reg_e9c & 0x03ff0000) != 0x00420000))
> +		result |= 0x01;
> +	else	/* If TX not OK, ignore RX */
> +		goto out;
> +
> +	/* If TX is OK, check whether RX is OK */
> +	if (!(reg_eac & BIT(27)) &&
> +	    ((reg_ea4 & 0x03ff0000) != 0x01320000) &&
> +	    ((reg_eac & 0x03ff0000) != 0x00360000))
> +		result |= 0x02;
> +	else
> +		dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
> +			 __func__);
> +out:
> +	return result;
> +}
> +
> +static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
> +				     int result[][8], int t, bool is_2t)
> +{
> +	struct device *dev = &priv->udev->dev;
> +	u32 i, val32;
> +	int path_a_ok /*, path_b_ok */;
> +	int retry = 2;
> +
> +	u32 ADDA_REG[RTL8XXXU_ADDA_REGS] = {
> +		REG_FPGA0_XCD_SWITCH_CTRL, REG_BLUETOOTH,
> +		REG_RX_WAIT_CCA, REG_TX_CCK_RFON,
> +		REG_TX_CCK_BBON, REG_TX_OFDM_RFON,
> +		REG_TX_OFDM_BBON, REG_TX_TO_RX,
> +		REG_TX_TO_TX, REG_RX_CCK,
> +		REG_RX_OFDM, REG_RX_WAIT_RIFS,
> +		REG_RX_TO_RX, REG_STANDBY,
> +		REG_SLEEP, REG_PMPD_ANAEN
> +	};

static const is generally better.

> +
> +	u32 IQK_MAC_REG[RTL8XXXU_MAC_REGS] = {
> +		REG_TXPAUSE, REG_BEACON_CTRL,
> +		REG_BEACON_CTRL_1, REG_GPIO_MUXCFG
> +	};
> +
> +	u32 IQK_BB_REG_92C[RTL8XXXU_BB_REGS] = {
> +		REG_OFDM0_TRX_PATH_ENABLE, REG_OFDM0_TR_MUX_PAR,
> +		REG_FPGA0_XCD_RF_SW_CTRL, REG_CONFIG_ANT_A, REG_CONFIG_ANT_B,
> +		REG_FPGA0_XAB_RF_SW_CTRL, REG_FPGA0_XA_RF_INT_OE,
> +		REG_FPGA0_XB_RF_INT_OE, REG_FPGA0_RF_MODE
> +	};

[]

> +static void rtl8723a_phy_iq_calibrate(struct rtl8xxxu_priv *priv, bool recovery)
> +{
[]
> +	u32 iqk_bb_reg_92c[RTL8XXXU_BB_REGS] = {
> +		REG_OFDM0_XA_RX_IQ_IMBALANCE, REG_OFDM0_XB_RX_IQ_IMBALANCE,
> +		REG_OFDM0_ENERGY_CCA_THRES, REG_OFDM0_AGCR_SSI_TABLE,
> +		REG_OFDM0_XA_TX_IQ_IMBALANCE, REG_OFDM0_XB_TX_IQ_IMBALANCE,
> +		REG_OFDM0_XC_TX_AFE, REG_OFDM0_XD_TX_AFE,
> +		REG_OFDM0_RX_IQ_EXT_ANTA
> +	};

More static const?

> +static int rtl8xxxu_set_bssid(struct rtl8xxxu_priv *priv, const u8 *bssid)
> +{
> +	int i;
> +	u16 reg;
> +
> +	dev_dbg(&priv->udev->dev,
> +		"%s: (%02x:%02x:%02x:%02x:%02x:%02x)\n",

%pM

>  __func__,
> +		bssid[0], bssid[1], bssid[2], bssid[3], bssid[4], bssid[5]);

[]

> +static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
> +{

> +	ret = rtl8xxxu_power_on(priv);
> +	if (ret < 0) {
> +		dev_warn(dev, "%s: Failed power on\n", __func__);

Do you want to use _func__ on every logging message?
If so, I suggest using custom macros to add them
instead of adding it at every use.  Something like:

#define rtl_err(dev, fmt, ...)	\
	dev_err(dev, "%s: " fmt, __func__, ##__VA_ARGS__)
#define rtl_notice(dev, fmt, ...)	\
	dev_notice(dev, "%s: " fmt, __func__, ##__VA_ARGS__)
#define rtl_warn(dev, fmt, ...)	\
	dev_warn(dev, "%s: " fmt, __func__, ##__VA_ARGS__)
#define rtl_info(dev, fmt, ...)	\
	dev_info(dev, "%s: " fmt, __func__, ##__VA_ARGS__)


> +static void rtl8xxxu_int_complete(struct urb *urb)
> +{
> +	struct rtl8xxxu_priv *priv = (struct rtl8xxxu_priv *)urb->context;
> +	struct device *dev = &priv->udev->dev;
> +	int i, ret;
> +
> +	dev_dbg(dev, "%s: status %i\n", __func__, urb->status);
> +	if (urb->status == 0) {
> +		for (i = 0; i < USB_INTR_CONTENT_LENGTH; i++) {
> +			printk("%02x ", priv->int_buf[i]);
> +			if ((i & 0x0f) == 0x0f)
> +				printk("\n");
> +		}

		print_hex_dump();



> +static int rtl8xxxu_probe(struct usb_interface *interface,
> +			  const struct usb_device_id *id)
> +{
[]
> +	dev_info(&udev->dev, "RTL8723au MAC %02x:%02x:%02x:%02x:%02x:%02x\n",
> +		 priv->efuse_wifi.efuse.mac_addr[0],
> +		 priv->efuse_wifi.efuse.mac_addr[1],
> +		 priv->efuse_wifi.efuse.mac_addr[2],
> +		 priv->efuse_wifi.efuse.mac_addr[3],
> +		 priv->efuse_wifi.efuse.mac_addr[4],
> +		 priv->efuse_wifi.efuse.mac_addr[5]);

%pM

[]

> +struct rtl8xxxu_priv {
[]
> +	u32 has_wifi:1;
> +	u32 has_bluetooth:1;
> +	u32 enable_bluetooth:1;
> +	u32 has_gps:1;
> +	u32 vendor_umc:1;
> +	u32 has_polarity_ctrl:1;
> +	u32 has_eeprom:1;
> +	u32 boot_eeprom:1;
> +	u32 ep_tx_high_queue:1;
> +	u32 ep_tx_normal_queue:1;
> +	u32 ep_tx_low_queue:1;
> +	u32 path_a_hi_power:1;

These might be better as bool instead of packed bitfields.



