Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36203 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2HWQbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 12:31:08 -0400
Received: by ialo24 with SMTP id o24so1589778ial.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2012 09:31:08 -0700 (PDT)
Message-ID: <50365AC8.7030503@lwfinger.net> (sfid-20120823_183113_339794_205C7750)
Date: Thu, 23 Aug 2012 11:31:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Patrick Connolly <pjc999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about ath9k/mac80211 Driver
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com>
In-Reply-To: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2012 11:19 AM, Patrick Connolly wrote:
> Mohammed,
>       Thanks very much for the response.
>
>     Yes I get "Operation not supported":
>
> # iwconfig wlan0 modu 11b
> Error for wireless request "Set Modulation" (8B2F) :
>      SET failed on device wlan0 ; Operation not supported.
>
>     ...so what does this mean; what are my options here?  In view of
> the fact that the capability of changing modes (from 'g' to 'b'
> ...etc.) is an essential requirement, am I using the wrong driver
> ...is there a different driver that supports this chip?  Or is it that
> there's no driver that supports this chip so that I would have to put
> this functionality into ath9k myself if I want it?

Adding that functionality should not be necessary. The simple command

iw dev $WIFIDEV set bitrates legacy-2.4 1 2 5.5 11

will restrict the device to 802.11b rates, which I think is what you want. This 
command does not involve the device driver, but sets the appropriate parameters 
in mac80211.

Larry


