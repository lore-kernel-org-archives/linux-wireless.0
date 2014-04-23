Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62030 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbaDWHs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 03:48:27 -0400
Received: by mail-pd0-f181.google.com with SMTP id w10so504746pde.26
        for <linux-wireless@vger.kernel.org>; Wed, 23 Apr 2014 00:48:25 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/12] mac80211: minor changes of ieee80211_reconfig()
References: <cover.1398055853.git.gamerh2o@gmail.com>
	<d8410804796e01fe8b4c62aeaca97b791154f585.1398055854.git.gamerh2o@gmail.com>
	<1398178044.4211.9.camel@jlt4.sipsolutions.net>
Date: Wed, 23 Apr 2014 15:48:13 +0800
In-Reply-To: <1398178044.4211.9.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Tue, 22 Apr 2014 16:47:24 +0200")
Message-ID: <87k3agjxky.fsf@gmail.com> (sfid-20140423_095111_513793_F039C043)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-04-22 at 16:47:24 +0200, Johannes Berg wrote:
> On Mon, 2014-04-21 at 12:52 +0800, Zhao, Gang wrote:
>> Try to update chanctx only if local->use_chanctx is true.
>
> I'm not convinced this part is correct, since the internal channel
> context handling also has an effect when the driver doesn't use it.

Actually ieee80211_assign_chanctx() checks if local->use_chanctx is
true, so this patch doesn't change the logic. I should mentioned it in
the commit log.

> Have you really thought this through?
>
> johannes
