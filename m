Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61352 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1H3WY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 18:24:59 -0400
Received: by qyk34 with SMTP id 34so103646qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 15:24:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314740334-10341-1-git-send-email-s.neumann@raumfeld.com>
References: <20110830191437.GC2660@tuxdriver.com> <1314740334-10341-1-git-send-email-s.neumann@raumfeld.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Aug 2011 15:24:38 -0700
Message-ID: <CAB=NE6VpPeTKxQrWsVKfAjJgDADSxqfEQyLRcSQ3dYMpt7jS5w@mail.gmail.com> (sfid-20110831_002503_546467_68BA20DC)
Subject: Re: [PATCH 1/2] cfg80211: hold reg_mutex when updating regulatory
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Mack <daniel@zonque.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 2:38 PM, Sven Neumann <s.neumann@raumfeld.com> wrote:
> The function wiphy_update_regulatory() uses the static variable
> last_request and thus needs to be called with reg_mutex held.
> This is the case for all users in reg.c, but the function was
> exported for use by wiphy_register(), from where it is called
> without the lock being held.
>
> Fix this by making wiphy_update_regulatory() private and introducing
> regulatory_update() as a wrapper that acquires and holds the lock.
>
> Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
> Cc: Daniel Mack <daniel@zonque.org>
> Cc: linux-wireless@vger.kernel.org

Acked-by:  Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

  Luis
