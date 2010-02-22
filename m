Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0BVNzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 08:55:04 -0500
Date: Mon, 22 Feb 2010 14:52:58 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, stable@kernel.org
Subject: Re: [PATCH v2 0/2] iwlwifi fixes for 2.6.33 and stable
Message-ID: <20100222135256.GF2520@dhcp-lab-161.englab.brq.redhat.com>
References: <1266623253-31673-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1266623253-31673-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 03:47:31PM -0800, Reinette Chatre wrote:
> I am excluding "iwlwifi: set HT flags after channel in rxon" from this
> resend since it has been merged into wireless-2.6 already.
> 
> We address
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2160 where it can be
> seen that there are instances where the number of freed tfds are negative,
> which is triggered by the receipt of a TX response with incorrect frame
> control.

For user perspective this make network dies (no possibility to send any
data) without any error in dmesg.

> We include two patches to (1) prevent the problem from
> occuring, and (2) prevent the problem from propagating when it does occur.

I confirm patches fix the issue. Tested on 2.6.33-rc8 and 2.6.32.
For .32 patch (2) does not apply, I had to change it. I'll send 
modified patch in next email.

Cheers
Stanislaw
