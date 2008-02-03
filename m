Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:56751 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbYBCNz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 08:55:26 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2285653wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 05:55:26 -0800 (PST)
Message-ID: <1ba2fa240802030555v28873634wceff4ecea67d3530@mail.gmail.com> (sfid-20080203_135531_599262_8292581F)
Date: Sun, 3 Feb 2008 15:55:26 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: cfg80211 API changes
Cc: linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240802030539h132c7365g1bc1c20b1c560c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240802030539h132c7365g1bc1c20b1c560c0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes

How did you planed to get transmission rate back to scaling algorithm
through tx_status?
I'm finding it a bit cumbersome,. now when tx_rate is pointer and
doesn't resides in the ieee80211_tx_control
I've seen in your patch you've just ripped this code off but our rate
scale algorithms doesn't work without it actually the code that read
this value in rate scale algorithm is there but it actually looking
into empty space...

 -       tx_status->control.tx_rate =
 -               iwl4965_hw_get_rate_n_flags(tx_resp->rate_n_flags);

 I'm just asking if you had something in mind or it's just something you forgot.



 struct ieee80211_tx_control {
         struct ieee80211_vif *vif;
         struct ieee80211_rate *tx_rate;  ---here
 }

Thanks
Tomas
