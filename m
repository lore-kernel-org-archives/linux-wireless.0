Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:46521 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0AEQOP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 11:14:15 -0500
Received: by iwn32 with SMTP id 32so895827iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 08:14:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1262683554.20098.10.camel@johannes.local>
References: <1262622502-27698-1-git-send-email-lrodriguez@atheros.com>
	<1262683554.20098.10.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 5 Jan 2010 08:13:52 -0800
Message-ID: <43e72e891001050813n5f5cd0bfp7e703902d3979158@mail.gmail.com>
Subject: Re: [RFC] cfg80211: add regulatory hint disconnect support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 5, 2010 at 1:25 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2010-01-04 at 11:28 -0500, Luis R. Rodriguez wrote:
>
>> +/**
>> + * regulatory_hint_disconnect - informs all devices have been
>> disconneted
>
> disconnected
>
>> + *
>> + * Regulotory rules can be enhanced further upon scanning and upon
>
> Regulatory
>
>> + * connection to an AP. These rules become stale if we disconnect
>> + * and go to another country, whether or not we suspend and resume.
>> + * If we suspend, go to another country and resume we'll
>> automatically
>> + * get disconnected shortly after resuming and things will be reset
>> as well.
>> + * This routine is a helper to restore regulatory settings to how
>> they were
>> + * prior to our first connect attempt. This includes ignoring country
>> IE and
>> + * beacon regulatory hints. The ieee80211_regdom module parameter
>> will always
>> + * be respected but if a user had set the regulatory domain that will
>> take
>> + * precedence.
>> + *
>> + * Must be called from process context and hold the cfg80211_mutex.
>> + */
>
> However, I don't quite understand why we need this function. We already
> tell cfg80211 about disconnect events or requests, can't it call some
> regulatory update when either of those two happen?

Sure, hence the RFC, can you point me to those events?

  Luis
