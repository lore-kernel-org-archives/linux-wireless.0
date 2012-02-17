Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56112 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2BQXmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 18:42:35 -0500
Received: by iacb35 with SMTP id b35so5029288iac.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2012 15:42:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329472019-28688-1-git-send-email-coelho@ti.com>
References: <1329472019-28688-1-git-send-email-coelho@ti.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 17 Feb 2012 15:42:15 -0800
Message-ID: <CAB=NE6VhbcaBAyNvp=YAvS7oiekzV9t_wOD0q2DfbHx7bhFhaA@mail.gmail.com> (sfid-20120218_004239_122430_3B93A328)
Subject: Re: [PATCH] compat: move skb_complete_wifi_ack() function to compat-3.2.h
To: Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 17, 2012 at 1:46 AM, Luciano Coelho <coelho@ti.com> wrote:
> It seems that the skb_complete_wifi_ack() function was introduced in
> 3.2-rc2.  So the dummy implementation of this function in compat
> should not be in compat-3.3.h anymore, but in compat-3.2.h.
>
> Signed-off-by: Luciano Coelho <coelho@ti.com>

I get different results.

mcgrof@tux ~/linux-stable (git::linux-3.2.y)$ git describe
v3.2.6
mcgrof@tux ~/linux-stable (git::linux-3.2.y)$ git grep skb_complete_wifi_ack ./

To help with this I've documented the mechanisms I use to track down
functionality into the new shiny compat page:

http://mcgrof.github.com/compat/

Please refer to the section, "Tacking down when a feature went
upstream" on the wiki, unfortunately Github is not producing Table of
Contents for me though so I can just refer to the section by name.

Perhaps the kernel you are using is a distro kernel that added this
functionality on top of the vanilla kernel ? Can you provide some
description of how you determine this belongs to compat-3.2.h ?

  Luis
