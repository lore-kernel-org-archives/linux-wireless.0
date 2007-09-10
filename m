Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.229]:19737 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbXIJUkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 16:40:53 -0400
Received: by nz-out-0506.google.com with SMTP id s18so586815nze
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2007 13:40:52 -0700 (PDT)
Message-ID: <6b8cef970709101340y77264f86s535384414b68c6f2@mail.gmail.com>
Date: Mon, 10 Sep 2007 16:40:51 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Kernel panic with rt2500pci built-in
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1189422311.4506.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <1189244217.4506.16.camel@johannes.berg>
	 <6b8cef970709080857s69c055f2s1bc1ce6bd0ad4dfd@mail.gmail.com>
	 <200709081816.10143.IvDoorn@gmail.com>
	 <6b8cef970709080939v42e88426n40b68a3aa85a951f@mail.gmail.com>
	 <1189420297.4506.26.camel@johannes.berg>
	 <1189422311.4506.52.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/10/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Can you change all module_init() in net/mac80211/ to subsys_initcall()
> as well?

Thank you Johannes! This worked very well. In fact, I'm emailing this
message using my built-in rt2x00 driver.

I had to change the module_init() to subsys_initcall() in ieee80211.c
and rc80211_simple.c, as well as the original change in
net/wireless/core.c. After that, it seems to work well either built-in
or as modules.
