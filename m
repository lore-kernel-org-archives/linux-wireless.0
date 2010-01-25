Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:58810 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0AYWKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 17:10:11 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix sw crypto
Date: Mon, 25 Jan 2010 23:09:48 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jochen Friedrich <jochen@scram.de>
References: <1264415776.23766.34.camel@johannes.local>
In-Reply-To: <1264415776.23766.34.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201001252309.48260.rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 25 January 2010 11:36:16 Johannes Berg wrote:

> What a stupid mistake. In
> 
>     commit 813d76694043d00b59475baa1fbfaf54a2eb7fad
>     Author: Johannes Berg <johannes@sipsolutions.net>
>     Date:   Sun Jan 17 01:47:58 2010 +0100
> 
>         mac80211: move control.hw_key assignment
> 
> I inserted code testing the wrong flags field,
> which means that the test is almost always true
> (it's really testing for the peer's WMM support)
> and thus the later parts of the stack assume hw
> crypto will be done even if that's not true.
> 
> Obviously, that broke software crypto. Maxim
> said so specifically, and Jochen probably uses
> some cipher that iwl3945 doesn't support in
> hardware, which might also explain that Maxim
> reports that even hw crypto is broken.
> 
> Fix this to test the right flags field.
> 

Tested-by: Fabio Rossi <rossi.f@inwind.it>

