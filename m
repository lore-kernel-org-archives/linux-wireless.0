Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47349 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2D3IJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 04:09:52 -0400
Message-ID: <4F9E48CD.10800@openwrt.org> (sfid-20120430_100957_386906_3FB16238)
Date: Mon, 30 Apr 2012 10:09:49 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] cfg80211: fix BSS comparison
References: <1335770616-12695-1-git-send-email-emmanuel.grumbach@intel.com>
In-Reply-To: <1335770616-12695-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-30 9:23 AM, Emmanuel Grumbach wrote:
> Since the BSS table is organized in a RB tree, the BSSs need to be
> comparable. This means that we must define a < and > operator to
> the BSS object.
> compare_ethr_addr isn't enough since it returns only a binary value.
> 
> Since Felix's
> 
> cfg80211: use compare_ether_addr on MAC addresses instead of memcmp
> 
>     Because of the constant size and guaranteed 16 bit alignment, the inline
>     compare_ether_addr function is much cheaper than calling memcmp.
> 
>     Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> The BSS table is corrupted: rb_find_bss can't find the bss.
> As a result BSSes are duplicated in the BSS table, and we get stuck
> while probing an AP before associating (in STA mode).
> 
> Change-Id: I85928756f4328028230832c1565ece7f412f3843
> CC: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Looks good, thanks for finding this.
Acked-by: Felix Fietkau <nbd@openwrt.org>
