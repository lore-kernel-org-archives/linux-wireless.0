Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaEGJBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:01:19 -0400
Message-ID: <1399453264.10517.6.camel@jlt4.sipsolutions.net> (sfid-20140507_110124_609585_934B7914)
Subject: Re: How to configure monitor devices for HT80?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 07 May 2014 11:01:04 +0200
In-Reply-To: <53692240.5010001@candelatech.com>
References: <5367E13C.2020208@candelatech.com>
	  (sfid-20140505_211155_884363_141E505C) <1399317771.22235.23.camel@jlt4.sipsolutions.net>
	 <53692240.5010001@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-06 at 10:56 -0700, Ben Greear wrote:

> But, it seems if I have another vif up, it will fail, even if that
> vif is (should be?) using the exact same frequency.
> 
> ./local/sbin/iw phy wiphy0 interface add moni0 type monitor
> ./local/sbin/ip link set dev moni0 up
> ./local/sbin/iw dev moni0 set freq 5180 80 5210
> -> yields error:
> command failed: Device or resource busy (-16)

You can't set the monitor frequency if you're using the hardware for
something else already. We could potentially allow that if the chandefs
are compatible, but that's getting into really messy territory so I'm
not sure I want to go there - if for example the other interface
switches bandwidth or even channel the monitor would usually simply
follow around.

johannes

