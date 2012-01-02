Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48782 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2ABPC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 10:02:29 -0500
Received: by iaeh11 with SMTP id h11so29397842iae.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jan 2012 07:02:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325515471.3643.15.camel@jlt3.sipsolutions.net>
References: <1325162501-7996-1-git-send-email-eliad@wizery.com>
	<1325162501-7996-4-git-send-email-eliad@wizery.com>
	<1325501581.3643.8.camel@jlt3.sipsolutions.net>
	<CAB3XZEfQ87gAPPAf4TO6LRbFtBh3YBRR5DO-oM=YB_BPczyCUA@mail.gmail.com>
	<1325515471.3643.15.camel@jlt3.sipsolutions.net>
Date: Mon, 2 Jan 2012 17:02:29 +0200
Message-ID: <CAB3XZEdXrkG_3caV4TzFrR=3fXk+TSjSLddiyke2npArcWr0pg@mail.gmail.com> (sfid-20120102_160233_183267_7622959E)
Subject: Re: [PATCH v2 3/3] mac80211: add sta_state callback
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 2, 2012 at 4:44 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> if sta_state will be allowed to return an error, instead of adding a
>> new backward compatibility implementation to mac80211 we can just
>> change all the current drivers to register for sta_state(), and
>> operate on auth->assoc and assoc->auth transitions instead of
>> sta_add/sta_remove.
>
> Right, that's the alternative, but it would be easier to add the code in
> mac80211 I think? And if we add a "NOT_EXIST" state we can completely
> make sta_add/sta_remove be only there for drivers that don't need more
> advanced state?
>
oh, so sta_/add/remove and sta_state will be 2 different mechanisms?
now it all looks better.

i guess implementing it in mac80211 is easier. hopefully, most of the
drivers will move to the new model and finally we'll be able to delete
the backward compatibility layer (which is always an annoying thing).

Eliad.
