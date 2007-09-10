Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:65056 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbXIJVZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 17:25:07 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1716398wah
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2007 14:25:07 -0700 (PDT)
Message-ID: <6b8cef970709101425q42d8ceb3mc0e7a103aad45f66@mail.gmail.com>
Date: Mon, 10 Sep 2007 17:25:07 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Kernel panic with rt2500pci built-in
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <6b8cef970709101340y77264f86s535384414b68c6f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <1189244217.4506.16.camel@johannes.berg>
	 <6b8cef970709080857s69c055f2s1bc1ce6bd0ad4dfd@mail.gmail.com>
	 <200709081816.10143.IvDoorn@gmail.com>
	 <6b8cef970709080939v42e88426n40b68a3aa85a951f@mail.gmail.com>
	 <1189420297.4506.26.camel@johannes.berg>
	 <1189422311.4506.52.camel@johannes.berg>
	 <6b8cef970709101340y77264f86s535384414b68c6f2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/10/07, Rob Hussey <robjhussey@gmail.com> wrote:
> I had to change the module_init() to subsys_initcall() in ieee80211.c
> and rc80211_simple.c, as well as the original change in
> net/wireless/core.c.

After more testing, it seems to also work just as well if ieee80211.c
is left with the module_init() and both rc80211_simple.c and
net/wireless/core.c are switched to subsys_initcall().
