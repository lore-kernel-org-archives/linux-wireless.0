Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f12.google.com ([209.85.217.12]:53992 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYKBVA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 16:00:29 -0500
Message-ID: <43e72e890811021300o6bef49b0i515d0f72974cef00@mail.gmail.com> (sfid-20081102_220035_250819_F359EAF9)
Date: Sun, 2 Nov 2008 13:00:27 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix detection of jumbo frames
Cc: linville@tuxdriver.com, mickflemm@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linux-kernel@vger.kernel.org, michael+ath5k@stapelberg.de
In-Reply-To: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 2, 2008 at 11:08 AM, Bob Copeland <me@bobcopeland.com> wrote:

Nice find.

> Then, because the hw rate value of such frames is zero

BTW I believe frames should not go out at hw rate value 0, I did some
test a while back on this rate and its not exactly reliable, you will
get very funky behavior on it. Are you seeing that rate being used on
legacy-hal? Last I asked about it too its not something people know
about as being desired effect. I could be wrong but it'd be
interesting to see where this is used correctly.

>, and, since
> 63266a653589e1a237527479f10212ea77ce7844 "ath5k: rates cleanup", we do not fall back to the basic rate, such packets would trigger
> the following WARN_ON:

So its slow because using rate 0 takes a while? If indeed you don't
see a valid use for this rate I'd say to completely disallow it and
use BUG_ON() on it.

  Luis
