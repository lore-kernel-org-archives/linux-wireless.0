Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:63765 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab1IMTR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 15:17:57 -0400
Date: Tue, 13 Sep 2011 22:14:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 02/17] staging: brcm80211: remove ioctl layer from
 brcmsmac
Message-ID: <20110913191419.GA7002@shale.localdomain> (sfid-20110913_211801_397557_15659183)
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
 <1315900197-7260-3-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1315900197-7260-3-git-send-email-rvossen@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 09:49:42AM +0200, Roland Vossen wrote:
> @@ -530,20 +515,22 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
>  
>  		/* update the rate set */
>  		LOCK(wl);
> -		brcms_c_ioctl(wl->wlc, BRCM_SET_RATESET, &rs, sizeof(rs));
> +		error = brcms_c_set_rateset(wl->wlc, &rs);
>  		UNLOCK(wl);
> +		if (!error)
                    ^^^^^^

This test is reversed so this will fill your log with spam.

> +			wiphy_err(wiphy, "changing basic rates failed: %d\n",
> +				  error);
>  	}

regards,
dan carpenter
