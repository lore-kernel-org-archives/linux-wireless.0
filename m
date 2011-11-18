Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47349 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab1KRXVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 18:21:08 -0500
Message-ID: <4EC6E85D.9010607@hauke-m.de> (sfid-20111119_002112_665319_E048F1A3)
Date: Sat, 19 Nov 2011 00:21:01 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] compat-wireless: avoid pr_fmt build SPAM
References: <1321649673-15874-1-git-send-email-linville@tuxdriver.com> <1321655181.2367.1.camel@Joe-Laptop> <20111118223445.GA5642@tuxdriver.com> <CAB=NE6Ux=R3odTDkoibHs2E5aiMvaF1GuD-7Nv3-9ZabT74-bQ@mail.gmail.com>
In-Reply-To: <CAB=NE6Ux=R3odTDkoibHs2E5aiMvaF1GuD-7Nv3-9ZabT74-bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2011 12:03 AM, Luis R. Rodriguez wrote:
> On Fri, Nov 18, 2011 at 2:34 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Fri, Nov 18, 2011 at 02:26:21PM -0800, Joe Perches wrote:
>>> On Fri, 2011-11-18 at 15:54 -0500, John W. Linville wrote:
>>>> The way the compat-* header files are included causes the default
>>>> pr_fmt definition from <linux/kernel.h> to be evaluated for every file.
>>>> Files that define pr_fmt then generate a lot of build SPAM about
>>>> pr_fmt being redefined.
>>>>
>>>> Eliminate the build noise by preemptively undefining pr_fmt in those
>>>> files that define it.  This is accomplished by adding a patch to the
>>>> patches directory.
>>>
>>> Why not undef pr_fmt after the compat-* headers?
>>
>> That caused a build break.  IIRC, not everyone that uses pr_*
>> defines pr_fmt.  If pr_fmt is undef'd then they don't compile.
> 
> Hm, would it work if we undef but then define it?
> 
>   Luis
We could restructure compat so that it will not include everything every
time. Some time ago I tried to the extend every header with the things
needed to backport and remove the compat-*.h files completely.

The headers looked like this ( e.g. for include/linux/kernel.h):

#include <linux/version.h>
#include_next <linux/kernel.h>
#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36))
.. backport code for this kernel
#endif
#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
.. backport code for this kernel
#endif
....

Then just the headers needed at that position are included and we would
not have this problem with pr_fmt, but it takes some time to do this.

Hauke
