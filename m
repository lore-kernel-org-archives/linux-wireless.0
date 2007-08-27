Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42411 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbXH0NKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 09:10:37 -0400
Date: Mon, 27 Aug 2007 14:10:27 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
Message-ID: <20070827131026.GA21137@infradead.org>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188192012.13078.177.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 27, 2007 at 01:20:12PM +0800, Zhu Yi wrote:
> 
> Hi,
> 
> This is the second version of the patch (still against 2.6.23-rc3) adds
> the mac80211 based wireless drivers for the Intel PRO/Wireless
> 3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN (4965)
> adapters. You can find it from:
> http://intellinuxwireless.org/iwlwifi/v5-Add-iwlwifi-wireless-drivers.patch
> 
> I list the changes against the first version I submitted to the list on
> 8/17 in case you have reviewed the previous version and only want to see
> the diff. You can find the overall patch here:
> http://intellinuxwireless.org/iwlwifi/iwlwifi-v4_to_v5.patch
> and the broken out patches here:
> http://intellinuxwireless.org/iwlwifi/patches/iwlwifi-v5-v4-patches/

Btw, strong NACK from me until you sort out the mess with the common files.
Including C files with cpp symbols defined or not is not how we do driver
development in Linux.  Please split out really common code into common
files, and build driver specific code into files of it's own.  Having a
slight amount of duplicated code is much better than having such a mess
for maintaince.

