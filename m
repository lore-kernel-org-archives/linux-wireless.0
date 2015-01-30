Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:36575 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982AbbA3SdC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 13:33:02 -0500
Message-ID: <54CBCE5A.9080404@hauke-m.de> (sfid-20150130_193309_078419_9771ED9B)
Date: Fri, 30 Jan 2015 19:32:58 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: cfg80211: Unknown symbol get_net_ns_by_fd (err 0)
References: <54C6A717.5050804@broadcom.com> <54CBCADA.4050801@broadcom.com>
In-Reply-To: <54CBCADA.4050801@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/30/2015 07:18 PM, Arend van Spriel wrote:
> On 01/26/15 21:44, Arend van Spriel wrote:
>> Hi Hauke,
>>
>> The commit below causes the error mentioned in the Subject: field. I
>> would like to fix this, but could use a bit of help here how to do this
>> type of things.
>>
>> commit 4b681c82d2f9bef121c912ffcaac89a004af3f2c
>> Author: Vadim Kochan <vadim4j@gmail.com>
>> Date: Mon Jan 12 16:34:05 2015 +0200
>>
>> nl80211: Allow set network namespace by fd
> 
> Hi Hauke,
> 
> I looked into my issue a bit more. So my target kernel is
> 3.11.1-200.fc19.x86_64 and checking lxr found that 3.11 has this
> function, but it does not have EXPORT_SYMBOL(). That was added by the
> same commit above. Any clues how to fix this?

Hi Arend

As Johannes said it is probably not possible to backport
get_net_ns_by_fd() correctly. You can not access any symbols which are
not exported in a kernel. To backport it we have to access
netns_operations which is also not exported.

We could  copy this function it into backports and remove this check
from the original function:
if (ei->ns_ops == &netns_operations)
..


Or we just backport this version every time:

struct net *get_net_ns_by_fd(int fd)
{
	return ERR_PTR(-EINVAL);
}

Hauke
