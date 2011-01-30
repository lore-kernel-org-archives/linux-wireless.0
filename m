Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48655 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1A3ScZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:32:25 -0500
Message-ID: <4D45AEB1.3010207@hauke-m.de>
Date: Sun, 30 Jan 2011 19:32:17 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	george0505 <george0505@realtek.com>,
	'Zhaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: [RFC/RFT 1/8] rtlwifi: Prepare core for addition of USB driver
References: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net> <1296411100-5675-2-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1296411100-5675-2-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2011 07:11 PM, Larry.Finger@lwfinger.net wrote:
> From: Larry Finger <Larry.Finger@lwfinger.net>
> 
> With this patch, the core driver now has the capability of handling
> USB devices.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: george0505 <george0505@realtek.com>
> Cc: 'Zhaoming_Li' <chaoming_li@realsil.com.cn>
> ---
>  drivers/net/wireless/rtlwifi/Makefile |    3 +-
>  drivers/net/wireless/rtlwifi/debug.h  |    1 +
>  drivers/net/wireless/rtlwifi/usb.c    | 1050 +++++++++++++++++++++++++++++++++
>  drivers/net/wireless/rtlwifi/usb.h    |  164 +++++
>  4 files changed, 1217 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/net/wireless/rtlwifi/usb.c
>  create mode 100644 drivers/net/wireless/rtlwifi/usb.h
> 
> diff --git a/drivers/net/wireless/rtlwifi/Makefile b/drivers/net/wireless/rtlwifi/Makefile
> index 2a7a438..efbff2f 100644
> --- a/drivers/net/wireless/rtlwifi/Makefile
> +++ b/drivers/net/wireless/rtlwifi/Makefile
> @@ -8,6 +8,7 @@ rtlwifi-objs	:=		\
>  		pci.o		\
>  		ps.o		\
>  		rc.o		\
> -		regd.o
> +		regd.o		\
> +		usb.o
.....
Now rtlwifi depends on usb (which is missing in KConfig), also when
using the PCIe chip RTL8192CE. Would it not be better to have one
interface independent core of rtlwifi as a module and one extra module
for usb and one for pcie support? I have not looked into the source code
if it is easily possible to do so.

Hauke
