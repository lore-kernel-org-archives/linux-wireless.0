Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:28793 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYIHQxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 12:53:06 -0400
Received: by yx-out-2324.google.com with SMTP id 8so877201yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 09:53:04 -0700 (PDT)
Message-ID: <1ba2fa240809080953mfe2ab86l5417679e4cb29df1@mail.gmail.com> (sfid-20080908_185313_245923_8AAF120A)
Date: Mon, 8 Sep 2008 19:53:02 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: scan on IBSS mode like on STA mode
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <1220887018.31304.74.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com>
	 <1220885742.31304.67.camel@johannes.berg>
	 <1220886337.31304.71.camel@johannes.berg>
	 <1220887018.31304.74.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2008 at 6:16 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-08 at 17:05 +0200, Johannes Berg wrote:
>
>> > Can you explain why? Or can anybody else explain why we do this
>> > difference at all? And how should mesh behave?
>>
>> Actually, I do understand the difference now (explanation added below)
>> and if I'm guessing the problem you're having correctly your patch is
>> wrong. I think you want something like the patch below (never mind the
>> fact that it's against scan.c, I'm shuffling code)
>
>>       if (local->sta_sw_scanning || local->sta_hw_scanning) {
>>               if (local->scan_sdata == sdata)
>>                       return 0;
>>               return -EBUSY;
>>       }
>
> Then again, ieee80211_sta_start_scan does that check as well, so now I'm
> confused.

The bug is that scan can be triggered in STA and IBSS internally. If
you request scan from the application (iwlist) while
internally scan is running application won't fetch scan results
because the -EBUSY is returned on scan request.
Tomas

>
