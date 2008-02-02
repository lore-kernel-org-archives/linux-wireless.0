Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:9758 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762603AbYBBW2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 17:28:45 -0500
Received: by py-out-1112.google.com with SMTP id u52so2390531pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 14:28:45 -0800 (PST)
Message-ID: <43e72e890802021428t205622d8l3a1aab8f2c6dea18@mail.gmail.com> (sfid-20080202_222850_469701_61E0E59F)
Date: Sat, 2 Feb 2008 17:28:43 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: Cleanup after API changes patch
Cc: bruno@thinktube.com, johannes@sipsolutions.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <47A4ECC5.6070503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <47A33ECA.5030005@gmail.com>
	 <43e72e890802021335g181e76e9gf95356ac729ad6d9@mail.gmail.com>
	 <43e72e890802021339x5b2a44eayad71e796ba48451b@mail.gmail.com>
	 <47A4ECC5.6070503@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 2, 2008 5:20 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 02/02/2008 10:39 PM, Luis R. Rodriguez wrote:
> > On Feb 2, 2008 4:35 PM, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu> wrote:
> >> On Feb 1, 2008 10:46 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >>> On 02/01/2008 02:25 AM, Luis R. Rodriguez wrote:
> >>>> @@ -889,13 +900,15 @@ ath5k_copy_channels(struct ath5k_hw *ah,
> >>>>               /* Write channel info and increment counter */
> >>>>               channels[count].center_freq = freq;
> >>>>
> >>>> -             if((mode == AR5K_MODE_11A) ||
> >>>> -             (mode == AR5K_MODE_11G)){
> >>>> -                     channels[count].hw_value = chfreq|CHANNEL_OFDM;
> >>>> -             } else if((mode == AR5K_MODE_11A_TURBO) ||
> >>>> -             (mode == AR5K_MODE_11G_TURBO)){
> >>>> -                     channels[count].hw_value = chfreq|CHANNEL_OFDM|CHANNEL_TURBO;
> >>>> -             }if(mode == AR5K_MODE_11B) {
> >>>> +             if ((mode == AR5K_MODE_11A) ||
> >>>> +                     (mode == AR5K_MODE_11G)) {
> >>>> +                     channels[count].hw_value =
> >>>> +                             chfreq | CHANNEL_OFDM;
> >>>> +             } else if ((mode == AR5K_MODE_11A_TURBO) ||
> >>>> +                     (mode == AR5K_MODE_11G_TURBO)) {
> >>>> +                     channels[count].hw_value =
> >>>> +                             chfreq | CHANNEL_OFDM|CHANNEL_TURBO;
> >>>> +             } if (mode == AR5K_MODE_11B) {
> >>> 'else' or '\n' before the if, please
> >> Good catch, that should have been an "else if" there. Will repost all
> >> pending patches in a series addressing all posted comments.
> >
> > Going to move this to a switch, its much more legible.
>
> There was switch IIRC, I think either sparse or -W don't like it too much (enum
> <-> int)? Please could you check? (-W doesn't bother us.)

Thanks for the heads up, will do.

  Luis
