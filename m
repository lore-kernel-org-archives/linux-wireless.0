Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:44007 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbYKCH3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:29:18 -0500
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix detection of jumbo frames
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
	<43e72e890811021300o6bef49b0i515d0f72974cef00@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 03 Nov 2008 09:29:00 +0200
In-Reply-To: <43e72e890811021300o6bef49b0i515d0f72974cef00@mail.gmail.com> (ext Luis R. Rodriguez's message of "Sun\, 2 Nov 2008 13\:00\:27 -0800")
Message-ID: <87ljw1b743.fsf@nokia.com> (sfid-20081103_082920_949969_D19CA6E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Trimmed CC list)

Luis R. Rodriguez <lrodriguez@atheros.com> writes:

>>, and, since
>> 63266a653589e1a237527479f10212ea77ce7844 "ath5k: rates cleanup", we do not fall back to the basic rate, such packets would trigger
>> the following WARN_ON:
>
> So its slow because using rate 0 takes a while? If indeed you don't
> see a valid use for this rate I'd say to completely disallow it and
> use BUG_ON() on it.

Please, avoid BUG_ON() at all costs, only use it if the situation
might mean major data corruption or something similar. For users
BUG_ON() is a major grief because there are no visible indication what
has happened.

IMHO wireless drivers should not have BUG_ON() calls at all, WARN_ON()
is enough and much more usable for everyone.

-- 
Kalle Valo
