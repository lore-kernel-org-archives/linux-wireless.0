Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36770 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbcERBVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 21:21:21 -0400
Received: by mail-oi0-f68.google.com with SMTP id i2so6828045oib.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 18:21:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1463534086-22353-3-git-send-email-dlenski@gmail.com>
References: <1463534086-22353-1-git-send-email-dlenski@gmail.com> <1463534086-22353-3-git-send-email-dlenski@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 18 May 2016 11:21:01 +1000
Message-ID: <CAGRGNgWkz_O8pPrZ8BPGP5E-L0RTpS8J6s+LNaprGq=0mxob_g@mail.gmail.com> (sfid-20160518_032124_258608_2C62B612)
Subject: Re: [PATCH 2/2] rtl8xxxu: Make polling timeout for firmware configurable
To: Dan Lenski <dlenski@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jes Sorensen <jes.sorensen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, May 18, 2016 at 11:14 AM, Dan Lenski <dlenski@gmail.com> wrote:
> This patch makes RTL8XXXU_FIRMWARE_POLL_MAX into a configurable module
> parameter, firmware_poll_max.
>
> Signed-off-by: Dan Lenski <dlenski@gmail.com>

This looks good to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index 6aed923..a1efb2c 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -44,6 +44,7 @@
>
>  static int rtl8xxxu_debug;
>  static bool rtl8xxxu_ht40_2g;
> +static int rtl8xxxu_firmware_poll_max = RTL8XXXU_FIRMWARE_POLL_MAX;
>
>  MODULE_AUTHOR("Jes Sorensen <Jes.Sorensen@redhat.com>");
>  MODULE_DESCRIPTION("RTL8XXXu USB mac80211 Wireless LAN Driver");
> @@ -59,6 +60,8 @@ module_param_named(debug, rtl8xxxu_debug, int, 0600);
>  MODULE_PARM_DESC(debug, "Set debug mask");
>  module_param_named(ht40_2g, rtl8xxxu_ht40_2g, bool, 0600);
>  MODULE_PARM_DESC(ht40_2g, "Enable HT40 support on the 2.4GHz band");
> +module_param_named(firmware_poll_max, rtl8xxxu_firmware_poll_max, int, 0600);
> +MODULE_PARM_DESC(firmware_poll_max, "Maximum polling count for firmware startup (increase if firmware fails to start)");
>
>  #define USB_VENDOR_ID_REALTEK          0x0bda
>  /* Minimum IEEE80211_MAX_FRAME_LEN */
> @@ -2050,13 +2053,13 @@ static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
>         u32 val32;
>
>         /* Poll checksum report */
> -       for (i = 0; i < RTL8XXXU_FIRMWARE_POLL_MAX; i++) {
> +       for (i = 0; i < rtl8xxxu_firmware_poll_max; i++) {
>                 val32 = rtl8xxxu_read32(priv, REG_MCU_FW_DL);
>                 if (val32 & MCU_FW_DL_CSUM_REPORT)
>                         break;
>         }
>
> -       if (i == RTL8XXXU_FIRMWARE_POLL_MAX) {
> +       if (i == rtl8xxxu_firmware_poll_max) {
>                 dev_warn(dev, "Firmware checksum poll timed out\n");
>                 ret = -EAGAIN;
>                 goto exit;
> @@ -2068,7 +2071,7 @@ static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
>         rtl8xxxu_write32(priv, REG_MCU_FW_DL, val32);
>
>         /* Wait for firmware to become ready */
> -       for (i = 0; i < RTL8XXXU_FIRMWARE_POLL_MAX; i++) {
> +       for (i = 0; i < rtl8xxxu_firmware_poll_max; i++) {
>                 val32 = rtl8xxxu_read32(priv, REG_MCU_FW_DL);
>                 if (val32 & MCU_WINT_INIT_READY)
>                         break;
> @@ -2076,7 +2079,7 @@ static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
>                 udelay(100);
>         }
>
> -       if (i == RTL8XXXU_FIRMWARE_POLL_MAX) {
> +       if (i == rtl8xxxu_firmware_poll_max) {
>                 dev_warn(dev, "Firmware failed to start\n");
>                 ret = -EAGAIN;
>                 goto exit;
> --
> 2.8.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
