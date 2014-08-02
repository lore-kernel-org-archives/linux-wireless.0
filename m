Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:60808 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaHBICR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2014 04:02:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix wmi service bitmap debug
References: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
	<87k36r5ra2.fsf@kamboji.qca.qualcomm.com>
	<1406962776.1835.3.camel@joe-AO725>
Date: Sat, 2 Aug 2014 11:02:08 +0300
In-Reply-To: <1406962776.1835.3.camel@joe-AO725> (Joe Perches's message of
	"Fri, 1 Aug 2014 23:59:36 -0700")
Message-ID: <87fvhf5ngf.fsf@kamboji.qca.qualcomm.com> (sfid-20140802_100231_365125_E183AA00)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

>> This introduces a new checkpatch warning:
>> 
>> drivers/net/wireless/ath/ath10k/wmi.h:214: ERROR: spaces required around that ':' (ctx:VxE)
>> 
>> But I think that's just a false warning and I should ignore it. Any
>> other ideas?
>
> I don't get a warning with this patch.
>
> What's the last git commit id of the checkpatch version
> you used?

I was using a pretty old version of checkpatch (I have a local copy of
it) but now I updated it to commit ae3ccc4678. I still see the warning
plus a new fallthrough warning (see below).

> $ ./scripts/checkpatch.pl --strict ath10k.diff  
> total: 0 errors, 0 warnings, 0 checks, 471 lines checked

With that command line I don't see it either. But normally I use -f and
that's when I see it:

$ scripts/checkpatch.pl --strict --ignore NETWORKING_BLOCK_COMMENT_STYLE,PARENTHESIS_ALIGNMENT -f drivers/net/wireless/ath/ath10k/wmi.h
ERROR: spaces required around that ':' (ctx:VxE)
#214: FILE: drivers/net/wireless/ath/ath10k/wmi.h:214:
+       default:
               ^

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#214: FILE: drivers/net/wireless/ath/ath10k/wmi.h:214:
+       default:

total: 1 errors, 1 warnings, 0 checks, 4803 lines checked

NOTE: Ignored message types: NETWORKING_BLOCK_COMMENT_STYLE PARENTHESIS_ALIGNMENT

drivers/net/wireless/ath/ath10k/wmi.h has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

-- 
Kalle Valo
