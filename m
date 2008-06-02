Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.179]:40018 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYFBQ7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 12:59:43 -0400
Received: by el-out-1112.google.com with SMTP id m34so93662ele.23
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2008 09:59:43 -0700 (PDT)
Message-ID: <1ba2fa240806020959x26a24c50sc728ab5534babd64@mail.gmail.com> (sfid-20080602_185947_086310_851F3905)
Date: Mon, 2 Jun 2008 19:59:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: fix unbalanced locking in ieee80211_get_buffered_bc
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1212425595.20021.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212421452-5635-1-git-send-email-tomas.winkler@intel.com>
	 <1212425595.20021.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 2, 2008 at 7:53 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Good catch. However, we'll leak skb in that case, so how about:
>
>        if (WARN_ON(tx.skb != skb))
> -               return NULL;
> +               res = TX_DROP;
>
Looks better, will send V2.

> johannes
>
