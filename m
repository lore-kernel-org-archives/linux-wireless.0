Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52121 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZIBSXi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 14:23:38 -0400
Subject: Re: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: reinette chatre <reinette.chatre@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <cb0375e10909021038k32a576f1hd519e8dcdff9ef3d@mail.gmail.com>
References: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
	 <1251906970.13180.137.camel@rc-desk>
	 <cb0375e10909020941qa54215cqb6af7ac01e87ccb3@mail.gmail.com>
	 <1251910457.13180.160.camel@rc-desk>
	 <1251911029.2999.0.camel@johannes.local>
	 <1251911825.13180.173.camel@rc-desk>
	 <1251912629.2999.1.camel@johannes.local>
	 <cb0375e10909021038k32a576f1hd519e8dcdff9ef3d@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 11:23:40 -0700
Message-Id: <1251915820.13180.200.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-09-02 at 10:38 -0700, Andrew Lutomirski wrote:
> On Wed, Sep 2, 2009 at 1:30 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> >
> > I was under the impression that Andrew said this actually didn't work.
> 
> Exactly.  My patch fixes that, although there might be a better way to do that.

Seems to be in iwl_power_update_mode() the mode is forced to CAM if
power save disabled, and power save is set to disabled if mac considers
it disabled (see setting of power_disabled in iwl_mac_config()).

One way around this is to always allow user to set power mode, even if
it is disabled from mac perspective. Since the power mode is updated in
many more spots (not always triggered by user) I do not know the full
implications of this change. Considering the unknown of this change and
the problems we have encountered when enabling power save I would rather
not merge such a patch without significant testing. I think it is too
late for 2.6.31.

The same problem should not exist in 2.6.32.

Reinette


