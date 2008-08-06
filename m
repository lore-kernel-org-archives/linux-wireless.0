Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:45838 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762957AbYHFVTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 17:19:07 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix potential concurrent access to private data
Date: Wed, 6 Aug 2008 23:21:52 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <4896381c.abQmtcnBFB3TpLyf%Larry.Finger@lwfinger.net>
In-Reply-To: <4896381c.abQmtcnBFB3TpLyf%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808062321.53120.chunkeey@web.de> (sfid-20080806_231922_517911_85E79931)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 August 2008 00:58:36 Larry Finger wrote:
> Experience with the rtl8187 driver has shown that mac80211 can make
> calls to the config callback routine in rapid succession. This patch
> creates a mutex that protects the private data in several of the routines
> called by mac80211.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> John,
>
> I think this is 2.6.27 material. It is a definite bug, but I cannot point
> to a single bug report implicating this lack of protection as the cause.
> Your call.
>
> Larry

Well the reason why there isn't any bug report about it is maybe
because unlike most other devices we don't program one single
setting per time, but always a "group of similar ones" at once so
the device should always be in a sane state in theory.

So as long as mac80211 provides at least some kind of protection
against it's own concurrency, we are in save waters even without
any fancy kind of locking.

Regards,
	Chr
