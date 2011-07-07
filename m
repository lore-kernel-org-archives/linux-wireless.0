Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9327 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab1GGA6M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 20:58:12 -0400
Message-ID: <4E1504A3.1070801@gnu.org> (sfid-20110707_025817_699095_C779AAF9)
Date: Wed, 06 Jul 2011 20:58:11 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Henry Ptasinski <henryp@broadcom.com>, linville@tuxdriver.com,
	gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Zhenhui Lin <frankyl@broadcom.com>
Subject: Re: [RFC] Move brcm80211 to mainline
References: <20110707002034.GA17885@broadcom.com> <CACna6rx5EyZ-=2XgWawdN_Qu2t1K1sdHZydZFW6=TiX2QUwMfw@mail.gmail.com>
In-Reply-To: <CACna6rx5EyZ-=2XgWawdN_Qu2t1K1sdHZydZFW6=TiX2QUwMfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2011 08:40 PM, Rafał Miłecki wrote:
> Short question, without commenting on brcm80211 code yet:
>
> Why should we want 2 mainline drivers for the same hardware?

Also, checkpatch.pl finds a lot of bad stuff:

total: 1 errors, 1505 warnings, 105454 lines checked

$ scripts/checkpatch.pl 0001-wireless-testing-add-brcm80211.patch >Log
$ egrep '^(WARNING|ERROR)' Log |sort |uniq -c
       1 ERROR: do not use assignment in if condition
      76 WARNING: braces {} are not necessary for any arm of this statement
     205 WARNING: braces {} are not necessary for single statement blocks
       4 WARNING: consider using a completion
      11 WARNING: consider using kstrto* in preference to simple_strtoul
      20 WARNING: do not add new typedefs
       5 WARNING: externs should be avoided in .c files
    1164 WARNING: line over 80 characters
      20 WARNING: Use of volatile is usually wrong: see 
Documentation/volatile-considered-harmful.txt

That's the "error".  It should be easy to fix.

ERROR: do not use assignment in if condition
#35077: FILE: drivers/net/wireless/brcm80211/brcmsmac/main.c:261:
+               if ((cfg = (wlc)->bsscfg[idx]))

20 typedefs seems excessive to me.

-- 
Regards,
Pavel Roskin
