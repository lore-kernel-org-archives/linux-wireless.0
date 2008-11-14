Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:3283 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbYKNXFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 18:05:37 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1639797wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 15:05:36 -0800 (PST)
Message-ID: <b6c5339f0811141505u1f8c7c3hd6858ebe21cc10bb@mail.gmail.com> (sfid-20081115_000558_202777_7D8B99BC)
Date: Fri, 14 Nov 2008 18:05:36 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] mac80211: don't assume driver has been attached on registration
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1226702662-29694-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1226702662-29694-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 5:44 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> mac80211's ieee80211_register_hw() is often called within the
> probe path so it cannot assume the device's driver structure
> has been attached yet so to create a workqueue instead of
> using driver->name use the wiphy's phy%d name. The name doesn't
> really matter anyway.
>
> This should fix sporadic oopses found when we race to beat the
> driver pointer setting. Not even sure how this was working properly.

I'd still like to identify the race first.  This patch won't hurt
anything, but I'm not confident it will solve any problem either (the
pci_dev->driver setting I was seeing after probe was for a different
struct driver).  Also it could make the bug harder to track down.

In the reported case, wiphy_name will be empty string which isn't too
helpful for the workqueue name either, though it probably won't crash.

-- 
Bob Copeland %% www.bobcopeland.com
