Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38419 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab0I2UFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 16:05:44 -0400
Subject: Re: [PATCH v2] mac80211:  Don't go off-channel in work_work unless
 needed.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285787159-9207-1-git-send-email-greearb@candelatech.com>
References: <1285787159-9207-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 22:05:29 +0200
Message-ID: <1285790729.3756.37.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 12:05 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> If the work to be done is on the current active channel, then
> do not call the offchannel and return-to-channel logic.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> v1 -> v2:  Remove went_off_channel logic, and don't set
>    tmp_channel if we're not going offchannel.

I briefly grepped through the source and am pretty sure this'll break a
few things in mlme.c and even the work-on-same-channel logic in
work.c...

johannes

