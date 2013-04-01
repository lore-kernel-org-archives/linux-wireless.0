Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39361 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758Ab3DAVrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 17:47:16 -0400
Received: by mail-pd0-f176.google.com with SMTP id r11so1409904pdi.35
        for <linux-wireless@vger.kernel.org>; Mon, 01 Apr 2013 14:47:16 -0700 (PDT)
Date: Mon, 1 Apr 2013 14:47:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Lutomirski <luto@mit.edu>, linux-wireless@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: Mysterious (?) VHT/HT warning on 3.8.2
Message-ID: <20130401214714.GA5976@kroah.com> (sfid-20130401_234723_278821_12E16851)
References: <CAObL_7G8i9fuvoVMu2D1P7vk9DE_=EwJcp3uDPiLPC7YfuHROg@mail.gmail.com>
 <1364767324.8598.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364767324.8598.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 01, 2013 at 12:02:04AM +0200, Johannes Berg wrote:
> On Sat, 2013-03-30 at 18:49 -0700, Andrew Lutomirski wrote:
> 
> > wlan0: capabilities/regulatory prevented using AP HT/VHT
> > configuration, downgraded
> > 
> > Despite this warning, HT seems to work.  I'm getting >7 MB/s over ssh,
> > which isn't terrible.
> 
> Yeah, the warning is spurious, it's disabling VHT because neither you
> nor the AP have it ;-)
> 
> I fixed it in
> 
> commit 586e01ededf9b713a1512dd658806791a7ca1a50
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Feb 14 12:13:53 2013 +0100
> 
>     mac80211: prevent spurious HT/VHT downgrade message
> 
> but I guess that didn't make it to 3.8, maybe it should be applied to
> stable.

Now applied, thanks.

greg k-h
