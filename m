Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:62140 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbXIHRQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 13:16:07 -0400
Received: by wa-out-1112.google.com with SMTP id v27so942196wah
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2007 10:16:07 -0700 (PDT)
Message-ID: <6b8cef970709081016q1179de26sa49b3a3403283f21@mail.gmail.com>
Date: Sat, 8 Sep 2007 13:16:06 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: Kernel panic with rt2500pci built-in
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709081918.45514.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <200709081816.10143.IvDoorn@gmail.com>
	 <6b8cef970709080939v42e88426n40b68a3aa85a951f@mail.gmail.com>
	 <200709081918.45514.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/8/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>
> Did you load rc80211_simple or rc80211_lowest after modprobing mac80211?

Neither. These messages were with everything built in (including
mac80211) along with the change Johannes suggested, which was to
exchange module_init(cfg80211_init) with
subsys_initcall(cfg80211_init) in net/wireless/core.c

Even when it's built as modules, I've never had to load anything. It's
always just automatically selected the simple algorithm.
