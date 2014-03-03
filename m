Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45328 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaCCQX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 11:23:26 -0500
Received: by mail-ee0-f54.google.com with SMTP id d49so900442eek.13
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2014 08:23:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140303154327.1290.67278.stgit@potku.adurom.net>
References: <20140303154327.1290.67278.stgit@potku.adurom.net>
Date: Mon, 3 Mar 2014 17:23:24 +0100
Message-ID: <CA+BoTQmQndikH5uPDwBpstp9KmcD3tmHSGP5NpEreYEOtRm0sw@mail.gmail.com> (sfid-20140303_172332_721364_B3AB0D1A)
Subject: Re: [PATCH] ath10k: unify warning messages in mac.c
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 March 2014 16:43, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Currently there are different styles used for warning messages, unify them to
> look similar.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---

[...]

This still seems inconsistent. I also don't like the capital letters
(even for abbreviations) in these kind of messages, but that's just my
OCD..

I think we should agree on one of the two approaches:

a) start with a verb:

"failed to add peer %pM on vdev %i: %d"
"failed to initialize dfs pattern detector"
"timed out while waiting for scan completion"

b) start with a noun:

"peer %pM on vdev %i could not be added: %d"
"dfs pattern detector could not initialize"
"scan timed out"

These are still mixed.

We could probably also limit the set of verbs, e.g. replace "could
not" with "failed to" as it's practically the same thing (assuming we
pick (a)).

But then again, feel free to ignore my OCD :-)


Michał
