Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:45871 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZEESpt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 14:45:49 -0400
Received: from poczta.o2.pl (mx12.go2.pl [193.17.41.142])
	by tur.go2.pl (o2.pl Mailer 2.0.1) with ESMTP id 9FA46230AA8
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2009 20:45:45 +0200 (CEST)
Received: from poczta.o2.pl (mx12 [127.0.0.1])
	by poczta.o2.pl (Postfix) with ESMTP id 28A72104033
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2009 20:44:36 +0200 (CEST)
Received: from localhost.localdomain (inet20908nj-0.nat.umts.dynamic.eranet.pl [213.158.196.116])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by poczta.o2.pl (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2009 20:44:32 +0200 (CEST)
Message-ID: <4A0088EE.7010804@o2.pl>
Date: Tue, 05 May 2009 20:43:58 +0200
From: Karol Szuster <qflon@o2.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

There is another problem with this piece of code. The sband will be NULL
after second iteration on single band device and cause null pointer
dereference. Everything is working with dual band card. Sorry, but i
don't know how to explain this clearly in English. I have looked on the
second patch for pid algorithm and found similar bug.
