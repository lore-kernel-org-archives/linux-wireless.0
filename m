Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:37260 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab0AWSdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 13:33:10 -0500
Received: by ewy26 with SMTP id 26so540226ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 10:33:06 -0800 (PST)
To: Paul.Hampson@Pobox.com
Cc: Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix tx select key null pointer crash with hostapd
References: <20100123182714.15374.3093.stgit@tikku>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 23 Jan 2010 20:33:03 +0200
In-Reply-To: <20100123182714.15374.3093.stgit@tikku> (Kalle Valo's message of "Sat\, 23 Jan 2010 20\:27\:14 +0200")
Message-ID: <87eilgpt7k.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> Pavel Roskin reported a crash in ieee80211_tx_h_select_key():
>
> http://marc.info/?l=linux-wireless&m=126419655108528&w=2
>
> This is a regression from patch "mac80211: move control.hw_key assignment".
> Fix it as suggested by Johannes, adding an else statement to make sure
> that tx->key is not accessed when it's null.

Paul, if you have the time, please try this patch. It should solve
your issue.

In case you are not subcribed to the list, the patch is here:

http://marc.info/?l=linux-wireless&m=126427124317427&w=2

-- 
Kalle Valo
