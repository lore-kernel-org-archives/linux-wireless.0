Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:25195 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbYEZOcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 10:32:23 -0400
Received: by el-out-1112.google.com with SMTP id s27so633350ele.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2008 07:32:20 -0700 (PDT)
Message-ID: <1ba2fa240805260732g4c5942b2qec443dfc6d6339a7@mail.gmail.com> (sfid-20080526_163227_434183_A1578925)
Date: Mon, 26 May 2008 17:32:13 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: fix deadlock in sta->lock
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1211811554.4843.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211810958-23095-1-git-send-email-tomas.winkler@intel.com>
	 <1211811554.4843.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2008 at 5:19 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-05-26 at 17:09 +0300, Tomas Winkler wrote:
>> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>>
>> This patch fixes a deadlock of sta->lock use, occuring while changing
>> tx aggregation states, as dev_queue_xmit end up in new function
>> test_and_clear_sta_flags that uses that lock thus leading to deadlock
>
> Oh, good catch, thanks. Reminds me to debug the other deadlock I saw
> (not mac80211 related though)
>
very encouraging :) . Can you send me details I also experience some
lockups on rc2
Thanks
Tomas
