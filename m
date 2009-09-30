Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1572 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbZI3Syt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 14:54:49 -0400
Message-ID: <4AC3A978.2070309@canonical.com>
Date: Wed, 30 Sep 2009 12:54:48 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwl-1000 firmware versions 1 and 2 are nowhere to be found
References: <4AC39D6F.5070308@canonical.com> <1254334586.26521.1617.camel@rc-desk>
In-Reply-To: <1254334586.26521.1617.camel@rc-desk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre wrote:
> Hi Tim,
> 
> On Wed, 2009-09-30 at 11:03 -0700, Tim Gardner wrote:
>> I've got a user complaining that the iwl-1000 firmware version required
>> by 2.6.31 doesn't exist. Indeed, IWL1000_UCODE_API_MAX is 2, yet the
>> only firmware available from http://intellinuxwireless.org/?n=Downloads
>> is iwlwifi-1000-3.ucode. Shall I just tell him to install compat-wireless ?
>>
>> BugLink: http://bugs.launchpad.net/bugs/439285
>>
> 
> 2.6.31 needs a few more patches to fully support 1000 series, among
> these is the patch that can parse a new ucode header format and another
> patch to update the ucode API. 
> 
> Depending on the requirements it may be easier to backport those patches
> or to just use compat-wireless. That will be the user's decision.
> 
> Here is the list of patches:
> 
> commit cc0f555d511a5fe9d4519334c8f674a1dbab9e3a
> Author: Jay Sternberg <jay.e.sternberg@intel.com>
> Date:   Fri Jul 17 09:30:16 2009 -0700
> 
>     iwlwifi: Handle new firmware file with ucode build number in header
> 
> commit cce53aa347c1e023d967b1cb1aa393c725aedba5
> Author: Jay Sternberg <jay.e.sternberg@intel.com>
> Date:   Fri Jul 17 09:30:22 2009 -0700
> 
>     iwlwifi: update 1000 series API version to match firmware
> 
> commit 02c06e4abc0680afd31bf481a803541556757fb6
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Fri Jul 17 09:30:14 2009 -0700
> 
>     iwlagn: modify digital SVR for 1000
> 
> commit 415e49936b4b29b34c2fb561eeab867d41fc43a6
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Thu Aug 13 13:30:54 2009 -0700
> 
>     iwlwifi: traverse linklist to find the valid OTP block
> 
> commit f7ea097d9b4e61a816c041c92548aad7c7ed7915
> Author: Reinette Chatre <reinette.chatre@intel.com>
> Date:   Fri Jul 24 11:13:12 2009 -0700
> 
>     iwlagn: fix null pointer access during ucode load on 1000
> 
> Reinette
> 

Hmm, I think I'll just disable the 2 PCI IDs for these cards since they
never really worked in 2.6.31 anyways. Does that make sense to you? The
above patch sets are too invasive at this point in the Karmic release
cycle. compat-wireless to the rescue.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
