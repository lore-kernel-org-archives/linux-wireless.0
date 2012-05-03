Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35027 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab2ECTFi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:05:38 -0400
Message-ID: <4FA2D6FC.4030109@hauke-m.de> (sfid-20120503_210540_840957_28757DA1)
Date: Thu, 03 May 2012 21:05:32 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mcgrof@gmail.com, lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC c-w 2/4] compat-wireless: also copy include/generated/ from
 compat
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>  <1335463674-13003-5-git-send-email-hauke@hauke-m.de>  (sfid-20120426_200823_435891_885FB2C4) <1336071426.5167.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336071426.5167.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 08:57 PM, Johannes Berg wrote:
> On Thu, 2012-04-26 at 20:07 +0200, Hauke Mehrtens wrote:
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  scripts/admin-update.sh |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
>> index fd1fa87..7147ff1 100755
>> --- a/scripts/admin-update.sh
>> +++ b/scripts/admin-update.sh
>> @@ -283,6 +283,7 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
>>  	include/trace \
>>  	include/pcmcia \
>>  	include/crypto \
>> +	include/generated \
> 
> Are you sure we want this? It seems to me that most generated things
> like asm-offsets etc. need to be taken from the *target* kernel.

The directory include/generated/ in compat, just contains
include/generated/autoconf.h, which will include linux/compat_autoconf.h
and the original file from the kernel. This way the compat_autoconf.h
will always be included when autoconf.h gets included.
See "[RFC c 2/9] compat: include compat_autoconf.h"

I do not think there will be any other header in include/generated/ we
want to extend or overwrite in compat.

Hauke
