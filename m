Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48627 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1HHIkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 04:40:36 -0400
Received: by gwaa12 with SMTP id a12so454584gwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 01:40:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312792163.4372.5.camel@jlt3.sipsolutions.net>
References: <1311675508-29005-2-git-send-email-helmut.schaa@googlemail.com>
	<1312537579-18950-1-git-send-email-helmut.schaa@googlemail.com>
	<1312792163.4372.5.camel@jlt3.sipsolutions.net>
Date: Mon, 8 Aug 2011 10:40:35 +0200
Message-ID: <CAGXE3d9EwS8wMZRYUxAz5FqiTzRZiAATmOcWaG17vbcqryH7ZQ@mail.gmail.com> (sfid-20110808_104039_865571_BE3915F3)
Subject: Re: [PATCHv2 2/2] mac80211: Don't use a buf_size=0 in ADDBA requests
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 8, 2011 at 10:29 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> So, are you saying the problem with getting 0 in replies is solved by
> not sending 0 in requests?

This specific device always replies with a buf_size=0 _if_ we send an
ADDBA request
with a buf_size=0.

The first patch in this series solves a problem were mac80211 would
buffer frames to
this STA forever when the ADDBA response contains a buf_size=0 since the BA
session is stuck in an intermediate state.

However, the AVM Fritz Stick N client behaves correctly if we're using
a buf_size != 0
in the ADDBA request. This is a bug in the Fritz Stick Windows driver
(it should use
the default size of its rx reorder buffer if the ADDBA request
contains 0). However, this
bug can be worked around by using a buf_size != 0 in ADDBA requests. And that's
what the second patch does.

Hope this clarifies my intention :)

Helmut
