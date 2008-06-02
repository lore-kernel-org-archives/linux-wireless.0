Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:43430 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYFBREg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:04:36 -0400
Received: by wx-out-0506.google.com with SMTP id h29so718537wxd.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2008 10:04:35 -0700 (PDT)
Message-ID: <1ba2fa240806021004j5dd5cd80o9bbd58b9f50272a0@mail.gmail.com> (sfid-20080602_190439_660590_8C581C88)
Date: Mon, 2 Jun 2008 20:04:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: removing shadowed sband
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1212425690.20021.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212421452-5635-1-git-send-email-tomas.winkler@intel.com>
	 <1212421452-5635-2-git-send-email-tomas.winkler@intel.com>
	 <1212425690.20021.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 2, 2008 at 7:54 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2008-06-02 at 18:44 +0300, Tomas Winkler wrote:
>> This patch removes doubly defined sband variable
>
>>       if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
>>           (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)) {
>> -             struct ieee80211_supported_band *sband;
>>               struct ieee80211_rate *rate;
>>               s8 baserate = -1;
>>               int idx;
>
> I guess we can remove the double assignment too since it's the same as
> already done. I must have added that when doing the mechanical tx rate
> idx changes. :/
>
Good point. I also did only mechanical fix for the compiler warning ;)
Tomas
