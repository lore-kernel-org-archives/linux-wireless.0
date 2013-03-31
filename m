Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54501 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab3CaWnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Mar 2013 18:43:06 -0400
Message-ID: <1364767324.8598.0.camel@jlt4.sipsolutions.net> (sfid-20130401_004310_931353_66D92C6C)
Subject: Re: Mysterious (?) VHT/HT warning on 3.8.2
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 01 Apr 2013 00:02:04 +0200
In-Reply-To: <CAObL_7G8i9fuvoVMu2D1P7vk9DE_=EwJcp3uDPiLPC7YfuHROg@mail.gmail.com> (sfid-20130331_034950_361359_E9636B0A)
References: <CAObL_7G8i9fuvoVMu2D1P7vk9DE_=EwJcp3uDPiLPC7YfuHROg@mail.gmail.com>
	 (sfid-20130331_034950_361359_E9636B0A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-03-30 at 18:49 -0700, Andrew Lutomirski wrote:

> wlan0: capabilities/regulatory prevented using AP HT/VHT
> configuration, downgraded
> 
> Despite this warning, HT seems to work.  I'm getting >7 MB/s over ssh,
> which isn't terrible.

Yeah, the warning is spurious, it's disabling VHT because neither you
nor the AP have it ;-)

I fixed it in

commit 586e01ededf9b713a1512dd658806791a7ca1a50
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Feb 14 12:13:53 2013 +0100

    mac80211: prevent spurious HT/VHT downgrade message

but I guess that didn't make it to 3.8, maybe it should be applied to
stable.

johannes

