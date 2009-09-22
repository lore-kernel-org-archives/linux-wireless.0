Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:62853 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZIVWmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 18:42:07 -0400
Received: by iwn8 with SMTP id 8so73594iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2009 15:42:10 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Sep 2009 15:41:50 -0700
Message-ID: <43e72e890909221541u67fa291fq353327d1d55841f2@mail.gmail.com>
Subject: Flush TX - wireless summit topic
To: Bob Copeland <me@bobcopeland.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another thing we spoke about at the wireless summit was flushing TX
prior to changing channel / scan. Bob, remember the issue with ath5k
on the band not coinciding on received skbs since we don't do a DMA RX
flush prior to channel change? Well one theory discussed was that we
would see that issue disappear if we actually did a proper TX flush
prior to channel change since we expect we would not see further
incoming frames from our AP if we told it we were going to PS (sending
a null func frame). If we implement a proper TX flush then the theory
goes that we wouldn't need to do any sort of DMA flush as we would not
have any frames pending.

So a plan here would be to give that a shot.

  Luis
