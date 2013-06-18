Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:63995 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3FRMFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 08:05:45 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so1739052bkc.14
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2013 05:05:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371548362.8318.5.camel@jlt4.sipsolutions.net>
References: <1371528422-20710-1-git-send-email-yeohchunyeow@gmail.com>
	<1371548362.8318.5.camel@jlt4.sipsolutions.net>
Date: Tue, 18 Jun 2013 20:05:44 +0800
Message-ID: <CAEFj984bjVgd19V2O618KY1MVRzKVwepfoEDo0Oh7Uj58qnS6g@mail.gmail.com> (sfid-20130618_140557_163339_E2899D5D)
Subject: Re: [PATCH] mac80211: allow key deletion for mesh interface
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I don't see that this actually changes anything. The mesh sdata will
> have a NULL bss pointer, so the second condition in sta_info_get_bss()
> can't be true.
>
> Therefore, only the first condition can ever be considered, which is
> exactly the same as sta_info_get(), no?

Yes. My current patch does not make sense since I see no difference
calling sta_info_get or sta_info_get_bss in my case.

The same applies to ieee80211_add_key.

---
Chun-Yeow
