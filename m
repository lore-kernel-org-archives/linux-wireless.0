Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49429 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081Ab2IXQtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 12:49:50 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so7037885lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2012 09:49:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348386594-6067-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1348386594-6067-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1348386594-6067-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 24 Sep 2012 09:49:29 -0700
Message-ID: <CAB=NE6Xuw09qVPozdDcYqK9ai_ZK7DzyXi_VnzgtBPCERu-LhA@mail.gmail.com> (sfid-20120924_185000_974117_D831F120)
Subject: Re: [PATCH v3] cfg80211: Fix regulatory check for 60GHz band frequencies
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 23, 2012 at 12:49 AM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> The current regulatory code on cfg80211 performs a check to
> see if a regulatory rule belongs to an IEEE band so that if
> a Country IE is received and no rules are specified for a
> band (which is allowed by IEEE) those bands are left intact.
> The current band check assumes a rule is bound to a band
> if the rule's start or end frequency is less than 2 GHz
> apart from the center of frequency being inspected.
>
> In order to support 60 GHz for 802.11ad we need to increase
> this to account for the channel spacing of 2160 MHz whereby
> a channel somewhere in the middle of a regulatory rule may
> be more than 2 MHz apart from either the beginning or
> end of the frequency rule.
>
> Without a fix for this even though channels 1-3 are allowed world
> wide on the rule (57240 - 63720 @ 2160), channel 2 at 60480 MHz
> will end up getting disabled given that it is 3240 MHz from
> both the frequency rule start and end frequency. Fix this by
> using 2 GHz separation assumption for the 2.4 and 5 GHz bands
> but for 60 GHz use a 10 GHz separation before assuming a rule
> is not part of the band.
>
> Since we have no 802.11ad drivers yet merged this change has
> no impact to existing Linux upstream device drivers.
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
