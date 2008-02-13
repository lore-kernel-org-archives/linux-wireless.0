Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22911 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763377AbYBMVaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:16 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] ipw2100/ipw2200: note firmware loading caveat inKconfig help text
Date: Wed, 13 Feb 2008 13:21:28 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003A7FA4F@orsmsx416.amr.corp.intel.com> (sfid-20080213_213038_315428_BB49DB47)
In-Reply-To: <1202906930.8931.44.camel@johannes.berg>
References: <20080212134942.9FD589D4135@zog.reactivated.net> (sfid-20080212_141033_444486_ED50E00D) <1202906930.8931.44.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Daniel Drake" <dsd@gentoo.org>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ipw2100-admin@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, February 13, 2008 4:49 AM, Johannes Berg  wrote:

> On Tue, 2008-02-12 at 13:49 +0000, Daniel Drake wrote:
>> Most wireless drivers load their firmware at interface open time,
>> which generally occurs after the filesystem is available. However,
>> the ipw drivers load their firmware at probe time because firmware
>> is required to read the device MAC address. When built-in, probe
>> happens before the filesystem is available, hence device init will
>> only complete successfully if the user has made special arrangements
>> (including firmware plus a loader in the initramfs).
> 
> I wonder if the MAC address can be read directly like the 3945/4965
> hw can? 

In this patch the text in the Kconfig help text is what we go by. The
description about the MAC address in the patch description is not 100%
accurate as the MAC address is read from EEPROM, not firmware. In this
patch the goal is just to not have the driver built in, but a module.
This ensures that firmware can be loaded at a time when the filesystem
is available.

Reinette
