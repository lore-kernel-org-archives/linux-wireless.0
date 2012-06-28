Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37245 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab2F1Ihz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 04:37:55 -0400
Received: by dady13 with SMTP id y13so2568281dad.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 01:37:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340871433.4491.20.camel@jlt3.sipsolutions.net>
References: <1340821557-27009-1-git-send-email-arik@wizery.com> <1340871433.4491.20.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 28 Jun 2012 11:37:38 +0300
Message-ID: <CA+XVXfdKLeaHpLmqsXROH9VojHkB4EP-BpcFDLb8ZCtjb_XCbQ@mail.gmail.com> (sfid-20120628_103800_689018_D30770F9)
Subject: Re: [PATCH] mac80211: allow Rx in reconfig only after removing BA sessions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 28, 2012 at 11:17 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-06-27 at 21:25 +0300, Arik Nemtsov wrote:
>> Previously, a connected STA/AP could send us some AMPDUs right after
>> recovery, without the driver knowing anything about it.
>
> Huh, that description doesn't make a lot of sense? The STA/AP can send
> us AMPDUs anyway without the driver knowing anything about it since it
> has no idea we're restarting ...

Well the point is to drop them early in the Rx path. Should I change
the description or you don't like the patch in general?
