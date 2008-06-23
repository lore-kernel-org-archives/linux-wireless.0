Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:33849 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYFWCRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 22:17:48 -0400
Received: by an-out-0708.google.com with SMTP id d40so539076and.103
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 19:17:47 -0700 (PDT)
Date: Sun, 22 Jun 2008 22:17:14 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 11/12] rfkill: do not allow userspace to override ALL
	RADIOS OFF
Message-ID: <20080623021714.GB24992@anvil.corenet.prv> (sfid-20080623_041752_475192_EF522698)
References: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br> <1214149128-5913-12-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214149128-5913-12-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

On Sun, Jun 22, 2008 at 12:38:47PM -0300, Henrique de Moraes Holschuh wrote:
> SW_RFKILL_ALL is the "emergency power-off all radios" input event.  It must
> be handled, and must always do the same thing as far as the rfkill system
> is concerned: all transmitters are to go *immediately* offline.
> 
> For safety, do NOT allow userspace to override EV_SW SW_RFKILL_ALL OFF.  As
> long as rfkill-input is loaded, that event will *always* be processed, and
> it will *always* force all rfkill switches to disable all wireless
> transmitters, regardless of user_claim attribute or anything else.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>

rfkill_event() is called with handle->dev.event_lock spinlock held and
therefore can not sleep. rfkill_epo() takes rfkill mutex and may sleep
so it can't be used in the interrupt context. That is the reason why
we had tasks for switching rf switches in the first place.

-- 
Dmitry
