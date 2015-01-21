Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:35228 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbbAUUUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2015 15:20:43 -0500
Date: Thu, 22 Jan 2015 07:11:01 +1100
From: James Cameron <quozl@laptop.org>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com, yogeshp@marvell.com, nishants@marvell.com,
	frankh@marvell.com
Subject: Re: [PATCH 3/3] mwifiex: selectively choose ext_scan support
Message-ID: <20150121201101.GA5472@us.netrek.org> (sfid-20150121_212046_551702_288F2847)
References: <1421858531-4536-1-git-send-email-patila@marvell.com>
 <1421858531-4536-3-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421858531-4536-3-git-send-email-patila@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 21, 2015 at 10:12:11PM +0530, Avinash Patil wrote:
> @@ -256,6 +256,7 @@ struct sdio_mmc_card {
>  
>  	u8 *mp_regs;
>  	u8 auto_tdls;
> +	u8 ext_scan;

Why not same name as below?

> @@ -273,6 +274,7 @@ struct mwifiex_sdio_device {
>  	u32 mp_tx_agg_buf_size;
>  	u32 mp_rx_agg_buf_size;
>  	u8 auto_tdls;
> +	u8 ext_scan_support;

> @@ -206,6 +206,7 @@ struct mwifiex_pcie_device {
>  	u16 blksz_fw_dl;
>  	u16 tx_buf_size;
>  	bool supports_fw_dump;
> +	u8 ext_scan_support;

Not consistent name style with other support variable above.  Perhaps
should be support_ext_scan.

Long variable names for all support variables, perhaps should use:

- supports_sdio_new_mode
+ can_sdio_new

- supports_fw_dump
+ can_dump

- supports_ext_scan
+ can_ext_scan

-- 
James Cameron
http://quozl.linux.org.au/
