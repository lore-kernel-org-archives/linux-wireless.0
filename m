Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35906 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab0KLUJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 15:09:01 -0500
Received: by iwn10 with SMTP id 10so3862935iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 12:09:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289592426-5367-1-git-send-email-greearb@candelatech.com>
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 12 Nov 2010 12:08:40 -0800
Message-ID: <AANLkTin_qaMO+3Zm3qnqZ2WDjLoujvCa0W2eLO1BT_Ti@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Fix deadlock in ieee80211_do_stop.
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 12, 2010 at 12:07 PM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> We cannot call flush_work here because we are holding
> RTNL and the worker thread(s) that will be called upon to
> do the flushing might already be running a piece of work
> that is blocking on RTNL.  That leads to deadlock and/or
> OOM.
>
> The ieee80211_iface_work method does nothing when sdata
> is stopped (as it would be when the flush_work was called)
> so it shouldn't be any big change to just cancel the work
> entirely.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Is this a stable fix?

  Luis
