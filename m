Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:54687 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1GZPzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 11:55:16 -0400
Received: by eye22 with SMTP id 22so808071eye.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 08:55:15 -0700 (PDT)
Subject: mac80211: ibss.c, missing regdom check?
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 17:55:09 +0200
Message-ID: <1311695709.2974.15.camel@alex-2> (sfid-20110726_175519_489971_026C9E8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

while developing my IBSS HT mode, I think found a missing check:

When we want to join an IBSS, we first fire a scan. When a network is
found, then we join it.
This happens in ieee80211_sta_find_ibss when we call
ieee80211_sta_join_ibss.

But in both functions there is no check if we are allowed to do IBSS on
that channel.
Is this intended?
I could join an existing network on channel 8 with a modified crda
having the NO-IBSS flag on all 2.4GHz channels.

Alex

