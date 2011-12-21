Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36462 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1LURCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 12:02:31 -0500
Received: by iaeh11 with SMTP id h11so12135819iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 09:02:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324470185-17886-1-git-send-email-juhosg@openwrt.org>
References: <1324470185-17886-1-git-send-email-juhosg@openwrt.org>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 21 Dec 2011 09:02:10 -0800
Message-ID: <CAB=NE6WS6wasEEqFJ7RB7CMKYi=_RTjYJFRYLJc-_qq_-zJSuw@mail.gmail.com> (sfid-20111221_180235_108608_69153716)
Subject: Re: [PATCH] initvals: use SHA1 for verifying initval arrays
To: Gabor Juhos <juhosg@openwrt.org>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 4:23 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The current checksum implementation is broken,
> it does not catch all differences in the initval
> arrays.
>
> Here is an example:
>
> $ ./verify_checksums.sh ar9330-1p1
> ar9330-1p1     3ce64df7a3121eab71a13ba9c8e9d9075ab9bae5 pass
> $ cat csumtest.patch

In the future you may want to do this for patches with a patch in the
commit log:

$ cat csumtest.patch | awk '{print "\t"$0}'

As otherwise git will treat this as part of your patch.

This is *really* *really* sexy, thanks, applied and pushed!

  Luis
