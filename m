Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3434 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab2FZJqr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 05:46:47 -0400
Message-ID: <4FE984F9.2060502@broadcom.com> (sfid-20120626_114650_924916_EE2A5FB3)
Date: Tue, 26 Jun 2012 11:46:33 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: fix NULL pointer crash in
 brcms_c_regd_init()
References: <1340286553-12053-1-git-send-email-arend@broadcom.com>
 <20120625165345.GB4495@thinkpad-t410>
In-Reply-To: <20120625165345.GB4495@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/25/2012 06:53 PM, Seth Forshee wrote:
> Yeah, I definitely messed that up.

I have my off days as well. We are still human, right ;-)

> This looks fine, but it strikes me that it might simplify things a bit
> to change the loop to iterate over over wlc->pub->_nbands instead. The
> difference is pretty minor though, and since John has already applied
> this patch there's probably no reason to change it.

I considered that but the iterator is used as index in the wiphy.band[]
array further in the loop. So that would require a bit more rework of
the loop (although the internal band index and the one from cfg80211 match).

Gr. AvS

