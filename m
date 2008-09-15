Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:26076 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYIOPRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 11:17:47 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
Date: Mon, 15 Sep 2008 17:17:24 +0200
Cc: Dan Williams <dcbw@redhat.com>, Helmut Schaa <hschaa@suse.de>
References: <200809151416.07552.hschaa@suse.de> <200809151435.28933.hschaa@suse.de> <1221487652.10177.23.camel@localhost.localdomain>
In-Reply-To: <1221487652.10177.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809151717.24978.hs4233@mail.mn-solutions.de> (sfid-20080915_171750_893672_0629C113)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If you're concerned about polling or something, we could fix
> that by  sending periodic quality events (which would rock!
> then I don't have to poll in NM) on a standardized basis with a
> sliding scale of frequency based on the signal strength
> reported by the card like so:

Ah, I wrote me previous e-mail before I read the rest of your 
mail. A thing one, errm, I, shouldn't do :-)


The event that Helmut's code could send could be containing the 
current quality. For now, it could be just sent in case of "lost 
AP" condition, but we, errm, you, could later submit a patch 
that would periodically send this event according to your 
suggested schedule or something more cleverer (e.g. only send it 
when it significantly changes from the last-sent value, there's 
no need to have periodicity here).

A flag would could then define other things beside the quality, 
e.g. a FLAG_LOST_AP or FLAG_LOST_BEACON or whatever fit's into 
the nl80211 model (which I'm don't know in detail).
