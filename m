Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40272 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1BNVUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 16:20:22 -0500
Received: by bwz15 with SMTP id 15so5917447bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 13:20:21 -0800 (PST)
Date: Tue, 15 Feb 2011 00:20:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	gregkh@suse.de, linux-wireless@vger.kernel.org, s@fomichev.me
Subject: Re: [PATCH] brcm80211: remove multiple calls to wl_release_fw
Message-ID: <20110214212005.GL4384@bicker>
References: <20110212150033.GA1941@sdf-MacBook>
 <4D598993.4020900@broadcom.com>
 <20110214202249.GK4384@bicker>
 <20110214210755.GB26387@sdf-MacBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110214210755.GB26387@sdf-MacBook>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 12:07:55AM +0300, Stanislav Fomichev wrote:
> > This patch isn't right.  It fixes the oops but it introduces some leaks.
> > (We still need to release firmware that was allocated successfully).
> Sorry Dan, but where do you see the leaks? We make a call to
> wl_request_fw and if returns non-zero call wl_release_fw for a cleanup.
> 
> I just removed the call to wl_release_fw in the wl_request_fw itself; so
> it should not introduce any leak.
> 
> Could you pls clarify?

Ah.  Right.  I see what you're saying.  Your patch looks good to me.

regards,
dan carpenter 

