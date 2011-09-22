Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:38182 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab1IVHNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:13:07 -0400
Received: by gyd8 with SMTP id 8so2643314gyd.11
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 00:13:05 -0700 (PDT)
Message-ID: <4E7ADFFC.8080903@ti.com> (sfid-20110922_091311_693594_7407726C)
Date: Thu, 22 Sep 2011 10:13:00 +0300
From: Victor Goldenshtein <victorg@ti.com>
Reply-To: victorg@ti.com
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result event.
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>  <1315224151-16552-4-git-send-email-VictorG@ti.com>  <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>  <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com>  <20110921153102.GA32374@jm.kir.nu> <1316619903.2157.546.camel@cumari>  <4E7A109C.2010701@ti.com> <1316623133.3940.55.camel@jlt3.sipsolutions.net>  <4E7AD88C.4020806@ti.com> <1316674177.2157.563.camel@cumari>
In-Reply-To: <1316674177.2157.563.camel@cumari>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/09/2011 09:49, Luciano Coelho wrote:

> I guess what Johannes meant is that you can send the genl message in
> atomic context, so you don't need to save stuff and use the event work.
> You can just send it immediately when cfg80211_inform_bss() and
> cfg80211_inform_bss_frame() are called.
>
> I'm not really sure you can send genl messages while atomic, I think I
> had problems with that earlier, but you can try. ;)
>

;)

Well I already did, and it's not working, when you"ll try to send genl 
messages while atomic, you will get kernel warning regarding "sleeping 
function called from invalid context".


Thanks,
Victor.
