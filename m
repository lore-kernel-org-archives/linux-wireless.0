Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:52190 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaAEHnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jan 2014 02:43:47 -0500
Received: by mail-we0-f181.google.com with SMTP id x55so14918483wes.12
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jan 2014 23:43:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUX_P0f-SLc6GQ-t7y0O+OXOUcWmer1BrfeAt0zB7cYfLuVUg@mail.gmail.com>
References: <1388870653-3507-1-git-send-email-chaitanya.mgit@gmail.com>
 <CANUX_P1VCsciMzFzF6PmYakdTnnbMQysAQHv+Dj3JC-XzHbUvw@mail.gmail.com>
 <CABPxzYJ_iEdFVmyqMtpvzfVnyiMFR+ek8dfTjwRU0zoEBk5Dbw@mail.gmail.com>
 <CANUX_P3PK60sfTK2HHsjssrVjHX-pCpv5oVepB2aXP9Qzh6AMQ@mail.gmail.com> <CANUX_P0f-SLc6GQ-t7y0O+OXOUcWmer1BrfeAt0zB7cYfLuVUg@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 5 Jan 2014 13:13:25 +0530
Message-ID: <CABPxzY+jt7_QGGMEVDJ+XbsE6qos=GRBN90g+Ks4Np=GB1gudQ@mail.gmail.com> (sfid-20140105_084409_603251_52718105)
Subject: Re: [PATCH] mac80211: SMPS: Fix the overwrite of rx_chains in the
 interface loop.
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Same applies if the driver doesn't support channel contexts. hw_config
>> will be called with the correct local->smps_mode based on the number
>> of channels required by each one of the vifs?
>> I don't see why only the last vif will be taken into account: the loop
>> computes the maximum number of antenna requires by *all* the vifs.
>> What am I missing here?

Got it. Ours was a special loopback case where 2 VIF's talk to each other
(one AP and one STA), so we had a problem there.

Please ignore this patch. Thanks Emmanuel.
