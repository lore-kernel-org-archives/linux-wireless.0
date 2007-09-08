Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:54429 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbXIHR20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 13:28:26 -0400
Received: by ug-out-1314.google.com with SMTP id z38so359956ugc
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2007 10:28:24 -0700 (PDT)
To: "Rob Hussey" <robjhussey@gmail.com>
Subject: Re: Kernel panic with rt2500pci built-in
Date: Sat, 8 Sep 2007 19:39:10 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com> <200709081918.45514.IvDoorn@gmail.com> <6b8cef970709081016q1179de26sa49b3a3403283f21@mail.gmail.com>
In-Reply-To: <6b8cef970709081016q1179de26sa49b3a3403283f21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709081939.10253.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 08 September 2007, Rob Hussey wrote:
> On 9/8/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> >
> > Did you load rc80211_simple or rc80211_lowest after modprobing mac80211?
> 
> Neither. These messages were with everything built in (including
> mac80211) along with the change Johannes suggested, which was to
> exchange module_init(cfg80211_init) with
> subsys_initcall(cfg80211_init) in net/wireless/core.c
> 
> Even when it's built as modules, I've never had to load anything. It's
> always just automatically selected the simple algorithm.

Well for some reason mac80211 cannot find a correct rate selection algorithm,
that stops the initialization of rt2x00 and in turn that cause that your interface
does not show up.

Ivo
