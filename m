Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48158 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab0AWTAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 14:00:09 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: hwtkip hangs on b43
Date: Sat, 23 Jan 2010 20:00:04 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu> <201001231919.32466.mb@bu3sch.de> <1264272828.23766.6.camel@johannes.local>
In-Reply-To: <1264272828.23766.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001232000.07229.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 23 January 2010 19:53:48 Johannes Berg wrote:
> Actually you can't, because you can't acquire the mutex here since we're
> in an atomic section. So relying on it being already locked is probably
> safer. However, you can't actually sleep anyway...

I'm OK with removing the lock from the callback, if it is guaranteed that
the callback is only called on behalf of a RX call.

We can just remove the lock and add a comment explaining why it is not locked...

-- 
Greetings, Michael.
