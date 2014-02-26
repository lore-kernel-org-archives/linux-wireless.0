Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:19417 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaBZRSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 12:18:46 -0500
Message-ID: <530E21F3.9060302@broadcom.com> (sfid-20140226_181851_223419_AF0D8512)
Date: Wed, 26 Feb 2014 18:18:43 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: merge issue with wireless-testing
References: <530E03FF.2080608@broadcom.com> <530E04B5.4010905@broadcom.com> <530E0E4B.5020409@broadcom.com> <20140226161834.GA3243@tuxdriver.com>
In-Reply-To: <20140226161834.GA3243@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2014 05:18 PM, John W. Linville wrote:
> On Wed, Feb 26, 2014 at 04:54:51PM +0100, Arend van Spriel wrote:
>> On 02/26/2014 04:13 PM, Arend van Spriel wrote:
>>> On 02/26/2014 04:10 PM, Arend van Spriel wrote:
>>>> Hi John,
>>>>
>>>> Our internal kernel repository was still dangling on 3.14-rc1 (last
>>>> merge from wireless-testing/master) so I thought it was time to tag
>>>> along and do a new merge of wireless-testing/master, but I get a ship
>>>> load of merge conflicts that I can not explain (see below). Did you
>>>> rebase between rc1 and rc4? Hope you can end my confusion.
>>>
>>> I tried to merge:
>>>
>>> commit b8f6bdb12edb9b24114c746117087fdc9f75741e
>>> Merge: e078763 b7b146c
>>> Author: John W. Linville <linville@tuxdriver.com>
>>> Date:   Tue Feb 25 15:36:46 2014 -0500
>>>
>>>     Merge branch 'master' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/linvi
>>>
>>>     Conflicts:
>>>         drivers/net/wireless/ath/ath9k/recv.c
>>
>> git diff between v3.14-rc4 tag and wireless-testing looks pretty normal
>> except for these:
>>
>>  arch/s390/kernel/compat_wrapper.S                  |    2 +-
>>  arch/s390/pci/pci_dma.c                            |    8 +-
>>  drivers/s390/cio/chsc.c                            |    1 +
>>  drivers/s390/crypto/zcrypt_msgtype6.c              |   24 +-
>>  security/selinux/ss/policydb.c                     |    8 +-
>>
>> I think I will go and rebase instead of the merge.
> 
> I don't recall any thing weird since the -rc1 rebase.  I'm not sure
> what the problem you are seeing might be?

Well. Normally I expect and see only conflicts in our brcm80211 drivers
folder. This time I got a lot of conflict in arch/arm and devicetree
stuff. That always makes me wary. But never mind, I will rebase and
avoid making wrong decisions resolving conflicts in areas that are
outside my turf.

Thanks,
Arend
