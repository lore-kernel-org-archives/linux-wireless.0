Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:40154 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTKPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 05:15:48 -0500
Received: by mail-ie0-f180.google.com with SMTP id tp5so5778102ieb.25
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 02:15:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384937328.14295.3.camel@jlt4.sipsolutions.net>
References: <CAPvVjisu-xcZsqHgcTEKsCJFuESDFO-_0KwkgxffyejemHJZcA@mail.gmail.com>
 <1384937328.14295.3.camel@jlt4.sipsolutions.net>
From: Blaise Gassend <blaise@suitabletech.com>
Date: Wed, 20 Nov 2013 02:15:27 -0800
Message-ID: <CAPvVjiu55=nscHa-Mpff_LL-Y0v6XHEGx0K7rpCVU9nRiKfaXA@mail.gmail.com> (sfid-20131120_111551_938142_45FA657A)
Subject: Re: QoS Data packets causing massive packet loss in ieee80211_sta_manage_reorder_buf.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Catalin Drula <catalin@suitabletech.com>,
	Alap Modi <amodi@arubanetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for the quick reply!

> I think we just need to skip reorder processing for multicast, since
> they won't be aggregated anyway?
>
> http://p.sipsolutions.net/d00799dd2201676a.txt

This patch works like a charm for my current predicament. But is it
actually written somewhere that multicast packets can't be aggregated?
I can't find any place that says they can't, but I'm not authoritative
by any means.

If aggregated packets were allowed, would the more a special tid_rx
for multicast packets be the right way to go (similar to what happens
in ieee80211_parse_qos)?

In any case, this patch seems like a huge net improvement over the
current situation and is probably worth merging.

Regards,
Blaise
