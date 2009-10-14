Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:49066 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbZJNG3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 02:29:04 -0400
Received: by ewy4 with SMTP id 4so4126397ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 23:28:27 -0700 (PDT)
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: add ieee80211_rx_ni()
References: <20091013173313.13021.80289.stgit@tikku>
	<646765f40910131533hccd7403jf3e4a66074dd7143@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 14 Oct 2009 09:28:25 +0300
In-Reply-To: <646765f40910131533hccd7403jf3e4a66074dd7143@mail.gmail.com> (Julian Calaby's message of "Wed\, 14 Oct 2009 08\:33\:21 +1000")
Message-ID: <87hbu2o5fa.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

>> - * Calls to this function and ieee80211_rx() may not be mixed for a
>> - * single hardware.
>> + * Calls to this function, ieee80211_rx() or ieee80211_rx_ni() may not
>> + * be mixed for a single hardware.
>
> You missed out ieee80211_rx_irqsafe() here.

Here "this function" refer to ieee80211_rx_irqsafe(). But I can also
write it like this:

  Calls to ieee80211_rx_irqsafe(), ieee80211_rx() or ieee80211_rx_ni()
  may not be mixed for a single hardware.

Is that any better?

-- 
Kalle Valo
