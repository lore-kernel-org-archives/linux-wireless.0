Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43834 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaCCQkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 11:40:36 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: unify warning messages in mac.c
References: <20140303154327.1290.67278.stgit@potku.adurom.net>
	<CA+BoTQmQndikH5uPDwBpstp9KmcD3tmHSGP5NpEreYEOtRm0sw@mail.gmail.com>
Date: Mon, 3 Mar 2014 18:40:22 +0200
In-Reply-To: <CA+BoTQmQndikH5uPDwBpstp9KmcD3tmHSGP5NpEreYEOtRm0sw@mail.gmail.com>
	(Michal Kazior's message of "Mon, 3 Mar 2014 17:23:24 +0100")
Message-ID: <8761nv44nd.fsf@kamboji.qca.qualcomm.com> (sfid-20140303_174039_540153_F53F50E7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 3 March 2014 16:43, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Currently there are different styles used for warning messages, unify them to
>> look similar.
>>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>
> [...]
>
> This still seems inconsistent.

Sure. What I did here was that I just capitalised them messages and made
sure that return code is printed in format ": %d\n".

> I also don't like the capital letters (even for abbreviations) in
> these kind of messages, but that's just my OCD..

I'm fine with starting a lower case letter. For me most important is
that the messages follow the same style.

> I think we should agree on one of the two approaches:
>
> a) start with a verb:
>
> "failed to add peer %pM on vdev %i: %d"
> "failed to initialize dfs pattern detector"
> "timed out while waiting for scan completion"
>
> b) start with a noun:
>
> "peer %pM on vdev %i could not be added: %d"
> "dfs pattern detector could not initialize"
> "scan timed out"
>
> These are still mixed.
>
> We could probably also limit the set of verbs, e.g. replace "could
> not" with "failed to" as it's practically the same thing (assuming we
> pick (a)).

That's true. I would vote for option (a).

> But then again, feel free to ignore my OCD :-)

Hehe, I had to even google that :)

-- 
Kalle Valo
