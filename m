Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out07.sjc.mx.trendmicro.com ([216.99.131.23]:64563 "EHLO
	out07.sjc.mx.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756487Ab3ETXkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 May 2013 19:40:11 -0400
Received: from relay04.sjc.mx.trendmicro.com (unknown [10.30.239.129])
	by out07.sjc.mx.trendmicro.com (Postfix) with ESMTP id 41897952474
	for <linux-wireless@vger.kernel.org>; Mon, 20 May 2013 23:40:10 +0000 (UTC)
Received: from thinktube.com (unknown [111.68.225.247])
	by relay04.sjc.mx.trendmicro.com (Postfix) with ESMTP id C7A0C980441
	for <linux-wireless@vger.kernel.org>; Mon, 20 May 2013 23:40:09 +0000 (UTC)
Message-ID: <519AB452.2010903@thinktube.com> (sfid-20130521_014015_073056_71681EFB)
Date: Tue, 21 May 2013 00:40:02 +0100
From: Bruno Randolf <br1@thinktube.com>
MIME-Version: 1.0
To: Alessandro Lannocca <alessandro.lannocca@gmail.com>
CC: linux-wireless@vger.kernel.org, helmut.schaa@googlemail.com,
	IvDoorn@gmail.com, gwingerde@gmail.com
Subject: Re: rt3070-based usb device won't accept mac address changes
References: <CAMfPB_xTUy72YokSoYJezOX_gb54CJEd7V6+4pAfOHnAzUMJcQ@mail.gmail.com> <5197AF6B.5040800@thinktube.com> <CAMfPB_yVuSD765CAycUtdWBTvEEam=MpdCGKpWDJAvFiEjvLrw@mail.gmail.com>
In-Reply-To: <CAMfPB_yVuSD765CAycUtdWBTvEEam=MpdCGKpWDJAvFiEjvLrw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/2013 10:07 PM, Alessandro Lannocca wrote:
> After digging a bit into linux-stable.git I found the culprit: this
> regression comes from commit #
> 6c50f9459e62eb133563fd23606f68bfc9d120e8 (rt2x00: Use addr_mask to
> disallow invalid MAC addresses in mutli-bssid mode) ; reverting it
> fixes the problem, tested by me in compat-drivers-2013-03-28-5-u .
>
>
> I can't tell if reverting that commit adds any trouble as I'm not a
> developer; however I'm sure you guys will know how to handle the
> situation.

Basically the driver got more picky and only allows the last 3 bit of 
the MAC address changed. I just found out that if you generate your new 
MAC accordingly it works!

I wonder wether this is addr_mask is necessary for all RT chipsets, 
since mine (RT5372) happily accepted different MAC addresses before, 
also in multi-AP configurations...

bruno
