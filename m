Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:43386 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbZI2ACF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 20:02:05 -0400
Received: by pxi32 with SMTP id 32so3859103pxi.4
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 17:02:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909201028i119b75c0ic94d07e79e4b7a43@mail.gmail.com>
References: <20090919205545.GA18080@bombadil.infradead.org>
	 <4AB5A5A7.3020107@canonical.com>
	 <43e72e890909200743h74934657nc056c9e6dcb14e90@mail.gmail.com>
	 <4AB65CFE.7090101@canonical.com>
	 <43e72e890909201028i119b75c0ic94d07e79e4b7a43@mail.gmail.com>
Date: Mon, 28 Sep 2009 17:02:08 -0700
Message-ID: <45e8e6c40909281702i2e5497e7l3a6492151f506ce5@mail.gmail.com>
Subject: Re: [RFC] compat-2.6: mangle symbols for driver-select
From: Andrey Yurovsky <andrey@cozybit.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: tim.gardner@canonical.com, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On a side note, the compat-wireless name mangling will help with
another problem:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/249186

...this happens because compat-wireless builds a version of the usbnet
module but then there are Ethernet dongles (ex: asix) that rely on the
stock version of usbnet (they aren't updated by compat-wireless) and
the user gets a symbols mismatch as a result.  This won't be an issue
if compat-wireless' usbnet has mangled names for its symbols.

  -Andrey
