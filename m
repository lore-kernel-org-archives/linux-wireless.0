Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60401 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1HOXNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 19:13:52 -0400
Received: by qwk3 with SMTP id 3so2700423qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 16:13:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+7oygcN-RykWDg8=h9uKDgnKPFgmaY-cxt3QRZD4ZuVnMRmgw@mail.gmail.com>
References: <CA+7oygcN-RykWDg8=h9uKDgnKPFgmaY-cxt3QRZD4ZuVnMRmgw@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 16 Aug 2011 01:13:32 +0200
Message-ID: <CA+XFjir3+8DQSZDXO74dbULnDuTyiHqVmYxd2-PDJcZy585i2A@mail.gmail.com> (sfid-20110816_011356_026898_E9EBEACF)
Subject: Re: any way to activate a scan in Atheros' monitor mode?
To: George Nychis <gnychis@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Why would you want to do a conventional AP scan in monitor mode? If
you just want to channel hop, you can directly call nl80211 to change
the channel repeatedly. (Calling iwconfig is the worst idea, as
iwconfig uses the old wext interface, which is then basically
translated to nl80211 commands in the kernel, before being sent to the
device/driver.)

Also, you can always have a managed interface open in the background,
and do scanning on that.

On Mon, Aug 15, 2011 at 11:03 PM, George Nychis <gnychis@gmail.com> wrote:
> Is there anything out of the box, before I go hacking, that supports
> initiating a channel scan for an ath9k card when in monitoring mode?
> Right now, I am implementing a wrapper around iwconfig to increment
> the channel, but its a little fuzzy when it's implemented at a higher
> layer with delays to change the channel that I can't account for.
>
> - George
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
