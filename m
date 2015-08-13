Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55661 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbbHMMhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:37:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: orinoco: Do not call wiphy_unregister() from free_orinocodev()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438879591-2849-1-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, mahfouz.saif.elyazal@gmail.com
Message-Id: <20150813123713.B897014064A@smtp.codeaurora.org> (sfid-20150813_143718_747643_BBDAE072)
Date: Thu, 13 Aug 2015 12:37:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> alloc_orinocodev() would allocate the wiphy entry, but it would only get
> registered much later in orinoco_init(). If something failed in the init
> process inbetween the call to alloc_orinocodev() and the completion
> of orinoco_init(), the drivers would end up calling wiphy_unregister()
> with a NULL pointer causing beautiful OOPS fireworks.
> 
> Explicitly call wiphy_unregister() instead in the right places.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
