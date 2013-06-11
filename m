Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61500 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab3FKRLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 13:11:48 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc8so8749496pbc.4
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 10:11:47 -0700 (PDT)
Received: from [131.179.210.181] (Cs-210-181.CS.UCLA.EDU. [131.179.210.181])
        by mx.google.com with ESMTPSA id z19sm6656257paf.12.2013.06.11.10.11.45
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 11 Jun 2013 10:11:46 -0700 (PDT)
Message-ID: <51B75A50.1010407@gmail.com> (sfid-20130611_191158_665348_7AA92740)
Date: Tue, 11 Jun 2013 10:11:44 -0700
From: wen <allen.z.wen@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: How to change channel type b/t HT20 and HT40 in driver code (ath9k)?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Developers!

I've been trying to implement Notify Channel Width for linux wireless
compat driver.

One thing need to be done is to change station's channel type between ht20
and ht40 without interrupting data transmission.

What I can do now is switching between ht20 rates and ht40 rates, but not
channel type. For ap side, ieee80211_set_channel_type() works fine when
called in function ieee80211_rx_h_action() to change ap channel type
between ht20 and ht40. But on station side, I couldn't find a proper
function within which to call ieee80211_set_channel_type(), and all my try
caused kernel panic. Even calling ieee80211_set_channel_type() exactly the
same way I do with ap on station side will crash system also.

Could anybody give some hint on possible way (e.g. API) to change channel
type between ht20 and ht40 on station side, please?

Thanks in advance!

Wen

