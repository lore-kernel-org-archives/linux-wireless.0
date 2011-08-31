Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38387 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab1HaMbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 08:31:13 -0400
Received: by gwaa12 with SMTP id a12so6670gwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 05:31:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314792948.4161.23.camel@jlt3.sipsolutions.net>
References: <1314558661-28454-1-git-send-email-nbd@openwrt.org>
	<1314792948.4161.23.camel@jlt3.sipsolutions.net>
Date: Wed, 31 Aug 2011 14:31:13 +0200
Message-ID: <CAGXE3d-_hSmii3GsZF3jqOfP1amrMeL+GtJ605z406nRjA_z7g@mail.gmail.com> (sfid-20110831_143117_694859_6A7245A8)
Subject: Re: [PATCH] mac80211: retry sending failed BAR frames later instead
 of tearing down aggr
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 2:15 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2011-08-28 at 21:11 +0200, Felix Fietkau wrote:
>> Unfortunately failed BAR tx attempts happen more frequently than I
>> expected, and the resulting aggregation teardowns cause performance
>> issues, as the aggregation session does not always get re-established
>> properly.

Felix, so this also happens with ath9k (not only rt2800pci)?

> I find this curious. How can tons of traffic go through, but BAR frames
> fail? These are unicast and should be retried a bunch...

As I said before I could only reproduce this very seldom and the failure
was always just a temporary one. Only one or two AMPDUs failed for
whatever reason and the following BAR as well. Afterwards traffic was
going through again.

Helmut
