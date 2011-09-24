Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1IXKit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Sep 2011 06:38:49 -0400
Subject: Re: [PATCH 09/20] staging: brcm80211: use endian annotated
 structures in brcmsmac
From: Johannes Berg <johannes@sipsolutions.net>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1316830148-28661-10-git-send-email-frankyl@broadcom.com> (sfid-20110924_040943_301385_9930B29B)
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
	 <1316830148-28661-10-git-send-email-frankyl@broadcom.com>
	 (sfid-20110924_040943_301385_9930B29B)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Sep 2011 12:38:41 +0200
Message-ID: <1316860721.3952.5.camel@jlt3.sipsolutions.net> (sfid-20110924_123853_498076_37E50403)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-23 at 19:08 -0700, Franky Lin wrote:

>   * RxTSFTime: RxTSFTime time of first MAC symbol + M_PHY_PLCPRX_DLY
>   * RxChan: gain code, channel radio code, and phy type
>   */
> +struct d11rxhdr_le {
> +	__le16 RxFrameSize;
> +	u16 PAD;
> +	__le16 PhyRxStatus_0;
> +	__le16 PhyRxStatus_1;
> +	__le16 PhyRxStatus_2;
> +	__le16 PhyRxStatus_3;
> +	__le16 PhyRxStatus_4;
> +	__le16 PhyRxStatus_5;
> +	__le16 RxStatus1;
> +	__le16 RxStatus2;
> +	__le16 RxTSFTime;
> +	__le16 RxChan;
> +} __packed;
> +
>  struct d11rxhdr {
>  	u16 RxFrameSize;
>  	u16 PAD;

> +	union {
> +		struct d11rxhdr_le rxh_le;
> +		struct d11rxhdr rxh_cpu;
> +	};

This seems a little strange. Why would it be both in LE and CPU byte
order?

johannes

