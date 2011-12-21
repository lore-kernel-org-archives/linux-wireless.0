Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1885 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab1LURrf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 12:47:35 -0500
Message-ID: <4EF21BA1.3020806@broadcom.com> (sfid-20111221_184738_550088_50C5119A)
Date: Wed, 21 Dec 2011 18:47:13 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcm: list of smatch warnings
References: <20111215112947.GB3906@elgon.mountain>
In-Reply-To: <20111215112947.GB3906@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2011 12:29 PM, Dan Carpenter wrote:
> Smatch still complains about the brcm driver.  Could you take a look at
> these messages?  It's mostly just cleanups like doing the correct cast
> for min_t() or handling the default cases on switch statements etc or
> verifying that we broke out of a loop instead of coming to the end
> without finding what we were looking for.

As promised I took a look at the smatch complaints.

> drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c +1710 wlc_phy_txpower_reg_limit_calc(50) error: potential null derefence 'txpwr_ptr1'.
> drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c +1719 wlc_phy_txpower_reg_limit_calc(59) error: potential null derefence 'txpwr_ptr2'.

However, I am not sure about these two. Reading the code these seem
false positives. Could you confirm or correct me on these.

Gr. AvS

