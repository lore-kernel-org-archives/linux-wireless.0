Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:55965 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZG1UnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 16:43:20 -0400
Received: by ewy26 with SMTP id 26so347971ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 13:43:19 -0700 (PDT)
Message-ID: <4A6F62B6.5060902@gmail.com>
Date: Tue, 28 Jul 2009 21:42:30 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	orinoco-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] orinoco: enable cfg80211 "set_channel" operation
References: <200907281634.26104.hs4233@mail.mn-solutions.de>	 <4A6F270A.7030002@gmail.com>  <1248798599.13742.2.camel@johannes.local> <1248798699.13742.3.camel@johannes.local>
In-Reply-To: <1248798699.13742.3.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2009-07-28 at 18:29 +0200, Johannes Berg wrote:
>> On Tue, 2009-07-28 at 17:27 +0100, Dave wrote:
>>
>>> Looks right for monitor mode (as you tested), but for ad-hoc the channel
>>> change would be delayed until the next SIOCSIWCOMMIT. Which for cfg80211
>>> is currently only on change_vif.
>> You won't be getting this call for ad-hoc mode, because then the channel
>> is contained in the ibss_join() parameters.
> 
> 
>>> You can also eliminate orinoco_ioctl_setfreq from wext.c with this
>>> change.
> 
> That also means you can't eliminate that, of course, since for connect()
> the channels is also contained in the parameters, and the set_freq isn't
> invoked.

Ah. Thanks for the corrections.


Dave.
