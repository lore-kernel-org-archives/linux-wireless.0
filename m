Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60813 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2EXFcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 01:32:31 -0400
Received: by bkcji2 with SMTP id ji2so6590440bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 22:32:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ehqa6u2d.fsf@purkki.adurom.net>
References: <1337760813-27055-1-git-send-email-arik@wizery.com>
 <87wr436utp.fsf@purkki.adurom.net> <CA+XVXfeju02Ou=jZ=eyq+0e4Rm1-5=b6-m8bMyZ8kAWO6F-sXQ@mail.gmail.com>
 <87mx4z6u4n.fsf@purkki.adurom.net> <CA+XVXfc3R8CrMfercPpRfYGjvKDdDkwJax+oLiaMrQQPwLCc0Q@mail.gmail.com>
 <87ipfn6koz.fsf@purkki.adurom.net> <CA+XVXfcZAE0Drbn_JTBt1p0GAaFrsxZfHNE1Syp=1G=PNsvkbQ@mail.gmail.com>
 <87ehqa6u2d.fsf@purkki.adurom.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 24 May 2012 08:32:14 +0300
Message-ID: <CA+XVXffb3tZ2_kWwx0wBWUac-y0BPTT_KBJ5yhxNjPVp4U7HGw@mail.gmail.com> (sfid-20120524_073235_192890_71AF6709)
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len
 for STA
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 24, 2012 at 8:12 AM, Kalle Valo <kvalo@adurom.com> wrote:
> But this was a workaround for an IOP problem with certain APs, right?
> How is firmware going to be smart in that case?
>
> It would help to see what you are exactly planning to do on wl12xx with
> this interface. Currently I'm just guessing what your plans really are.

The plan is to enable only VO as U-APSD (as I wrote in a previous
email). We've had problems with some APs (can't remember the models)
that assume non-VO ACs always use legacy PS. This would lead to
problems - our driver would never wake up. In that sense the problem
is general.

But in wl12xx the FW handles network PS on its own (PS-poll etc.), so
it may just be a bug with our FW. So hard-coding this into mac80211
seems a bit of an overkill.

Maybe you can offer a better solution?

Arik
