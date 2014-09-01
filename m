Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:55272 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaIAIgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 04:36:14 -0400
Message-ID: <54042FFB.2020908@broadcom.com> (sfid-20140901_103617_473484_A5B7BAFB)
Date: Mon, 1 Sep 2014 10:36:11 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Matteo Croce <matteo@openwrt.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Format connected time
References: <CAFnufp1YWig-j_5bK=Vkp+w2F6vDy=HH5U=OVVYo2bzQ4aXrBg@mail.gmail.com>
In-Reply-To: <CAFnufp1YWig-j_5bK=Vkp+w2F6vDy=HH5U=OVVYo2bzQ4aXrBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/14 10:25, Matteo Croce wrote:
> Format connected_time in the form hh:mm:ss

Hi Matteo,

This is not a proper patch submission. Please read the file 
Documentation/SubmittingPatches. Especially, sections 11) and 12). Also 
would be good to have 'mac80211:' prefix in the subject line and it is 
recommended to submit changes to the maintainer and cc the mailing list.

Hope this helps. No guarantees this change will be applied though.

Regards,
Arend

> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -130,7 +130,7 @@ static ssize_t sta_connected_time_read(struct file
> *file, char __user *userbuf,
>    result.tm_year -= 70;
>    result.tm_mday -= 1;
>    res = scnprintf(buf, sizeof(buf),
> - "years  - %ld\nmonths - %d\ndays   - %d\nclock  - %d:%d:%d\n\n",
> + "years  - %ld\nmonths - %d\ndays   - %d\nclock  - %02d:%02d:%02d\n\n",
>    result.tm_year, result.tm_mon, result.tm_mday,
>    result.tm_hour, result.tm_min, result.tm_sec);
>    return simple_read_from_buffer(userbuf, count, ppos, buf, res);
>

