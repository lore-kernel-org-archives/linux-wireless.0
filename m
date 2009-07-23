Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:51571 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZGWKqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:46:49 -0400
Received: by bwz28 with SMTP id 28so725286bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:46:47 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/7] mac80211: Replace {sw, hw}_scanning variables with a bitfield
Date: Thu, 23 Jul 2009 12:46:55 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20090723100732.5147.73989.stgit@localhost.localdomain> <20090723101403.5147.55273.stgit@localhost.localdomain> <1248345497.19121.22.camel@johannes.local>
In-Reply-To: <1248345497.19121.22.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907231246.56210.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 23. Juli 2009 schrieb Johannes Berg:
> On Thu, 2009-07-23 at 12:14 +0200, Helmut Schaa wrote:
> > Use a bitfield to store the current scan mode instead of two boolean
> > variables {sw,hw}_scanning. This patch does not introduce functional
> > changes but allows us to enhance the scan flags later (for example
> > for background scanning).
> 
> > +			if (test_bit(SCAN_SW_SCANNING, &local->scanning))
> 
> Do we actually need atomic bitops?

No (at least not yet). That's why I used __set_bit. test_bit seems to not
have a non-atomic equivalent. Or did you mean not to use *_bit functions
at all?

Helmut
