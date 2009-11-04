Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54571 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343AbZKDRAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 12:00:16 -0500
Date: Wed, 4 Nov 2009 11:54:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>, sidhayn@gmail.com,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when
	LEDS enabled (Bugzilla #14539)
Message-ID: <20091104165453.GH12965@tuxdriver.com>
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <20091104151132.GD12965@tuxdriver.com> <4AF1A3BD.1020009@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4AF1A3BD.1020009@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2009 at 09:54:37AM -0600, Larry Finger wrote:

> I will try once more to get netconsole working to capture the backtrace.

No need, I think I understand it now.  The new order still sorta
looks/feels "wrong", but it seems fine.  Maybe an alternative would
be to make the brightness_set routine aware of the shutdown and not
queue the work?  Maybe even ieee80211_queue_delayed_work could be
made a bit smarter here?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
