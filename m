Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3020 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952AbXEXHvP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2007 03:51:15 -0400
Subject: Re: [PATCH 3/3] mac80211: debugfs support for TSM and DLS
From: Zhu Yi <yi.zhu@intel.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200705240012.51922.flamingice@sourmilk.net>
References: <20070514051535.GA25591@mail.intel.com>
	 <200705240012.51922.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Thu, 24 May 2007 15:51:24 +0800
Message-Id: <1179993084.6150.43.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-05-24 at 00:12 -0700, Michael Wu wrote:
> These chunks were present in the second patch of this series.

Yup. Will remove.

> So, who is going to be responsible for configuring DLS and TS? If we're going 
> to leave this policy up to userspace.. why not implement most of the DLS 
> handshake/teardown code in wpa_supplicant directly? It would make the 
> remaining DLS code in the kernel much more straightforward.

Agreed. The end users should never use the debugfs stuff. These symbols
are exported for debug and testing. I'd agree to move the policy things
to wpa_supplicant. 

> However, that's still more of an implementation detail. I'm curious about how 
> DLS would actually get initiated and used if I am, for example, transferring 
> a large file from one STA to another on the same AP. It seems like the sort 
> of information needed to make this decision are similar to what is needed to 
> decide when to set up BA.

In the DLS request side, with this patch, you can setup the target MAC
address via debugfs "dls_mac" and set 1 to "dls_op" (of course, these
will be done by wpa_supplicant in the future). So that mac80211 will
initiate DLS setup process. In the receiver side, currently, it accepts
or denies the DLS request based on the debugfs "dls_op" value. In the
future, the decision should be done by userspace via wpa_supplicant or
cfg80211.

Thanks,
-yi
