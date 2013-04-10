Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58498 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759589Ab3DJWQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 18:16:17 -0400
Received: by mail-bk0-f49.google.com with SMTP id w12so495169bku.8
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 15:16:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365500869.8465.10.camel@jlt4.sipsolutions.net>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
 <1365444377-9959-2-git-send-email-thomas@cozybit.com> <1365500869.8465.10.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 10 Apr 2013 15:15:56 -0700
Message-ID: <CAG6hwVP=awf3t6cQVaJx6PM1xBdTC5JWTJ1TNX8_vkZfWkFB_g@mail.gmail.com> (sfid-20130411_001621_174591_5DC5988F)
Subject: Re: [PATCH 2/6] mac80211: exclude multicast frames from BA accounting
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 9, 2013 at 2:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Subject should probably say "reordering" rather than "accounting"
>
>> Since multicast aggregation is not currently supported by
>> mac80211, we can safely ignore them when reordering
>> aggregate MPDUs.
>
> Multicast may have a lower expectation of ordering than unicast, but is
> this really the right thing to do? It seems better to just fix it?

It appears one of our changes actually introduced this bug!  It is not
reproducible with mac80211-next. Thanks for making me take a closer
look at this.

-- 
Thomas
