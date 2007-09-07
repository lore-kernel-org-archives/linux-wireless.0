Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:53279 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXIGTbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 15:31:24 -0400
Received: by wa-out-1112.google.com with SMTP id v27so639316wah
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2007 12:31:23 -0700 (PDT)
Message-ID: <6b8cef970709071231s5693b835vaf8493254c8292da@mail.gmail.com>
Date: Fri, 7 Sep 2007 15:31:23 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Kernel panic with rt2500pci built-in
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1189125944.28781.125.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
	 <1189125944.28781.125.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> I have no idea what's going on here. Can you enable DEBUG_KOBJECT? Oh
> also, what kernel is this with?
>

This was with wireless-dev git. I can try DEBUG_KOBJECT once I get a chance.

I'd like to try to bisect this though, but I'm having trouble finding
a point in which it worked.

If I do:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git
and then:
git pull . remotes/origin/rt2x00

Then my commit history has all rt2x00 commits on top, and trying to
reset to an earlier point in time reverts rt2x00 commits, but not
wireless-dev commits (unless I  reset to before the initial rt2x00
commit). This causes compile errors mostly involving undeclared stuff
prefixed "IEEE80211_" Is there a better way to do this? Did I even
start out correctly?

Thanks,
Rob
