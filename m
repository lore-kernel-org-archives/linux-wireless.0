Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61059 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab2CCP20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 10:28:26 -0500
Received: by vcqp1 with SMTP id p1so2286399vcq.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Mar 2012 07:28:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F5230D8.8040104@openwrt.org>
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
	<1330784226-65563-2-git-send-email-nbd@openwrt.org>
	<1330784226-65563-3-git-send-email-nbd@openwrt.org>
	<CAD2nsn2N2Ei2GTHc-_8hQ1h-jOy7jo3FM-Cn7i2T5t-eviCMZA@mail.gmail.com>
	<4F5230D8.8040104@openwrt.org>
Date: Sat, 3 Mar 2012 20:58:25 +0530
Message-ID: <CAD2nsn318qTtqA+A6SW+GXBTiod031cxeCxOW7iUTPDVr0vTLg@mail.gmail.com> (sfid-20120303_162844_279961_A143F345)
Subject: Re: [PATCH 3/5] ath9k: remove rssi/antenna information from recv
 debug stats
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 3, 2012 at 8:25 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2012-03-03 3:46 PM, Mohammed Shafi wrote:
>> On Sat, Mar 3, 2012 at 7:47 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> The way this is implemented (simply storing the last value) is absolutely
>>> worthless for debugging anything, and the same information is also available
>>> through the MAC sample feature, so there's no point in keeping this around.
>>
>> :) :)  please keep this, we were debugging antenna diversity related
>> issues in AR9485 with this stats. the antenna switching never
>> happened, then with these stats we found that the rss1 seems to be
>> always negative, same result with the windows driver also, then later
>> found its a EEPROM related issue.
> You can already get the antenna from the radiotap information of a
> monitor mode interface, which I think is much more useful than this
> limited debugfs parameter. If you really need this in debugfs, it could
> also be added to the MAC sampling, though I think that one is rather
> limited as well.
>

ok thanks, yes we can look it in MAC sampling for rssi stuff

-- 
thanks,
shafi
