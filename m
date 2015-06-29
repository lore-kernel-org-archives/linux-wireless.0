Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f41.google.com ([209.85.216.41]:36320 "EHLO
	mail-vn0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbbF2Q7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 12:59:01 -0400
Received: by vnbg129 with SMTP id g129so1944830vnb.3
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2015 09:59:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1435566216.2156.11.camel@sipsolutions.net>
References: <1435308646.2106.4.camel@sipsolutions.net>
	<298558322.1785659.1435565847951.JavaMail.yahoo@mail.yahoo.com>
	<1435566216.2156.11.camel@sipsolutions.net>
Date: Mon, 29 Jun 2015 09:58:59 -0700
Message-ID: <CAMcMvsgpd_OumnN5P0LFin1iZmUZLLPfouxb3k5neF+mfZgKug@mail.gmail.com> (sfid-20150629_185907_272587_091B12C3)
Subject: Re: iw and non-ASCII SSIDs
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Joerg Pommnitz <pommnitz@yahoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 29, 2015 at 1:23 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> [please don't use HTML]
>
> On Mon, 2015-06-29 at 08:17 +0000, Joerg Pommnitz wrote:
> > We don't have to break compatibility. The commandline syntax of iw is
> > iw [options] command
> > My suggestion would be a new option "--binary-ssid" that sets a flag
> > and causes all SSID to be treated as a hex encoded binary blob:
> > iw --binary-ssid dev wlan0 ibss join 0034AA 2412


Technically, I'd call this "--hex-ssid" considering the actual encoding
shown.

>
> > and for consistency
> > iw --binary-ssid dev wlan0 connect 0034AA
> >
> > Alternatively the option could be "--escaped-ssid" that would
> > activate an escape processing for the SSID as you suggested. My
> > preference is "--binary-ssid", because I'm always a little bit unsure
> > what actually arrives in the program after the shell has done its own
> > escape processing.
> >
>
>
> Yeah, that seems reasonable, though perhaps easier to do as
>
>   iw dev wlan0 ibss join --binary-ssid 0034AA 2412
>
> since options before the command are treated as generic iw options.
>
> Then again, if all places that use an SSID were to use a
> "parse_ssid(argv[7])" function then the former could also be
> implemented.
>
> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
