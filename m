Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:54855 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbXCGPJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 10:09:18 -0500
Message-ID: <45EED59B.10306@warmcat.com>
Date: Wed, 07 Mar 2007 15:09:15 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Packetspammer and iwlwifi fragility
References: <45EEB892.6040201@warmcat.com> <200703070910.20242.flamingice@sourmilk.net>
In-Reply-To: <200703070910.20242.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:

> On Wednesday 07 March 2007 08:05, Andy Green wrote:
>> Also notice that packets cannot be sent by packetspammer until the
>> interface is brought up, which I guess is reasonable enough, but also I
>> found not until the interface was associated with a WPA network, which
>> is a problem if the plan is to use the injection action to do the work
>> of association in userspace.
>>
> There is a hostap/prism2 sub-ioctl to enable userspace mlme mode, which should 
> fix that issue. Look around in ieee80211_ioctl.c for 
> PRISM2_IOCTL_PRISM2_PARAM, ieee80211_ioctl_prism2_param, and 
> PRISM2_PARAM_USER_SPACE_MLME for hints. These sub-ioctls are, of course, 
> quite evil and need to be replaced, but it's a little better than hacking 
> mac80211 to start with user_space_mlme enabled by default.

Thanks for that tip Michael, I found it needed only 
PRISM2_PARAM_ALLOW_BROADCAST_ALWAYS to work without association.  So you 
  only need to

  - bring the interface up, and

  - set the channel

before running it now.  The updated version can be had here:

http://warmcat.com/packetspammer-0.2.tar.gz

-Andy
