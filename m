Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28653 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbZKBRT0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 12:19:26 -0500
Subject: Re: [PATCH 08/15] iwlwifi: move iwl_[un]init_drv to iwlagn
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1256968603.3555.79.camel@johannes.local>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
	 <1256938578-9638-9-git-send-email-reinette.chatre@intel.com>
	 <1256968603.3555.79.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 09:19:28 -0800
Message-Id: <1257182368.21134.13580.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, 2009-10-30 at 22:56 -0700, Johannes Berg wrote:
> On Fri, 2009-10-30 at 14:36 -0700, Reinette Chatre wrote:
> > From: Reinette Chatre <reinette.chatre@intel.com>
> > 
> > Since iwlagn is the only user of these functions, move it to this module.
> > This results in a bit more code moving than just these functions since the
> > functions only used by them are also moved and we need to export the
> > symbols previously available to them directly.
> 
> The last bit (export previously available symbols) doesn't seem to make
> sense -- if they weren't exported before then surely 3945 doesn't use
> them so they could be moved as well? Unless maybe they're used by other
> functions that _are_ used by 3945?

What happened in this patch is that I moved a function from iwlcore to
iwlagn. This function, while in iwlcore, had access to all the symbols
in iwlcore. Now that I moved the function to iwlagn I needed to make
sure all symbols needed by it was available. This resulted in me
exporting iwl_calib_free_results and iwl_init_scan_params since they are
in iwlcore and are now called by this function in iwlagn.

Reinette



