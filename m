Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57100 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbZIBRRD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 13:17:03 -0400
Subject: Re: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Lutomirski <luto@mit.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1251911029.2999.0.camel@johannes.local>
References: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
	 <1251906970.13180.137.camel@rc-desk>
	 <cb0375e10909020941qa54215cqb6af7ac01e87ccb3@mail.gmail.com>
	 <1251910457.13180.160.camel@rc-desk>
	 <1251911029.2999.0.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 10:17:05 -0700
Message-Id: <1251911825.13180.173.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, 2009-09-02 at 10:03 -0700, Johannes Berg wrote:
> On Wed, 2009-09-02 at 09:54 -0700, reinette chatre wrote:
> > On Wed, 2009-09-02 at 09:41 -0700, Andrew Lutomirski wrote:
> > > Fair enough.  Would you accept a patch to remove power_level from sysfs instead?
> > No. This file is used when users want to manually reduce the power used
> > by device. This is the file you want to change if you want to extend
> > your battery life.
> Actually, we have already removed that file for 2.6.32 I think? 

The file itself was removed, but from what I understand the same
functionality can now be obtained from sleep_level_override. Users who
previously used power_level can thus now use sleep_level_override, but
with sleep_level_override not existing in 2.6.31 they will have no
alternative if we remove power_level.

> So it
> may be fair to remove it for .31 since there you can't use it anyway.

You can still use it to manually set power index used by device to
reduce power usage.

Reinette


