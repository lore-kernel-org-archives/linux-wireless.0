Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42709 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab1HDTDe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 15:03:34 -0400
Message-ID: <4E3AECFE.6030900@openwrt.org> (sfid-20110804_210337_084704_9E796CE7)
Date: Thu, 04 Aug 2011 21:03:26 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] rtlwifi: Fix build failures due to raw port access
References: <4e3aea9b.T53ak5bZ1r+a9cJM%Larry.Finger@lwfinger.net>
In-Reply-To: <4e3aea9b.T53ak5bZ1r+a9cJM%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-04 8:53 PM, Larry Finger wrote:
> When rtlwifi is built for the sh4 architecture, build errors of the following
> type occur. As these raw port accesses are specific to the X86 architecture,
> their usage is restricted and dummy routines are substituted for all other
> platforms.
By the way, even on x86 I'd recommend getting rid of this code. It seems 
that ASPM handling is mostly sorted out in the kernel, so that kind of 
hacks should no longer be necessary.

- Felix
