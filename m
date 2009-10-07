Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49542 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbZJGWoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 18:44:17 -0400
Received: by fxm27 with SMTP id 27so5088071fxm.17
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2009 15:43:40 -0700 (PDT)
Message-ID: <4ACD1998.5020902@lwfinger.net>
Date: Wed, 07 Oct 2009 17:43:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix locking problem when stopping rfkill polling
References: <4accae5d.BgSJpcmlvg+W5PGM%Larry.Finger@lwfinger.net>	 <20091007190106.GB22394@tuxdriver.com>  <4ACCEBE8.8010803@lwfinger.net> <1254955015.3713.9.camel@johannes.local>
In-Reply-To: <1254955015.3713.9.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This is because when stopping polling we need to cancel the work and
> sync on it, but when starting it's completely async so starting can be
> in any context.

Does that mean that start could be moved outside the mutex_lock so
that the start and stop would look symmetrical in b43?

Larry
