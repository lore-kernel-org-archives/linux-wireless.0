Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:46198 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZIXJuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 05:50:13 -0400
Received: by iwn8 with SMTP id 8so804046iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 02:50:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909241119.28207.hs4233@mail.mn-solutions.de>
References: <200909241055.51604.hs4233@mail.mn-solutions.de>
	<43e72e890909240159x6d733e1bj9c529f6fe77b32f5@mail.gmail.com>
	<200909241119.28207.hs4233@mail.mn-solutions.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 24 Sep 2009 02:44:46 -0700
Message-ID: <43e72e890909240244i2d5e4c2sdf6326b50566e0f7@mail.gmail.com>
Subject: Re: [PATCH]: nl80211: report age of scan results
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 2:19 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> On Thursday 24 September 2009 10:59:57 Luis R. Rodriguez wrote:
>> Wil want to #define NL80211_BSS_AGE_MS NL80211_BSS_AGE_MS as
>> well so userspace apps can ifdef around that feature to know if
>> its supported.
>
> Nice idea.
>
> That could be a different patch. I haven't seen it for anything
> else, e.g. there's no "#define NL80211_BSS_STATUS" anywhere.

Typically a command went in with a set of attributes, I tend to only
add a define for a new command, and then for any new attributes after
that in later patches for the same command.

> "iw" for example has it's own nl80211.h file.

Yes, but not all apps may ship their own ni80211.h, we probably will
be implementing then, but yeah -- we cannot enforce this, only
recommend it.

  Luis
