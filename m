Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:9880 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765536AbYEFJZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 05:25:22 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context
Date: Tue, 6 May 2008 11:22:21 +0200
Cc: libertas-dev@lists.infradead.org
References: <200805061104.43050.hs4233@mail.mn-solutions.de>
In-Reply-To: <200805061104.43050.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805061122.21968.hs4233@mail.mn-solutions.de> (sfid-20080506_112438_110566_D56C792A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What I don't know is why something is calling
> get_wireless_stats() when setting the essid. This happens way
> before a call into lbs_set_essid() (the WEXT handler), as can
> be seen from the log below.

Okay, that question has now an answer: an strace of iwconfig 
(wireless-tools 29~pre22-1~bpo40+1) does 
open /proc/net/wireless, which in turn calls 
lbs_get_wireless_stats().

This happens before the SIOCSIWESSID ioctl().
