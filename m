Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37063 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1GaTNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2011 15:13:09 -0400
Received: by fxh19 with SMTP id 19so3874049fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jul 2011 12:13:07 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Harshal Chhaya <harshal@gmail.com>
Subject: Re: carl9170: How do I change value of retries for long packets?
Date: Sun, 31 Jul 2011 21:12:55 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAJ8GFOg4A4JwC8qdF6e7rRCRETnfrPm5Zv60_8Cm1xpbJJNQpg@mail.gmail.com>
In-Reply-To: <CAJ8GFOg4A4JwC8qdF6e7rRCRETnfrPm5Zv60_8Cm1xpbJJNQpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107312112.55357.chunkeey@googlemail.com> (sfid-20110731_211313_948279_6EF350FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, July 31, 2011 06:48:46 PM Harshal Chhaya wrote:
> I am still figuring out how to use 64 clients with h/w
> encryption on the AR9170 - enabling debug/tracing in my build isn't as
> straightforward as suggested by the wiki.
Actually, to do this thing correctly, I recon you should ask your employer
to get you the AR9170 chip documents from atheros qualcomm [if you haven't
acquired them already.]
 
> However, I did find some very helpful information in the debug files
> in 'debugfs' including the number of retries.
> The current value is 4 for long packets and 7 for short packets.
I don't think that the term "short packets" is what you think it is. :D
 
> I think the small # of retries for regular data packets may be one
> reason why I am seeing some throughput problems at longer ranges.
Actually, your problem could be related to this thread:
http://www.spinics.net/lists/linux-wireless/msg73850.html

Furthermore, what's "longer range"? Is it 10-20 meters or are
you talking about 200m+? [Note: mac80211 has a switch to select
different coverage classes. The AR9170 MAC has a register
AR9170_MAC_REG_ACK_EXTENSION to up the ACK timeout]

> How do I change the number of retries for long packets? Is this a
> build-time configuration or can I change it at run-time?
Actually, the number of retries is controlled by the selected
mac80211's rate control algorithm. However, you first take a
look at debug/ieee80211/phy0/statistics/failed_count and see
if it really is the lack of additional "retries" which causes
data loss. 

Regards,
	Chr
