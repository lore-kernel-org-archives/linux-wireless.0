Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:17447 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYGDMoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 08:44:55 -0400
Received: by nf-out-0910.google.com with SMTP id d3so364719nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 05:44:53 -0700 (PDT)
To: drago01 <drago01@gmail.com>
Subject: Re: [PATCH 1/4] rt2x00: Remove input_polldev requirements for rfkill
Date: Fri, 4 Jul 2008 14:50:57 +0200
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807041341.26003.IvDoorn@gmail.com> <f6ca9fed0807040517o708c5e4ap4e5e9d9d0d61ee83@mail.gmail.com>
In-Reply-To: <f6ca9fed0807040517o708c5e4ap4e5e9d9d0d61ee83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807041450.57740.IvDoorn@gmail.com> (sfid-20080704_144458_788957_58568C82)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 July 2008, drago01 wrote:
> On Fri, Jul 4, 2008 at 1:41 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > With the new rfkill interface there is no longer a need
> > for the input_polldev. Create a delayed_work structure
> > which we can put on the mac80211 workqueue and poll the
> > hardware every 100ms.
> 
> Isn't 100ms not a bit "to often" ... this would add 10 wakeups/sec ..
> Shouldn't 500 or 1000ms be enough for user space to deal with the event?

Ok, I'll update the patch to restore the once-per-second check.

Ivo
