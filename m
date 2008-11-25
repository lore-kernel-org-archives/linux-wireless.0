Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:41086 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbYKYASM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 19:18:12 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: ath5k: problems during the connection to a sitecom AP
Date: Tue, 25 Nov 2008 01:08:50 +0100
Cc: "Bob Copeland" <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <200811150207.12084.rossi.f@inwind.it> <200811221733.56583.rossi.f@inwind.it> <200811240931.24447.hs4233@mail.mn-solutions.de>
In-Reply-To: <200811240931.24447.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Message-Id: <200811250108.50527.rossi.f@inwind.it> (sfid-20081125_011816_860191_06B23C65)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 24 November 2008, Holger Schurig wrote:

> > When I do a scan after having loaded the driver, the iwlist
> > can't report the SSID because it's hidden. I don't know if
> > this is a problem but I have noticed that the reported SSIDs
> > of the two APs are a little bit different. With the 3com AP
> > (the working one) I get ESSID:" " (1 char blank string) while
> > with the Sitecom AP ESSID:"" (0 chars empty string).
>
> Okay, that could very well be the problem.

Ok, I think I have found because the association request doesn't take place. 
In mlme.c there is the function ieee80211_sta_match_ssid(). My AP is 
broadcasting a fake SSID string '\0' with length 0. The function returns 0 
instead of 1.

I don't understand the meaning of the following code:

    hidden_ssid = 1;
    tmp = ssid_len;
    while (tmp--) {
        if (ssid[tmp] != '\0') {
            hidden_ssid = 0;
            break;
        }
    }

    if (hidden_ssid && ifsta->ssid_len == ssid_len)
        return 1;

    if (ssid_len == 1 && ssid[0] == ' ')
        return 1;

Of course hidden_ssid stays 1: why do I have to verify that the two lengths 
are equal? Conversely hidden_ssid goes 0 also when it's really hidden (e.g.
SSID ' ').

The code treats the strings ' ' as a jolly (independently of hidden_sid), why 
isn't the same for the empty string ''?

I have applied the following patch, now I'm able to associate.

--- mlme.c.orig 2008-11-25 00:39:00.000000000 +0100
+++ mlme.c      2008-11-25 00:40:03.000000000 +0100
@@ -2029,6 +2029,9 @@ static int ieee80211_sta_match_ssid(stru
        if (ssid_len == 1 && ssid[0] == ' ')
                return 1;

+       if (ssid_len == 0 && ssid[0] == '\0')
+               return 1;
+
        return 0;
 }

Regards,
Fabio
