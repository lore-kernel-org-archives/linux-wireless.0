Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62571 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbYLBVoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 16:44:08 -0500
Subject: Re: [PATCH 10/11] iwlwifi: rely on API version read from firmware
From: reinette chatre <reinette.chatre@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1228252758.31158.252.camel@violet.holtmann.net>
References: <> <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-6-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-7-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-8-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-9-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-10-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-11-git-send-email-reinette.chatre@intel.com>
	 <1228252758.31158.252.camel@violet.holtmann.net>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 13:45:03 -0800
Message-Id: <1228254303.10900.90.camel@rc-desk> (sfid-20081202_224412_753495_952CA193)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-12-02 at 13:19 -0800, Marcel Holtmann wrote:
> Hi Reinette,
> 
> > This adds the infrastructure to support older firmware APIs.
> > The API version number is stored as part of the filename, we first try to
> > load the most recent firmware and progressively try lower versions.
> > The API version is also read from the firmware self and stored as part
> > of the iwl_priv structure. Only firmware that is supported by driver will
> > be loaded. The version number read from firmware is compared
> > to supported versions in the driver not the API version used as part of
> > filename.
> 
> thanks for doing this. This can really help smooth upgrade path in case
> the firmware API changes.
>  
> > -MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE);
> > -MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE);
> > +MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
> > +MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
> 
> So we don't have clear semantics on how MODULE_FIRMWARE should be used.
> The current way is that it list all potential firmware versions. So in
> cases it support API -1 and -2, then it has to list both. And not only
> the latest.

Even though the driver supports older firmware we really want the user
to use the latest firmware. The driver will also print a clear error if
the user is using API -1 and the latest available is -2. For this reason
we do want to make clear through MODULE_FIRMWARE which firmware the
driver would like to work with: the latest.

> Personally I think we should not create too many macros here and just
> list all the firmware files manually.

Having one spot to change when a new API is supported makes the code
less error prone.

Reinette

