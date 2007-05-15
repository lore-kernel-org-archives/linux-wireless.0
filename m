Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:48085 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759156AbXEOJgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2007 05:36:13 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] mac80211: fail back to use associate from reassociate
Date: Tue, 15 May 2007 02:36:12 -0700
Message-ID: <9C9B2DC3D78A6142AC8D10C89669528603F63BAC@msiexch01.marvell.com>
In-Reply-To: <1179211965.3045.170.camel@debian.sh.intel.com>
References: <20070509054152.GA30839@mail.intel.com> <20070509152855.GB941@devicescape.com> <1178767250.3045.36.camel@debian.sh.intel.com> <9C9B2DC3D78A6142AC8D10C89669528603F63B68@msiexch01.marvell.com> <1179211965.3045.170.camel@debian.sh.intel.com>
From: "Sandesh Goel" <sgoel@marvell.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Cc: "Jouni Malinen" <jkm@devicescape.com>,
	<linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



-----Original Message-----
From: Zhu Yi [mailto:yi.zhu@intel.com] 
Sent: Tuesday, May 15, 2007 12:23 PM
To: Sandesh Goel
Cc: Jouni Malinen; linux-wireless@vger.kernel.org; John W. Linville
Subject: RE: [PATCH] mac80211: fail back to use associate from
reassociate

On Mon, 2007-05-14 at 22:41 -0700, Sandesh Goel wrote:
> Therefore, the AP should not return the said error code
> (WLAN_STATUS_REASSOC_NO_ASSOC) unless it has checked (using some inter
> AP protocol) that no other AP in the ESS has an existing association
> with the requesting STA. If the AP is returning the error without
> doing this check, I would think that it is an AP bug. 

The AP was the only one in the ESS, so it should be OK.
[Sandesh] 
[Sandesh] How does the AP know that it is the only one in the ESS? It
can't surely assume that. Is it configured with this information? Did it
try to find out if there are other APs in the ESS? E.g. would it behave
differently if you setup another AP in your ESS?

> It would be interesting to know which AP behaves in this way and
> whether
> is really does the check correctly or not. Note that the AP itself
> having rebooted shouldn't cause this error code to be returned, which
> is what I found strange. 

Do you mean the AP should remember all its associated STAs before it
rebooted?
[Sandesh] 
[Sandesh] I didn't say that AP needs to remember that. However, it
should honor the reassoc request if it is not sure about whether the
requesting STA was associated in the ESS or not.

Thanks,
-yi
