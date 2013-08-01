Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:33017 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3HAJOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 05:14:09 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf20so572297bkc.7
        for <linux-wireless@vger.kernel.org>; Thu, 01 Aug 2013 02:14:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375342845.8608.8.camel@jlt4.sipsolutions.net>
References: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
	<1375087158-22077-2-git-send-email-michal.kazior@tieto.com>
	<1375342845.8608.8.camel@jlt4.sipsolutions.net>
Date: Thu, 1 Aug 2013 11:14:07 +0200
Message-ID: <CA+BoTQm+rWRRpp6XQ_-YHMBfH0Q4ecZ3z-6TV3cvFZ=8uXWsQA@mail.gmail.com> (sfid-20130801_111426_162218_648A5CE1)
Subject: Re: [RFC 1/3] nl/cfg80211: add chan_time for scan request
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 August 2013 09:40, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2013-07-29 at 10:39 +0200, Michal Kazior wrote:
>
>> + * @NL80211_ATTR_SCAN_CHAN_TIME: Specifies how many msec should a driver spend
>> + *   on each channel during scanning. This is optional and the default is
>> + *   leave the decision up to the driver. This setting may, but preferrably
>
> typo: preferably :)
>
>> + *   shouldn't, be ignored by driver.
>
> This seems a bit iffy - you don't differentiate between active/passive
> scans?

Is there a reason this should be differentiated?


> Also maybe there should be a bit saying "I support scan timing" or even
> the min/max times?

Sounds good. I can add it.


> This also interferes a bit with some other scan optimisations that could
> be done at a low firmware level, so I think we should be careful and
> actually say that this is really more intended for measurement use cases
> and not for normal scans?
>
> Or maybe we should have a separate measurement command with similar
> semantics? This all doesn't seem very clear to me yet :)

Motivation behind this patchset is to simplify ACS implementation and
depend on scan. This also allows easier fallback from survey-based ACS
to BSS-based one.

Other use cases are a side-effect so perhaps clarifying the intent in
the docs is enough.


Pozdrawiam / Best regards,
Micha³ Kazior.
