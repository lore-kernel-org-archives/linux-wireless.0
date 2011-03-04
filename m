Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62335 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996Ab1CDTCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 14:02:35 -0500
Received: by vxi39 with SMTP id 39so2282291vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 11:02:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299238580.4348.5.camel@jlt3.sipsolutions.net>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
 <1299208307-9428-6-git-send-email-thomas@cozybit.com> <1299238580.4348.5.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 4 Mar 2011 11:01:59 -0800
Message-ID: <AANLkTintngisxbaP1P+fJo4_jhWtrzJhSXmLHMGfMotH@mail.gmail.com>
Subject: Re: [PATCH 5/7] nl80211: Let userspace set the authenticated flag for
 a mesh peer
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 4, 2011 at 3:36 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:
>> From: Javier Cardona <javier@cozybit.com>
>
> [snip (maybe more changelog would be nice)]
>
> So .. a more "traditional" approach, like we do in AP, would be to let
> userspace manage the lifetime of STA entries in this case. In managed
> mode, we don't, but there mac80211 currently handles the authentication.
>
> I think you should explore doing mesh more like the AP case. OTOH, I
> don't know how the managed case with SAE would work.

I see.  Instead of setting the AUTH flag, just create the station.  We
would like to do this only for secure meshes, and continue letting the
kernel manage mesh peers for "open" meshes without the need of
userspace intervention.  We can certainly do it like you suggest, yes.


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
