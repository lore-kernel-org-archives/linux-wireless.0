Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42680 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757535AbcLOJ5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 04:57:44 -0500
Message-ID: <1481795860.2582.2.camel@sipsolutions.net> (sfid-20161215_105749_820154_BBD6E627)
Subject: Re: [PATCH] mac80211: only alloc mem if a station doesnt exist yet
From: Johannes Berg <johannes@sipsolutions.net>
To: Koen Vandeputte <koen.vandeputte@ncentric.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Dec 2016 10:57:40 +0100
In-Reply-To: <1481732939-8237-1-git-send-email-koen.vandeputte@ncentric.com> (sfid-20161214_172943_690139_0107B3BF)
References: <1481732939-8237-1-git-send-email-koen.vandeputte@ncentric.com>
         (sfid-20161214_172943_690139_0107B3BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-12-14 at 17:28 +0100, Koen Vandeputte wrote:
> This speeds up the function in case a station already exists by
> avoiding
> calling an expensive kzalloc just to free it again after the next
> check.

It's not like this is called often, but yeah - still makes sense.

Applied.

johannes
