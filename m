Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:37590 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZH3XAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 19:00:11 -0400
Received: by ey-out-2122.google.com with SMTP id 25so713820eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2009 16:00:12 -0700 (PDT)
Message-ID: <4A9B0479.209@lwfinger.net>
Date: Sun, 30 Aug 2009 18:00:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tobias Schlemmer <keinstein_junior@gmx.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187b Problem with tx level
References: <h7eo7q$7ks$1@ger.gmane.org>
In-Reply-To: <h7eo7q$7ks$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Schlemmer wrote:
> 
> Interestingly iwconfig always reports TX power of 20dBm, regardless of
> the actual tx power, but always a TX rate of 1M. Setting the latter to a
> higher value results in packet loss.

Where are you located? Your log says you are using the EU regulatory
domain; however, that is no longer valid. You should add a line like

options cfg80211 ieee80211_regdom=XX

to /etc/modprobe.conf.local. From your name, I would guess the XX
should be DE.

It is likely that the 20 dBm is set by mac80211 as the maximum allowed
by your local regulations. That value is in fact correct for most
locations in the EU.

My rtl8187b runs at a full 54 Mbs and operates at at least 15 m from
my AP. I don't run AP firmware that lets me see the signal strength
from the STA.
