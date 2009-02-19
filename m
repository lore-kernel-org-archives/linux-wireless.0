Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:57246 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529AbZBSGwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 01:52:00 -0500
Received: by bwz5 with SMTP id 5so645140bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 22:51:58 -0800 (PST)
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	marcel@holtmann.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: default OLD_REG to n
References: <1235002285-14812-1-git-send-email-lrodriguez@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 19 Feb 2009 08:51:55 +0200
In-Reply-To: <1235002285-14812-1-git-send-email-lrodriguez@atheros.com> (Luis R. Rodriguez's message of "Wed\, 18 Feb 2009 19\:11\:25 -0500")
Message-ID: <878wo2j4vo.fsf@litku.valot.fi> (sfid-20090219_075208_448973_A88E244F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> writes:

> Since we are not following the schedule to remove OLD_REG by 2.6.29
> lets simply set it to default to n for 2.6.30 and schedule its
> removal for 2.6.31

[...]

>  config WIRELESS_OLD_REGULATORY
>  	bool "Old wireless static regulatory definitions"
> -	default y
> +	default n
>  	---help---
>  	  This option enables the old static regulatory information
>  	  and uses it within the new framework. This is available

What does this mean in practise? If a user compiles the kernel with
the default settings, the wireless will work only if crda is
installed?

If that's the case, this is way too early. All lazy people, like me,
will get very frustrated because of this. They don't want to make all
those hoops to install crda, they just want their wireless to work.

For example, I still can't find crda from debian unstable. In my
opinion we need to wait _at least_ a year after it's available in all
distros, and only then we can make crda the default.

Let's not make the same mistake the udev people did. That was a
disaster few years back, I suffered from it multiple times.
Fortunately things have calmed down now and I can safely update the
kernel.

-- 
Kalle Valo
