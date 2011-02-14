Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34734 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1BNUXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 15:23:08 -0500
Received: by bwz15 with SMTP id 15so5862907bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 12:23:07 -0800 (PST)
Date: Mon, 14 Feb 2011 23:22:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: s@fomichev.me, gregkh@suse.de,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: remove multiple calls to wl_release_fw
Message-ID: <20110214202249.GK4384@bicker>
References: <20110212150033.GA1941@sdf-MacBook>
 <4D598993.4020900@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D598993.4020900@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 02/12/2011 04:00 PM, Stanislav Fomichev wrote:
> >This causes an oops when the bcm43xx_hdr-0.fw binary is not found.
> >

This patch isn't right.  It fixes the oops but it introduces some leaks.
(We still need to release firmware that was allocated successfully).

regards,
dan carpenter
