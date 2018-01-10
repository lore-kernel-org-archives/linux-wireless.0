Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:47093 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752096AbeAJVjX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 16:39:23 -0500
Received: by mail-qk0-f182.google.com with SMTP id l64so1136784qke.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jan 2018 13:39:22 -0800 (PST)
Subject: Re: ath9k dropping connections
To: alexander@wetzel-home.de, linux-wireless@vger.kernel.org
References: <f5b539a5-5365-7a1d-101d-591b5face78a@gmail.com>
 <e04a6de7-4582-d0be-75d7-ce27eb621a1f@wetzel-home.de>
From: =?UTF-8?Q?Fl=c3=a1vio_Silveira?= <flavioguiraldo@gmail.com>
Message-ID: <8d9adcc4-8c4f-9d00-944d-174f4fe517ab@gmail.com> (sfid-20180110_223927_190750_A0033117)
Date: Wed, 10 Jan 2018 19:39:04 -0200
MIME-Version: 1.0
In-Reply-To: <e04a6de7-4582-d0be-75d7-ce27eb621a1f@wetzel-home.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 29/12/2017 15:59, Alexander Wetzel wrote:
> Hello,
>
> I guess there are quite some potential issues which could cause that.
> Since you do not see any error logs one of them could be the WPA rekey IV poisoning one I encountered in the past.
>
> Do you have wpa rekey enabled? If so please check if disabling it fixes the issue for you.
> Assuming you are only using a WPA passoword and not EAP you can check if you have rekey enabled from a CLI on the router with the folowing command:
> "uci show wireless | grep wpa_pair_rekey"
>
> You have to delete any config statements found by the command and restart the router (or wifi) to apply the changes.
>
> If that helps, at least one STA is sending frames using wrong IV's and tricks the other end into dropping valid frames.
> In that case I can offer some options how to work around that, but I'm not aware of a real fix and disabling rekey is still probably the best...
>
> Regards,
>
> Alexander

Hello Alexander, thanks for your reply!

   Unfortunately "uci show wireless | grep wpa_pair_rekey" returns 
nothing, so I guess this is not the issue.

   I didn't know I was running LEDE snapshot with kernel 4.9.65, since 
then I built a LEDE 17.01.4 which has kernel 4.4.92 with ATH Debug 
enabled. What I can see is "pending" increases for queue BE (best 
effort) when the issue occurs, any other thing I could do to help 
understand why this is happening?

   I think I didn't mention in first post that I am using virtual 
interfaces, I don't know if it matters.

Regards,
   Flavio Silveira
