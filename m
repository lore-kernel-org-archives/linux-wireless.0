Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64999 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab1ILNJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 09:09:05 -0400
Received: by yxm8 with SMTP id 8so110158yxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 06:09:04 -0700 (PDT)
Date: Mon, 12 Sep 2011 16:06:40 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/20] staging: brcm80211: remove static variables from
 wl_cfg80211.c
Message-ID: <20110912130640.GH14370@shale.localdomain> (sfid-20110912_150910_123213_9D04E1CF)
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
 <1315822504-24210-10-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1315822504-24210-10-git-send-email-rvossen@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 12, 2011 at 12:14:53PM +0200, Roland Vossen wrote:
> -	cfg80211_dev = kzalloc(sizeof(struct brcmf_cfg80211_dev), GFP_KERNEL);
> -	if (unlikely(!cfg80211_dev)) {
> +	cfg_dev = kzalloc(sizeof(struct brcmf_cfg80211_dev), GFP_KERNEL);
> +	if (unlikely(!cfg_dev)) {
>  		WL_ERR("wl_cfg80211_dev is invalid\n");

This message is wrong.  Also it isn't needed because kzalloc() prints
its own more complete message.

Also unlikely() isn't needed here in the attach function.  Likely and
unlikely hints only belong in the fast path, and generally shouldn't
be included in driver code (only in core kernel code).

Don't resend the patch obviously since this was there in the
original code.

regards,
dan carpenter
