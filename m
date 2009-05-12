Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:24134 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbZELGz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 02:55:58 -0400
Received: by wf-out-1314.google.com with SMTP id 26so2740713wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 23:55:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <OF24E7AF48.E39EC671-ONC12575B4.00236C72-C12575B4.0024C49C@drz-wien.at>
References: <43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
	<OF24E7AF48.E39EC671-ONC12575B4.00236C72-C12575B4.0024C49C@drz-wien.at>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 May 2009 23:55:39 -0700
Message-ID: <43e72e890905112355t53537ca9w2797cfc8694302@mail.gmail.com>
Subject: Re: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath
	comes
To: alexander.bartha@drz-wien.at
Cc: Alexander Bartha <alex.xy.privat@gmx.at>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 11:38 PM,  <alexander.bartha@drz-wien.at> wrote:
>
> Hello to linuxwireless
>
> thanks for response. The stabel compat-wireless-2.6.30-rc4.tar.bz2 release
> works well. The bleeding edge compat-wireless works to but only till the new
> submodule ath comes in live (compat-wireless-2009-04-12.tar.bz2 is the last
> version which i have tasted and which works well).

I've tested this and its not the "ath" module which introduces an
issue its a patch which enables PS by default. You can disable that by
recompiling with:

CONFIG_MAC80211_DEFAULT_PS_VALUE=0

If using compat-wireless just stuff it into config.mk.

  Luis
