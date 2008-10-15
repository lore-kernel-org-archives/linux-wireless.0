Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:58083 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYJQV6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 17:58:44 -0400
Received: by ug-out-1314.google.com with SMTP id k3so182219ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 14:58:41 -0700 (PDT)
Message-ID: <48F5F50C.5010802@gmail.com> (sfid-20081017_235848_139241_79CDB618)
Date: Wed, 15 Oct 2008 14:50:04 +0100
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-10-14
References: <20081015013204.GH3349@tuxdriver.com> <48F6419B.80104@gmail.com> <200810160656.52910.arvidjaar@mail.ru>
In-Reply-To: <200810160656.52910.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
>>> Just wanted to check whether you'd seen/intend to apply the orinoco
>>> patch Andrey posted in <http://marc.info/?l=linux-kernel&m=122365972026045&w=4>.
 >>> It fixes a regression (vs 2.6.26) when using 4k stacks.
> 
> well ... this is not a regression actually as the bug is triggered by
> new code that was added in 2.6.28.

Added in 2.6.28, but from then all Agere cards will execute 
orinoco_dl_firmware and clear 1K of stack, regardless of whether there 
is firmware in /lib/firmware. I'm not certain it'll blow the stack, but 
the remaining download functions don't use much more so it'll be close.

Basically, I expect anyone configuring 4k stacks and using an Agere card 
to see the problem you saw. Which is a regression wrt 2.6.27.


Regards,

Dave.
