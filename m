Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58582 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab2BSTRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 14:17:43 -0500
Message-ID: <4F414AC6.90709@hauke-m.de> (sfid-20120219_201745_528652_4B4FCB50)
Date: Sun, 19 Feb 2012 20:17:26 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com, m@bues.ch
Subject: Re: [PATCH 02/11] ssb: remove 5GHz antenna gain from sprom
References: <1329676345-15856-1-git-send-email-hauke@hauke-m.de> <1329676345-15856-3-git-send-email-hauke@hauke-m.de> <4F4149FC.50900@lwfinger.net>
In-Reply-To: <4F4149FC.50900@lwfinger.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2012 08:14 PM, Larry Finger wrote:
> On 02/19/2012 12:32 PM, Hauke Mehrtens wrote:
>> There is no 2.4 GHz or 5GHz antenna gain stored in sprom. The sprom
>> just stores the gain values for antenna 1 and 2 or 1 to 4 for more
>> recent sprom versions. On old devices antenna 2 was used for 5 GHz wifi.
>>
>> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
>> ---
>>   drivers/net/wireless/b43legacy/phy.c |    2 +-
>>   drivers/ssb/pci.c                    |   40
>> ++++++++++++----------------------
>>   drivers/ssb/pcmcia.c                 |   12 +++------
>>   drivers/ssb/sdio.c                   |   12 +++------
>>   include/linux/ssb/ssb.h              |    7 +-----
>>   5 files changed, 24 insertions(+), 49 deletions(-)
> 
> After this patch, I get the warning
> 
> drivers/ssb/pci.c: In function ‘sprom_extract_r123’:
> drivers/ssb/pci.c:334:5: warning: unused variable ‘gain’
> [-Wunused-variable]
> 
> I am still testing, but all other patches compile OK.

Thanks for the info, I haven't see it. I will fix it in the next round.

Hauke

