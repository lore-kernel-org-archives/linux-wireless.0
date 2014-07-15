Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:51633 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305AbaGOLHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 07:07:30 -0400
Received: by mail-vc0-f170.google.com with SMTP id lf12so6093942vcb.29
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 04:07:29 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 15 Jul 2014 16:37:09 +0530
Message-ID: <CABPxzYLwBEkGN7p6J8wC+m2LP6sy+QTFyaGHq5+2UyJODH6pSg@mail.gmail.com> (sfid-20140715_130733_355245_1EEF36CB)
Subject: cfg80211 regdb 802.11d design queries
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

while testing the 802.11d implementation of cfg80211 i have below queries?

1) cfg80211 marks the channel as active after it receives a beacon on
that channel.

 But shouldn't it check for the presence of country/TPC IE in the
beacon, update the info based on that and then mark the channel as
active? without the country/TPC IE how the DUT will know the txpower
rules allowed in that regulatory domain.

2) cfg80211 updates the regulatory domain only on connection. Till
that time it just marks the specific channel on which it found beacon
as active. But as per 802.11-2012 and generic use case the purpose of
passive scanning is to know the regulatory domain information and we
can always update it based on the first beacon received. (Practically
all beacons in the vicinity should advertise same RD, unless we are on
border :-)).

This should make fixing the #1 easy.

-- 
Thanks,
Regards,
Chaitanya T K.
