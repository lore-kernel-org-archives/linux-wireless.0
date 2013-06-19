Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42764 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011Ab3FSKvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 06:51:31 -0400
Message-ID: <1371639084.8349.12.camel@jlt4.sipsolutions.net> (sfid-20130619_125134_965531_CE1FE7FD)
Subject: Re: [PATCH 2/6] mac80211:  Fix bss ref leak.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jun 2013 12:51:24 +0200
In-Reply-To: <1371638988.8349.11.camel@jlt4.sipsolutions.net> (sfid-20130619_124957_085392_0DBD7298)
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
	 <1371593017-10985-2-git-send-email-greearb@candelatech.com>
	 (sfid-20130619_000406_468738_5052F99A) <1371638988.8349.11.camel@jlt4.sipsolutions.net>
	 (sfid-20130619_124957_085392_0DBD7298)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-19 at 12:49 +0200, Johannes Berg wrote:
> I think we should do this differently and have mac80211 pass the BSS
> entry back to cfg80211_connect_result. That way, we can also hold it to
> make sure it doesn't expire while we're trying to connect, which is
> another corner case here ...

Oh, actually, mac80211 doesn't have this issue but all the other drivers
do.

johannes

