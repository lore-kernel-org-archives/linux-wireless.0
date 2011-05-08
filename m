Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:52082 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1EHRG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 13:06:26 -0400
Received: by pxi16 with SMTP id 16so3163314pxi.4
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 10:06:25 -0700 (PDT)
Message-ID: <4DC6CD8C.6080104@lwfinger.net> (sfid-20110508_190630_106268_ACCB6E16)
Date: Sun, 08 May 2011 12:06:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/3] ssb/b43(legacy): clean dangling cores workarounds
References: <1304874564-6426-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1304874564-6426-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2011 12:09 PM, Rafał Miłecki wrote:
> There is no perfect place for this workarounds, but keeping it in ssb sounds
> more reasonable.
> 1) We already have in ssb similar workarounds for different cores
> 2) We do not register not working devices in system
> 3) We do not duplicate code in b43 and b43legacy
>
> Rafał Miłecki (3):
>    ssb: update list of devices supporting multiple 80211 cores
>    b43: drop ssb-duplicated workaround for dangling cores
>    b43legacy: drop ssb-duplicated workaround for dangling cores
>
>   drivers/net/wireless/b43/main.c       |   17 -----------------
>   drivers/net/wireless/b43legacy/main.c |   18 ------------------
>   drivers/ssb/scan.c                    |    5 ++++-
>   3 files changed, 4 insertions(+), 36 deletions(-)

First of all, a minor grammatical mistake. It should be "this workaround" as 
there is only only one workaround discussed here.

Secondly, "we do not register not working" is a little awkward. "We do not 
register inactive devices..." would be better.

Finally, this commit message will never show up in the git commit logs. I think 
this info is valuable, thus it should be in the real commits.

My suggestion for the [1/3] patch is something like:

"Many of the BCM43xx chips contain cores that are attached to the SSB, but are 
inactive as they do not connect to the external environment. These must not be 
registered. Several of these types are handled in driver ssb; however, the 
specific case of an inactive 802.11 cores is now treated in b43 and b43legacy. 
Although the current setup works, this minor change will place all such 
workarounds in ssb, and simplify the code in drivers b43 and b43legacy."

In each of the other two patches, add a commit message something like:

"Remove the code to detect inactive 802.11 cores, as that function is now done 
in ssb."

I have not yet tested the patches, but will do so soon.

Larry
