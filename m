Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:44267 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZIPBR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 21:17:57 -0400
Received: by iwn8 with SMTP id 8so2035726iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2009 18:18:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <90263558.20090916050213@mail.ru>
References: <174470396.20090916030952@mail.ru> <43e72e890909151614l9820e2y7031e09de11653@mail.gmail.com>
	<792649359.20090916034611@mail.ru> <43e72e890909151649x66321b6emdc2977473e22872a@mail.gmail.com>
	<90263558.20090916050213@mail.ru>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 15 Sep 2009 18:17:40 -0700
Message-ID: <43e72e890909151817u375cd847r7cdf78b53f26fe2f@mail.gmail.com>
Subject: Re: Re[4]: cfg80211 and rfkill_backport question.
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: linux-wireless@vger.kernel.org,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2009 at 7:02 PM, Nikolai ZHUBR <zhubr@mail.ru> wrote:
> Wednesday, September 16, 2009, 2:49:04 AM, Luis R. Rodriguez wrote:
>> Check if the symbols you had issues with were indeed exported via
>> EXPORT_SYMBOL() on the compat code (compat/*.c) or if whether they
>> were defined via a header as an inline (compat/*.h).
> As far as I can see, the symbols in question are not defined as inline:

They don't have to be exported and inlined, its one or the other. So
just ensure you your symbols you have conflicts with as
EXPORT_SYMBOL() or defined in a header file as inline. You will
obviously also need the header declaration if defined as an
EXPORT_SYMBOL.

  Luis
