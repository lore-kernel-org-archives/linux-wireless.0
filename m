Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37564 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1C3SZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 14:25:20 -0400
Received: by vws1 with SMTP id 1so1250513vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 11:25:19 -0700 (PDT)
Message-ID: <4D93758B.1020104@lwfinger.net>
Date: Wed, 30 Mar 2011 13:25:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.39-rc1] b43: allocate receive buffers big enough for
 max frame len + offset
References: <1301508166-7692-1-git-send-email-linville@tuxdriver.com> <AANLkTikv+Mpb_P0mDqL1QGWJSynp5U5K+quGxUbuFwRk@mail.gmail.com>
In-Reply-To: <AANLkTikv+Mpb_P0mDqL1QGWJSynp5U5K+quGxUbuFwRk@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2011 01:12 PM, Rafał Miłecki wrote:
> 2011/3/30 John W. Linville<linville@tuxdriver.com>:
>> Otherwise, skb_put inside of dma_rx can fail...
>
> What would happen then? Of course we wouldn't receive packet, but
> would we get some warning? Could this be reason of memory leak with
> some firmware versions?

You get an skb_over_panic. See 
https://bugzilla.kernel.org/show_bug.cgi?id=32042. I do not think a memory leak 
is likely.

John: The commit message should mention this as a fix for Bug #32042. In 
addition, it should Cc: stable.

Larry
