Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28810 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbYCKSLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 14:11:05 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Compiler error when compile iwlwifi
Date: Tue, 11 Mar 2008 11:10:04 -0700
Message-ID: <D936D925018D154694D8A362EEB0892003E01A7A@orsmsx416.amr.corp.intel.com> (sfid-20080311_181110_247727_510120BE)
In-Reply-To: <c74ac3520803020638r68f3990ayf5910b3e002f76e2@mail.gmail.com>
References: <c74ac3520802260339p7fd58501rbd967e755f4eaee6@mail.gmail.com> <D936D925018D154694D8A362EEB0892003C36C47@orsmsx416.amr.corp.intel.com> <c74ac3520802270146q697f3da8m238372c4c88ed691@mail.gmail.com> <D936D925018D154694D8A362EEB0892003C36D06@orsmsx416.amr.corp.intel.com> <c74ac3520802270638m7674c0fbh5f509fe0c5e5d566@mail.gmail.com> <D936D925018D154694D8A362EEB0892003C77505@orsmsx416.amr.corp.intel.com> <c74ac3520803020638r68f3990ayf5910b3e002f76e2@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Elyahou ITTAH" <ittah.elyahou@gmail.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, March 02, 2008 6:38 AM, Elyahou ITTAH  wrote:

> 2008/2/29, Chatre, Reinette <reinette.chatre@intel.com>:
>> On Wednesday, February 27, 2008 6:38 AM, Elyahou ITTAH  wrote:
>> 
>> 
>> 
>> 
>> What was the error?
>> 
>> 
>> 
>> 
>> These web pages are not accessible to me. Could you please include
>>  the error in your email? You can also submit a bug report at
>> bughost.org and  attach the logs there. 
>> 
>> 
>>  Reinette
> 
> I joined a file with the output of modprobe iwl3945 and dmesg... All
> after installing the driver with the compat tool.
> I also joined my compat config file...

The problem is that the mac80211 module cannot find a required symbol
when you try to load it ... the needed symbol can be found in module
cfg80211, which you already compile. Can you try to load cfg80211 before
mac80211? 

modprobe should have helped here ... can you also check if your kernel
is built with KMOD (CONFIG_KMOD)?

Reinette
