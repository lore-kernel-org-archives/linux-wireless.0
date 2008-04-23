Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17274 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYDWXaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 19:30:14 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 1/1] iwlwifi: Fix built-in compilation of iwlcore
Date: Wed, 23 Apr 2008 16:30:12 -0700
Message-ID: <D936D925018D154694D8A362EEB089200444B0C8@orsmsx416.amr.corp.intel.com> (sfid-20080424_013051_328396_DEFB6EA8)
In-Reply-To: <20080423205159.GB30048@tuxdriver.com>
References: <1208947121-22640-1-git-send-email-tomas.winkler@intel.com> <20080423.034943.15067739.davem@davemloft.net> <20080423205159.GB30048@tuxdriver.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"David Miller" <davem@davemloft.net>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	<torvalds@linux-foundation.org>, "Zhu, Yi" <yi.zhu@intel.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, April 23, 2008 1:52 PM, John W. Linville  wrote:

> On Wed, Apr 23, 2008 at 03:49:43AM -0700, David Miller wrote:
>> From: Tomas Winkler <tomas.winkler@intel.com>
> 
>>> --- a/drivers/net/wireless/iwlwifi/Makefile
>>> +++ b/drivers/net/wireless/iwlwifi/Makefile
>>> @@ -1,4 +1,4 @@
>>> -obj-$(CONFIG_IWLCORE)	:= iwlcore.o
>>> +obj-$(CONFIG_IWLCORE)	+= iwlcore.o
>>>  iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o
iwl-power.o
>> 
>> I had to apply this patch by hand because "iwl-power.o" is not
>> present in the iwlcore-objs line in the current tree.
>> 
>> Does it exist in John's wireless tree or something like that?  This
>> new iwl-power.o object looks like it would be new code and a new
>> feature, which we wouldn't be able to add into the tree at this time
>> as all networking new features have gone into the merge window
>> already.
> 
> FWIW, I don't have an iwl-power.c either.  Please be careful to
> send patches against the actual upstream tree rather than a working
> tree. :-) 

We submitted this patch on top of patches we have already submitted.
iwl-power is introduced in patch "iwlwifi: Add power level support"
submitted on 04/21/2008
(http://marc.info/?l=linux-wireless&m=120881778101353&w=2)

Reinette
