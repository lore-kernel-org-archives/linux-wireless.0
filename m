Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30722 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab0H1VBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 17:01:35 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 28 Aug 2010 14:01:30 -0700
Date: Sat, 28 Aug 2010 14:01:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH] compat: backport linux/pci-aspm.h
Message-ID: <20100828210131.GA2422@tux>
References: <1282934514-18160-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1282934514-18160-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 11:41:54AM -0700, Hauke Mehrtens wrote:
> pci-aspm.h was introduced in kernel 2.6.25 and is used by the ath5k driver.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/pci-aspm.h |   55 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 55 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/pci-aspm.h
> 
> diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
> new file mode 100644
> index 0000000..c791d00
> --- /dev/null
> +++ b/include/linux/pci-aspm.h

So compat-wireless would have to copy this file over? We'd then have to synch
this file for older kernels, and the real kernel header's own pci-aspm.h for
kernels >= 2.6.25 would be using this version of the file. Can we just stuff
the ASPM required stuff onto include/linux/compat-2.6.25.h ?

  Luis
