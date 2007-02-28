Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:60163 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXB1P5z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 10:57:55 -0500
Received: by nf-out-0910.google.com with SMTP id o25so594731nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 07:57:53 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 14/28] rt2x00: Create rt2x00lib module
Date: Wed, 28 Feb 2007 16:57:49 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.13004.IvDoorn@gmail.com> <200702281643.13490.IvDoorn@gmail.com> <1172677754.5015.24.camel@johannes.berg>
In-Reply-To: <1172677754.5015.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281657.50102.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 16:49, Johannes Berg wrote:
> On Wed, 2007-02-28 at 16:43 +0100, Ivo van Doorn wrote:
> 
> > Nothing depended on RT2X00_LIB, I only had the drivers select RT2X00_LIB.
> > So something has changed or I am missing something. ;)
> 
> No, I found what's up.
> 
> You need to change it to
> 
> config RT2X00_LIB
>         tristate
>         depends on RT2X00
> 
> (note that it has no human-readable name)

Ah ok. Thanks.

> Btw. It appears that you can build debugfs support as a module while
> drivers are built in. Not good.

Thanks for the tip. I'll try to fix this.

Both things will end up in a new patch which I will send as soon as I have that
debugfs config option fixed. :)

Ivo
