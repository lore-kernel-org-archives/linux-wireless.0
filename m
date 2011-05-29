Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:13039 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab1E2UlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 16:41:09 -0400
Date: Sun, 29 May 2011 22:42:00 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-2.6] rt2x00: fix rmmod crash
Message-ID: <20110529204200.GA2472@localhost.localdomain> (sfid-20110529_224113_588219_A9890B82)
References: <20110529104529.GA2769@localhost.localdomain>
 <4DE278CD.3030708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DE278CD.3030708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 29, 2011 at 06:48:13PM +0200, Gertjan van Wingerde wrote:
> On 05/29/11 12:45, Stanislaw Gruszka wrote:
> > Do not destroy workqueue, which still can be used by autowakeup_work,
> > before ieee80211_unregister_hw() is called.
> > 
> > Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> 
> Could you add some details of the crash here, e.g. the stack trace of when this occurs, so that
> we can understand what is exactly happening that is causing the crash, for our education.

Crash is in workqueue code in interrupt context, there is no indication about rt2x00 blame in
the calltrace, but crash happen directly after rmmod rt73usb, here is a photo:
https://bugzilla.kernel.org/attachment.cgi?id=59992 

Stanislaw
