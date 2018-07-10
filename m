Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:35133 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732205AbeGJT4S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 15:56:18 -0400
Received: by mail-wr1-f48.google.com with SMTP id a3-v6so6604345wrt.2
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2018 12:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <dbca726e-44c8-9a2f-2bb5-8a83c31f98e3@gmail.com>
 <1530266512.3481.68.camel@sipsolutions.net> <0ce17959-d930-a563-242c-da24145e39f0@gmail.com>
 <1530879434.3197.32.camel@sipsolutions.net> <2195bc60-8e33-b74a-fa27-ffda653ee814@gmail.com>
In-Reply-To: <2195bc60-8e33-b74a-fa27-ffda653ee814@gmail.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Tue, 10 Jul 2018 12:55:34 -0700
Message-ID: <CAJ-Vmo=LtfjPNxsLLNDQbe3MAF+x+BONsd5pSV50tYt+x_oPZA@mail.gmail.com> (sfid-20180710_215551_918063_9B08DF81)
Subject: Re: Proper SET_KEY usage?
To: denkenz@gmail.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 10 Jul 2018 at 12:16, Denis Kenzior <denkenz@gmail.com> wrote:

> I think we had this conversation before.  Up to 802.11-2012, PTK Rekey
> was not really explicitly mentioned as possible.  There were hints and
> stuff, but no explicit language.
>
> I think in 802.11-2016 they finally explicitly say that this is possible.
>
> However, we seem to have networks that perform PTK Rekey and even full
> 802.1X re-auth every hour (eduroam for example).  How is this working?
> Or is it a case of it not always working?

It's ... buggy. Right now I'm hitting race conditions (which someone
is actively working on now, yay!) where frames are going out in a
narrow window between the hardware key being rekeyed (and the RX PN
being set to 0) and an older frame going out with a larger PN with the
new key. The receiver sees the frame with the old, large PN but the
new key and .. well, subsequent traffic hangs. I know it's buggy on
ath9k (what we're using at work.) ath10k seems to fare better - it at
least is doing key programming and PN assignment in firmware, so it
has a chance to keep it in sync.



-adrian
