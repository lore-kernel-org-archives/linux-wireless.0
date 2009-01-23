Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:12592 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZAWOkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 09:40:51 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2575633fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 06:40:49 -0800 (PST)
To: "Gordon\, Charles" <Charles.Gordon@digi.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Question on tx field of struct ieee80211_ops
References: <8DCC153EAFE67A4B990A840E829F704B010A451E5DE9@mtk-sms-exch01.digi.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 23 Jan 2009 16:40:46 +0200
In-Reply-To: <8DCC153EAFE67A4B990A840E829F704B010A451E5DE9@mtk-sms-exch01.digi.com> (Charles Gordon's message of "Thu\, 22 Jan 2009 15\:52\:30 -0600")
Message-ID: <87r62u6q6p.fsf@litku.valot.fi> (sfid-20090123_154101_911936_BFB71817)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gordon, Charles" <Charles.Gordon@digi.com> writes:

> I'm writing a wireless driver that will use the mac80211 API. My
> hardware = allows me to send one packet at a time. The driver is
> suppose to set the t= x field (among others) in the struct
> ieee80211_ops argument passed to ieee8= 0211_alloc_hw(). The tx field
> should be loaded with a pointer to a low lev= el transmit routine.
> However, it's not clear from the documentation if thi= s routine
> should maintain a packet queue or not. Is it okay for the low le= vel
> transmit routine to only allow one packet to be transmitted at a time,
> = or should it maintain a queue of tx packets? It seems like the
> mac80211 AP= I is already maintaining a queue, so I'm not sure that
> the low level driver= should maintain a second one.

In my opinion, the driver should not have a second queue. Just stop
queue while transmitting the frame and wake the queue after it has
been transmitted.

-- 
Kalle Valo
