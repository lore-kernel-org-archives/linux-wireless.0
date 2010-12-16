Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47453 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0LPL7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 06:59:21 -0500
Received: by iwn9 with SMTP id 9so3203369iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 03:59:21 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19721.65246.410283.55163@gargle.gargle.HOWL>
Date: Thu, 16 Dec 2010 17:28:22 +0530
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	m.sujith@gmail.com
Subject: [RFC] ath9k_htc : Update txrate status to mac80211
In-Reply-To: <1292499588-11636-1-git-send-email-mshajakhan@atheros.com>
References: <1292499588-11636-1-git-send-email-mshajakhan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> In ath9k htc txrate status is not updated to mac80211 as rate control is
> handled in firmware.This workaround will obtain the txrate which was
> supposed to be for debug statistics and updates it to mac80211 using
> a rate control look up table.

Well, we can't match the TXRATE event with any transmitted frame,
so we would end up sending bogus and most likely, stale, information to mac80211.

Sujith
