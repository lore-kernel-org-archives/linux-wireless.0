Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41079 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbYKBWEZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 17:04:25 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: No ProbeResp - assume out of range
Date: Sun, 2 Nov 2008 23:03:54 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
In-Reply-To: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811022303.54476.mb@bu3sch.de> (sfid-20081102_230430_533362_164314DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 02 November 2008 22:05:56 Luis R. Rodriguez wrote:
> I'm curious if others are getting this frequently as I am:
> 
> No ProbeResp from current AP 00:DE:AD:BE:EE:FF - assume out of range
> 
> I get this with ath5k and ath9k, can be triggered easily in ath5k by
> doing a lot of consecutive:
> 
> iwlist wlan0 scan
> 
> I have to check if I can trigger this with ath9k by scanning too. We
> were seeing this with ath9k but were thinking it was ath9k related as
> it can be triggered on it after doing a large TX. Wondering if this is
> more of a generic and mac80211 issue.

IMO this is a mac80211 issue.
mac80211 immediately assumes the connection is broken, if one probe-resp
to a keekalife-proberequest is lost.
So if you scan just after the request got sent, you'll never receive the response
and mac80211 will terminate the connection.
It should try a few times, instead, before blowing up things.

-- 
Greetings Michael.
