Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:36511 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaAUGHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 01:07:20 -0500
Received: by mail-bk0-f45.google.com with SMTP id v16so2821061bkz.18
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 22:07:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390254081.13064.2.camel@porter.coelho.fi>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	<1390227670-19030-7-git-send-email-michal.kazior@tieto.com>
	<1390254081.13064.2.camel@porter.coelho.fi>
Date: Tue, 21 Jan 2014 07:07:19 +0100
Message-ID: <CA+BoTQnXLybHGuttQHBpFyU_KBwUGi7_j7DA8J2Y1CdkatmcCA@mail.gmail.com> (sfid-20140121_070724_975183_DEE17ED7)
Subject: Re: [PATCH 6/7] mac80211: deny attempts at using chanctx during CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 January 2014 22:41, Luca Coelho <luca@coelho.fi> wrote:
> On Mon, 2014-01-20 at 15:21 +0100, Michal Kazior wrote:
>> It was possible to connect STA when AP CSA was in
>> progress which clearly was a bug.
>
> I understand that preventing this simplifies things, but I don't think
> it's a bug.  If the CSA process takes a long time (ie. several TBTTs),
> why not let a new STA associate meanwhile? The new STA knows when to
> switch, since it can see the count in the beacons (and probe_responses).

This patch prevents a station interface from connecting/associating
somewhere. It does not prevent a station from connecting to your AP
while it's in CSA. I probably should rephrase the commit message to
make it clear.


Michał
