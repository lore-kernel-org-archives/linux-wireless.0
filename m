Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41268 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0HWXP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 19:15:29 -0400
Received: by iwn5 with SMTP id 5so3934135iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 16:15:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201008222348.25668.chunkeey@googlemail.com>
References: <201008222348.25668.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 Aug 2010 16:15:06 -0700
Message-ID: <AANLkTi=Nb6ZaPZXOA3Rqen+f8QRaqhKgcrYb3S9WQTGO@mail.gmail.com>
Subject: Re: [PATCH] mac80211: cancel restart_work in ieee80211_unregister_hw
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 22, 2010 at 2:48 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> Unlike most other workqueue-tasks, the restart_work is
> not scheduled onto mac80211's private per-interface
> workqueue, but onto one of the system-wide workqueues.
>
> Therefore the mac80211-stack has to cancel any pending
> restarts, before destroying the shared device context
> and handing back the memory. Otherwise - under very
> unlucky circumstances - there could be a stale work-
> item left, because some other kernel component might
> have delayed the execution of ieee80211_restart_work
> for too long.
>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

Is this a stable fix?

 Luis
