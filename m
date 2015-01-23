Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40871 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbbAWEvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 23:51:45 -0500
Message-ID: <1422008483.29681.2.camel@pe-lt950> (sfid-20150123_055149_302546_468B3EA6)
Subject: Re: [PATCH 3/3] mwifiex: selectively choose ext_scan support
From: Avinash Patil <patila@marvell.com>
To: James Cameron <quozl@laptop.org>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Fri, 23 Jan 2015 15:51:23 +0530
In-Reply-To: <20150121201101.GA5472@us.netrek.org>
References: <1421858531-4536-1-git-send-email-patila@marvell.com>
	 <1421858531-4536-3-git-send-email-patila@marvell.com>
	 <20150121201101.GA5472@us.netrek.org>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James/Johannes,
On Wed, 2015-01-21 at 12:11 -0800, James Cameron wrote:
> On Wed, Jan 21, 2015 at 10:12:11PM +0530, Avinash Patil wrote:
> > @@ -256,6 +256,7 @@ struct sdio_mmc_card {
> >  
> >  	u8 *mp_regs;
> >  	u8 auto_tdls;
> > +	u8 ext_scan;
> 
> Why not same name as below?
> 
> > @@ -273,6 +274,7 @@ struct mwifiex_sdio_device {
> >  	u32 mp_tx_agg_buf_size;
> >  	u32 mp_rx_agg_buf_size;
> >  	u8 auto_tdls;
> > +	u8 ext_scan_support;
> 
> > @@ -206,6 +206,7 @@ struct mwifiex_pcie_device {
> >  	u16 blksz_fw_dl;
> >  	u16 tx_buf_size;
> >  	bool supports_fw_dump;
> > +	u8 ext_scan_support;
> 
> Not consistent name style with other support variable above.  Perhaps
> should be support_ext_scan.
> 
> Long variable names for all support variables, perhaps should use:
> 
> - supports_sdio_new_mode
> + can_sdio_new
> 
> - supports_fw_dump
> + can_dump
> 
> - supports_ext_scan
> + can_ext_scan
> 

Thanks for reviewing patches. I will send v2 with naming convention and
data types fixes.

Thanks,
Avinash

