Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48023 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1BNVIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 16:08:01 -0500
Received: by bwz15 with SMTP id 15so5906042bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 13:08:00 -0800 (PST)
Date: Tue, 15 Feb 2011 00:07:55 +0300
From: Stanislav Fomichev <kernel@fomichev.me>
To: Dan Carpenter <error27@gmail.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	gregkh@suse.de, linux-wireless@vger.kernel.org, s@fomichev.me
Subject: Re: [PATCH] brcm80211: remove multiple calls to wl_release_fw
Message-ID: <20110214210755.GB26387@sdf-MacBook>
References: <20110212150033.GA1941@sdf-MacBook>
 <4D598993.4020900@broadcom.com>
 <20110214202249.GK4384@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110214202249.GK4384@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This patch isn't right.  It fixes the oops but it introduces some leaks.
> (We still need to release firmware that was allocated successfully).
Sorry Dan, but where do you see the leaks? We make a call to
wl_request_fw and if returns non-zero call wl_release_fw for a cleanup.

I just removed the call to wl_release_fw in the wl_request_fw itself; so
it should not introduce any leak.

Could you pls clarify?

-- 
	Stas
