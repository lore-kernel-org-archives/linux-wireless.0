Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:35328 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751543Ab0KRGg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 01:36:27 -0500
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0109232185
	for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 15:36:26 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 0/4] cfg80211: fix bug with multiple cards and a CRDA delay
Date: Thu, 18 Nov 2010 15:36:45 +0900
Cc: linville@tuxdriver.com, mark@moxienet.com,
	linux-wireless@vger.kernel.org
References: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201011181536.45076.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu November 18 2010 14:46:05 Luis R. Rodriguez wrote:
> This series addresses the bug pointed out by Mark Mentovai
> <mark@moxienet.com> when there is a delay on CRDA and you use multiple
> cards with the same regulatory domain. After some testing I realized this
> also introduced an issue when using multiple cards with different
> regulatory settings. The issue is present only when there is a delay in
> CRDA so technically this is not a regression so I am not marking these as
> stable fixes. It also does not seem to be a regulatory bug as when the
> issue is present you'd end up with an intersected regulatory domain (same
> alpha2s) or get the regulatory domain rejected for the second card if the
> alpha2 was different.
> 
> Thanks to Mark for his testing, good ideas on alternative ways to resolve
> this and thorough reports.
> 
> Luis R. Rodriguez (4):
>   cfg80211: put core regulatory request into queue
>   cfg80211: move reg_work and reg_todo above
>   cfg80211: move mutex locking to reg_process_pending_hints()
>   cfg80211: Fix regulatory bug with multiple cards and delays
> 
>  include/net/regulatory.h |    7 ++++
>  net/wireless/reg.c       |   80
> +++++++++++++++++++++++++++++++-------------- 2 files changed, 62
> insertions(+), 25 deletions(-)

Yep - this fixes also my case (slow board under load + two or more ath5k 
cards). Thanks, Luis!

bruno
