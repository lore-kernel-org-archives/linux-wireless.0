Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55668 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab3KMS5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:57:24 -0500
Received: by mail-lb0-f180.google.com with SMTP id u14so718726lbd.11
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 10:57:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384368487.14578.25.camel@jlt4.sipsolutions.net>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com> <1384368487.14578.25.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 13 Nov 2013 19:57:02 +0100
Message-ID: <CAB=NE6VkL8L1uiJTrY3P7LUSepRHkS+paE3kmsTunUW_6n5Xvg@mail.gmail.com> (sfid-20131113_195727_572443_714687DD)
Subject: Re: [RFC 0/5] cfg80211: regulatory quiescing and exporting DFS regions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Jouni Malinen <j@w1.fi>, sunitb <sunitb@qca.qualcomm.com>,
	rsunki <rsunki@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 13, 2013 at 7:48 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
>
>> Janusz, please test, and likely feel free to take on the last patch.
>> We may need help from Johannes on the rtnl lock question now required
>> for checks on enabling beacon operation.
>
> What's that rtnl thing about?

Whether or not callers of cfg80211_reg_can_beacon() have it properly
held already and if not best strategy to make this simple and concise.
The rtnl is required as we need to now query the cfg80211 regdom dfs
region for the case where a channel requires DFS.

  Luis
