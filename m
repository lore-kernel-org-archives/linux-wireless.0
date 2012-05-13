Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32940 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2EMEiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2012 00:38:20 -0400
Received: by obbtb18 with SMTP id tb18so5535989obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 May 2012 21:38:20 -0700 (PDT)
Message-ID: <4FAF3AB8.90900@lwfinger.net> (sfid-20120513_063848_321408_C07C2206)
Date: Sat, 12 May 2012 23:38:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix single queue drivers
References: <1336405529.4325.31.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336405529.4325.31.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2012 10:45 AM, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> My queue management rework broke drivers that don't
> have multiple AC queues and register a single queue
> only, causing a warning:
>
> WARNING: at net/mac80211/iface.c:162 ieee80211_check_queues
>
> This was due to filling the queues wrongly and then
> noticing the error when checking later.
>
> Reported-and-Tested-by: Larry Finger<Larry.Finger@lwfinger.net>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>

John,

I know you have been busy and that Linus is restricting the patches to be added 
after 3.4-rc7; however, this one really needs to get into 3.4. If it does not 
make it, every wireless device with only one hardware queue will break.

Larry


