Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:40550 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbZBXQYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 11:24:07 -0500
Message-ID: <49A41F1D.9060300@lwfinger.net> (sfid-20090224_172411_350154_9BF6D0B9)
Date: Tue, 24 Feb 2009 10:23:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
CC: Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: More data on open-source firmware crash
References: <49A1A331.9080205@lwfinger.net> <80C13710-6BA9-4F14-95B5-82C3043CE93B@ing.unibs.it>
In-Reply-To: <80C13710-6BA9-4F14-95B5-82C3043CE93B@ing.unibs.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Francesco,

I don't think the problem results from an overrun of the TX FIFO. In my latest
test, I added code in routine handle_irq_transmit_status() that would print a
message if the while loop count reached 16 or more. That print did not occur.
The largest queue depth reached during the run was 14. When the first
out-of-order cookie was received, the largest depth in the last 64 transactions
was only 5.

I'm going to increase the number of transactions saved for my next run. Any
other info that I should capture?

Larry
