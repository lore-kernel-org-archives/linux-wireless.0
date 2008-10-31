Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:48308 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbYJaWBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 18:01:45 -0400
Received: by nf-out-0910.google.com with SMTP id d3so661545nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 15:01:42 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: crash with rt61pci when resuming with card ejected
Date: Fri, 31 Oct 2008 23:01:39 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1225361553.3690.3.camel@johannes.berg> <200810312031.03314.IvDoorn@gmail.com> <1225489644.3550.0.camel@johannes.berg>
In-Reply-To: <1225489644.3550.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810312301.39373.IvDoorn@gmail.com> (sfid-20081031_230151_744945_3465F1EF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 October 2008, Johannes Berg wrote:
> On Fri, 2008-10-31 at 20:31 +0100, Ivo van Doorn wrote:
> 
> > Hmm, it looks like CSR base is NULL, after which the H2M_MAILBOX_CSR
> > offset is added to it (0x2100)
> > 
> > The strange part is thet CSR is freed and set to NULL _after_ the
> > rt2x00lib_remove_dev() call...
> > Oh wait never mind, I get the picture, I missed the "ejected _while_ suspended"
> > part. I think what is happening is that first the suspend handler is called,
> > and during resume not the resume handler but the remove handler is running,
> > and rt2x00 doesn't protect against that.
> > 
> > Could you check if below patch does the trick? If I am not mistaken only the
> > LED handler actually accesses the hardware to make sure they are off.
> 
> Now it crashes in config_pairwise_key or something like that, I can send
> you the image if you want.

No need. :)
I assume mac80211 calls set_key() to disable all hardware keys when
ieee80211_unregister_hw() is being called. I'll cook up a patch to catch
that as well.

Ivo

