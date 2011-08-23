Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59153 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1HWIHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 04:07:48 -0400
Received: by fxh19 with SMTP id 19so78826fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 01:07:47 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: Re: [RFT v2 2/2] ath9k: add AR9580 support
Date: Tue, 23 Aug 2011 10:07:44 +0200
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
References: <1314058119-3441-1-git-send-email-lrodriguez@qca.qualcomm.com> <1314058119-3441-3-git-send-email-lrodriguez@qca.qualcomm.com>
In-Reply-To: <1314058119-3441-3-git-send-email-lrodriguez@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201108231007.44737.florian@openwrt.org> (sfid-20110823_100757_262769_7FB0A5BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis,

On Tuesday 23 August 2011 02:08:39 Luis R. Rodriguez wrote:
> From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/pci.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/pci.c
> b/drivers/net/wireless/ath/ath9k/pci.c index daa26b5..6cb90ee 100644
> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -32,6 +32,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
>  	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
>  	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
>  	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
> +	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
>  	{ 0 }
>  };

You also need this change in hw.{c,h} for ath9k not to bail out with "ath: 
Hardware device ID 0x0033 not supported":

Index: compat-wireless-2011-08-10/drivers/net/wireless/ath/ath9k/hw.c
===================================================================
--- compat-wireless-2011-08-10.orig/drivers/net/wireless/ath/ath9k/hw.c 
2011-08-23 10:01:30.804054398 +0200
+++ compat-wireless-2011-08-10/drivers/net/wireless/ath/ath9k/hw.c      
2011-08-23 10:01:46.314054408 +0200
@@ -672,6 +672,7 @@
        case AR9300_DEVID_AR9485_PCIE:
        case AR9300_DEVID_AR9330:
        case AR9300_DEVID_AR9340:
+       case AR9300_DEVID_AR9580:
                break;
        default:
                if (common->bus_ops->ath_bus_type == ATH_USB)
Index: compat-wireless-2011-08-10/drivers/net/wireless/ath/ath9k/hw.h
===================================================================
--- compat-wireless-2011-08-10.orig/drivers/net/wireless/ath/ath9k/hw.h 
2011-08-23 10:01:32.504054400 +0200
+++ compat-wireless-2011-08-10/drivers/net/wireless/ath/ath9k/hw.h      
2011-08-23 10:01:59.124054416 +0200
@@ -45,6 +45,7 @@
 #define AR9300_DEVID_PCIE      0x0030
 #define AR9300_DEVID_AR9340    0x0031
 #define AR9300_DEVID_AR9485_PCIE 0x0032
+#define AR9300_DEVID_AR9580    0x0033
 #define AR9300_DEVID_AR9330    0x0035

 #define AR5416_AR9100_DEVID    0x000b

With the above two patches applied, I get the following:

iw dev wlan0 scan                                                                                                                                                                                                          
command failed: Device or resource busy (-16)

iw phy0 info shows the 5GHz band has being listed

iw dev wlan0 survey dump seems to correctly list the activity on the 5Ghz 
channels (it's updated from one call to another)

if I start the interface in AP mode, my laptop does not see it's beacon, I 
have not had a chance yet to use a monitor interface.

Let me know if you want me to give you more debug.

Thank you very much!
-- 
Florian
