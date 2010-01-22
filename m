Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:2488 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab0AVVDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 16:03:54 -0500
Received: by ey-out-2122.google.com with SMTP id 22so70770eye.5
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 13:03:53 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: avoid NULL ptr deref when using WEP
References: <1264181989-28483-1-git-send-email-linville@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 22 Jan 2010 23:03:50 +0200
In-Reply-To: <1264181989-28483-1-git-send-email-linville@tuxdriver.com> (John W. Linville's message of "Fri\, 22 Jan 2010 12\:39\:49 -0500")
Message-ID: <87636trgw9.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> "mac80211: move control.hw_key assignment" changed an if-else into two
> separate if statments, but the if-else is needed to prevent
> dereferencing a null info->control.hw_key.  This fixes avoids a lock-up
> during association on my machine when using WEP.

Thanks. I was also suffering from this and your patch fixed it.

> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Tested-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
