Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:37688 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752604AbcDVT3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 15:29:05 -0400
Message-ID: <1461353341.2726.14.camel@perches.com> (sfid-20160422_212910_015181_2FE4E426)
Subject: Re: Debug prints mac80211 drivers
From: Joe Perches <joe@perches.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 22 Apr 2016 12:29:01 -0700
In-Reply-To: <CABPxzYLZ2thNWCQ6bQ0-Peic-X-FTpTv4wJxyXVdmBDQDRS8JA@mail.gmail.com>
References: <CABPxzYLZ2thNWCQ6bQ0-Peic-X-FTpTv4wJxyXVdmBDQDRS8JA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-04-22 at 17:51 +0530, Krishna Chaitanya wrote:
> What is the recommended method for adding
> debug prints in mac80211 based drivers.
> 
> 1) -DDEBUG + pr_debug ==> used by mac80211, brcm80211
> 2) -DDEBUG + dev_dbg ==> zd1201
> 3) dev_printk(KERN_DEBUG) ==> used by iwlwifi
> 4) printk(KERN_DEBUG) ==> Just to complete the list.

wiphy_dbg -> netif_dbg -> netdev_dbg -> dev_dbg -> pr_debug

and CONFIG_DYNAMIC_DEBUG, no -DDEBUG required

