Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:54172 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab1HPR6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 13:58:52 -0400
Received: by iye16 with SMTP id 16so250961iye.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2011 10:58:52 -0700 (PDT)
Date: Tue, 16 Aug 2011 20:56:42 +0300
From: Dan Carpenter <error27@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 01/14] staging: brcm80211: use wait queues instead of
 semaphores in wl_cfg80211.c
Message-ID: <20110816175641.GE26027@shale.localdomain> (sfid-20110816_195855_642077_D21B77C3)
References: <1313156101-16817-2-git-send-email-arend@broadcom.com>
 <1313175933-4323-1-git-send-email-arend@broadcom.com>
 <4E457A0B.2090707@broadcom.com>
 <4E457A6B.8020802@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E457A6B.8020802@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2011 at 09:09:31PM +0200, Arend van Spriel wrote:
> 
> Or have people vote which version they prefer. I prefer v2.
> 

It doesn't really matter either way, but I prefer the original one.

Checkpatch.pl only cares about if statements.  This is fairly
idiomatic C.  After all we wouldn't write a while statement like:

	foo = some_func();
	while (foo) {
		frob();
		frob();
		foo = some_func();
	}

We'd just write:
	while ((foo = some_func())) {
		frob();
		frob();
	}

And do while() feels the same to me.

regards,
dan carpenter

