Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2BFQOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 11:14:03 -0500
Message-ID: <4F2FFC25.8000705@sipsolutions.net> (sfid-20120206_171411_512422_A0BED489)
Date: Mon, 06 Feb 2012 17:13:25 +0100
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/4] iwlwifi: cleanup/fix memory barriers
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com> <1328544564-8696-3-git-send-email-sgruszka@redhat.com> (sfid-20120206_170940_538104_F123CA7E)
In-Reply-To: <1328544564-8696-3-git-send-email-sgruszka@redhat.com> (sfid-20120206_170940_538104_F123CA7E)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/6/2012 5:09 PM, Stanislaw Gruszka wrote:
> wmb(), rmb() are not needed when writel(), readl() are used as
> accessors for MMIO. We use them indirectly via iowrite32(),
> ioread32().
>
> What is needed mmiowb(), for synchronizing writes coming from
> different CPUs on PCIe bridge (see in patch comments). This
> fortunately is not needed on x86, where mmiowb() is just
> defined as compiler barrier. As iwlwifi devices are most likely
> not used on anything other than x86, this is not so important
> fix.

Technically, PCIe bridges can reorder writes as well, so we really need 
to do a dummy read somewhere -- we were discussing this internally 
recently as well.

johannes
