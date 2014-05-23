Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36666 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbaEWHEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 03:04:34 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so4414586wgg.30
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 00:04:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400770624.4174.36.camel@jlt4.sipsolutions.net>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	<1400767676-15994-7-git-send-email-michal.kazior@tieto.com>
	<1400770624.4174.36.camel@jlt4.sipsolutions.net>
Date: Fri, 23 May 2014 09:04:32 +0200
Message-ID: <CA+BoTQ=-swYkLOMdYVgH8DfCZwzScLmHJ9bw7MF+woXoQfy8ug@mail.gmail.com> (sfid-20140523_090437_074288_3CD80BD7)
Subject: Re: [PATCH v6 6/6] cfg80211: remove channel_switch combination check
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2014 16:57, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-22 at 16:07 +0200, Michal Kazior wrote:
>> Make the driver responsible for making sure it is
>> capable of performing the switch. It might as well
>> accept a request but then disconnect an interface
>> if some requirements are not met.
>
> Care to elaborate? I'd really like to avoid this case as much as
> possible, so just mentioning here that it would be valid seems like a
> bad idea.

Well, CSA isn't really visible to cfg80211 so you can't enforce anything now.

Also since CSA requests are submitted one-by-one you already break
interface combinations and hope:
 a) userspace sends more CSA requests soon enough to make future
interface combination valid
 b) trust drivers deal with it either way

So why bother?

The most you can probably do is to prevent CSA requests from switching
to too many different channels but you can easily guarantee this in a
driver.


Michal
