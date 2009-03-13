Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f167.google.com ([209.85.217.167]:45577 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZCMCEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 22:04:12 -0400
Received: by gxk11 with SMTP id 11so2519161gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 19:04:08 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18873.48952.353253.595670@gargle.gargle.HOWL> (sfid-20090313_030417_433997_48CFB8AB)
Date: Fri, 13 Mar 2009 07:34:40 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: ath9k fragmentation
In-Reply-To: <1236881434.25931.1.camel@johannes.local>
References: <1236881434.25931.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Just a quick note -- was testing fragmentation and happened to use ath9k
> as the test station, this failed utterly, it sent increasing sequence
> numbers and no fragment number.

Sequence number handling is pretty much borked in ath9k.
There is a comment in assign_aggr_tid_seqno@xmit.c - and it doesn't make much sense.
Removing all crappy code in ath9k dealing with this and leaving everything
to mac80211 would certainly be the better option, but we still have to figure
out how to manage BA windows.

Sujith
