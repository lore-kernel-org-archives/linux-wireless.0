Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:34880 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbYGDWcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 18:32:48 -0400
Received: by ik-out-1112.google.com with SMTP id c28so648254ika.5
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 15:32:46 -0700 (PDT)
To: linville@tuxdriver.com
Subject: Re: Oops/Warning report of the week of July 4th 2008
Date: Sat, 5 Jul 2008 00:38:49 +0200
Cc: Arjan van de Ven <arjan@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <486EA0D6.2040504@linux.intel.com>
In-Reply-To: <486EA0D6.2040504@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807050038.49712.IvDoorn@gmail.com> (sfid-20080705_003252_292958_550E5B15)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Rank 12: flush_workqueue (oops)
> 	Reported 39 times
> 	Bug in the rt25xx driver passing NULL to the flush_workqueue() function
> 	This oops was last seen in version 2.6.25.9, and first seen in 2.6.25.9.
> 	More info: http://www.kerneloops.org/searchweek.php?search=flush_workqueue

Hmm, interesting I hadn't received such reports yet..
I am afraid this was caused by a patch which was send to 2.6.26 to fix a lockdep problem. :(

John, earlier today I released the patch:
	rt2x00: Use ieee80211_hw->workqueue again
	http://article.gmane.org/gmane.linux.kernel.wireless.general/17305
actually intended for 2.6.27, but if this bug means 2.6.26 might be crashing, it might
be wiser to push it to 2.6.26.

Ivo
