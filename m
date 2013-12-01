Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3LAJj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 04:39:57 -0500
Message-ID: <1385890789.4171.5.camel@jlt4.sipsolutions.net> (sfid-20131201_104000_400010_4F73797E)
Subject: Re: multi-wiphy (virtual radios that can be used with multiple
 channels)
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Drasko DRASKOVIC <drasko.draskovic@gmail.com>, j@w1.fi,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 01 Dec 2013 10:39:49 +0100
In-Reply-To: <21146.47199.25277.169624@gargle.gargle.HOWL>
References: <CAEk6gTCqKgt9zX0Xs147GYfxDw2Ex-1NkG4KZ_m_pdf1M8eDLw@mail.gmail.com>
	 <21146.33378.141904.187743@gargle.gargle.HOWL>
	 <CAEk6gTBS=WKfmDpzhd7istgCFnxMOpqJJnr7PUwKQ=uHeS0cdw@mail.gmail.com>
	 <21146.47199.25277.169624@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-12-01 at 09:47 +0530, Sujith Manoharan wrote:
> Drasko DRASKOVIC wrote:
> > That would imply that HW is capable of doing this, but SW driver
> > components are missing (and can/will be added in the future)?
> 
> Yep, that is correct.

Technically, it's not. Multi-channel support will *not* imply that you
are able to put an AP and a client interface on two different channels -
the AP wouldn't work correctly due to being absent when the client
interface is being handled.

I would recommend against a driver allowing such use case since there's
no way to tell the user that it's a stupid idea.

johannes

