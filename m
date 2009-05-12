Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:51430 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZELWkM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 18:40:12 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M40du-00085Z-75
	for linux-wireless@vger.kernel.org; Tue, 12 May 2009 22:40:10 +0000
Received: from cac94-1-81-57-151-96.fbx.proxad.net ([81.57.151.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 22:40:10 +0000
Received: from castet.matthieu by cac94-1-81-57-151-96.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 22:40:10 +0000
To: linux-wireless@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: B43 no beacon ?
Date: Tue, 12 May 2009 22:39:56 +0000 (UTC)
Message-ID: <loom.20090512T223807-343@post.gmane.org>
References: <loom.20090511T202208-851@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

after some tracing, it seems to BSS_CHANGED_BSSID flag is never set and we never
call b43_update_templates.

Removing the changed & BSS_CHANGED_BSSID check (from [1]) make the beacon work


Matthieu

[1]
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commitdiff;h=2d0ddec5b2b859f06116f631fc0ffe94fbceb556


