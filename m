Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46407
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbXG3XGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 19:06:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Date: Tue, 31 Jul 2007 01:05:55 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
References: <20070730023128.99E927B409F@zog.reactivated.net> <20070730145125.GC6586@tuxdriver.com> <20070730225205.GA17252@deine-taler.de>
In-Reply-To: <20070730225205.GA17252@deine-taler.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707310105.55863.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 July 2007, Ulrich Kunitz wrote:
> What about add_interface/remove_interfaces and monitor interfaces?
> 
> There seems to be difference between "hard" and "soft" monitor
> mode. Currently I'm not sure what the semantics is. There seems to
> be also calls to add_interface/remote_interface with if_id -1. I
> guess that means something like all interfaces. The expected
> behaviour is not documented for that case. 

I suggest you look at bcm43xx-mac80211.
You will need to introduce refcounting for your monitor interfaces
and I _really_ suggest to get rid of the zd_op_open() and zd_op_close()
functions. Just include that in add/remove interface. You need
to refcount your interfaces anyway.

I don't know what you mean by hard/soft monitor.

Don't care about the id_id. It's a cookie and it's opaque to
the driver.

Semantics are pretty easy for add/remove interface. The function
is called every time the user adds/removes an interface. :)
