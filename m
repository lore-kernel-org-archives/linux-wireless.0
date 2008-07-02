Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55944 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbYGBG0t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 02:26:49 -0400
Subject: Re: [PATCH] iwlwifi: remove input device from iwl3945
From: Zhu Yi <yi.zhu@intel.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Adel Gadllah <adel.gadllah@gmail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Fabien Crespel <fcrespel@gmail.com>
In-Reply-To: <200807011613.43501.IvDoorn@gmail.com>
References: <8AD95083DC3E36478732061D97524415035E38AB@pdsmsx411.ccr.corp.intel.com>
	 <1214918580-5855-1-git-send-email-linville@tuxdriver.com>
	 <200807011613.43501.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 14:25:14 +0800
Message-Id: <1214979914.14590.453.camel@debian.sh.intel.com> (sfid-20080702_082652_985401_59A33F23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-01 at 16:13 +0200, Ivo van Doorn wrote:
> How is the changed rfkill state of the driver reported to rfkill?
> I see that the patch to remove the input device doesn't remove the
> call input_report_key() by which I assume such call was never made.
> This would mean rfkill support in iwlwifi has always been broken and
> the entire input device wasn't used at all.

Yes, we don't use the input device before and I believe we shouldn't.
The patch just removes it.

> From what I gather from the code itself is the function responsible
> for changing the state iwl_rfkill_set_hw_state() but that only updates
> the state, and doesn't report anything to the rfkill layer.

Right, we will switch to use rfkill_force_state() instead.

Thanks,
-yi

