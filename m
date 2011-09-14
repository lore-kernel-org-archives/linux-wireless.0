Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:34214 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1INCEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 22:04:01 -0400
Date: Wed, 14 Sep 2011 05:01:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/17] staging: brcm80211: simplification of
 brcmf_netdev_ioctl_priv()
Message-ID: <20110914020124.GB7002@shale.localdomain> (sfid-20110914_040415_963961_43C65BF5)
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
 <1315900197-7260-15-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1315900197-7260-15-git-send-email-rvossen@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 09:49:54AM +0200, Roland Vossen wrote:
> +	if (ioc->buf != NULL)
> +		buflen = min_t(int, ioc->len, BRCMF_IOCTL_MAXLEN);
                              ^^^^
Should be uint here.

In Linus's tree we cast buflen to int in brcmf_proto_ioctl() so the
cap there doesn't work either.

        if (len > BRCMF_C_IOCTL_MAXLEN)
		goto done;

(len is negative).

regards,
dan carpenter

