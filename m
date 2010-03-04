Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34243 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab0CDRbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 12:31:41 -0500
Received: by pvb32 with SMTP id 32so430720pvb.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Mar 2010 09:31:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C2DE0F0B-F62A-47BC-A719-E8A598146776@cs.washington.edu>
References: <201002281534.11656.helmut.schaa@googlemail.com>
	<201003011927.53208.helmut.schaa@googlemail.com> <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com>
	<201003022047.10196.helmut.schaa@googlemail.com> <1267640304.15761.121.camel@rchatre-DESK>
	<03690D90-3C5E-4E37-8BC6-7EE6FE0B4E1D@cs.washington.edu> <1267651173.15761.155.camel@rchatre-DESK>
	<0A6DB552-23FC-46ED-9326-60EB0370C062@cs.washington.edu> <C2DE0F0B-F62A-47BC-A719-E8A598146776@cs.washington.edu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 4 Mar 2010 09:31:21 -0800
Message-ID: <43e72e891003040931n2dbd3c9cgdfbdcf1091adfe67@mail.gmail.com>
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current
	wireless-testing
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 4, 2010 at 2:24 AM, Daniel Halperin
<dhalperi@cs.washington.edu> wrote:
> On Mar 3, 2010, at 2:54 PM, Daniel Halperin wrote:

> My hypothesis as to why this code used to work is that I was using the CONFIG_WIRELESS_OLD_REGULATORY.

Can you test the same by disabling CONFIG_WIRELESS_OLD_REGULATORY ?

There is a way for a driver to claim a custom world regulatory domain,
this can be done wiphy_apply_custom_regulatory(), ath/regd.c uses
that. Otherwise indeed the pegged regulatory domain will be used as a
basis for disabling further channels.

  Luis?
