Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57312 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbbF2IXi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 04:23:38 -0400
Message-ID: <1435566216.2156.11.camel@sipsolutions.net> (sfid-20150629_102349_227044_4D209A16)
Subject: Re: iw and non-ASCII SSIDs
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 29 Jun 2015 10:23:36 +0200
In-Reply-To: <298558322.1785659.1435565847951.JavaMail.yahoo@mail.yahoo.com>
References: <1435308646.2106.4.camel@sipsolutions.net>
	 <298558322.1785659.1435565847951.JavaMail.yahoo@mail.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[please don't use HTML]

On Mon, 2015-06-29 at 08:17 +0000, Joerg Pommnitz wrote:
> We don't have to break compatibility. The commandline syntax of iw is
> iw [options] command
> My suggestion would be a new option "--binary-ssid" that sets a flag 
> and causes all SSID to be treated as a hex encoded binary blob:
> iw --binary-ssid dev wlan0 ibss join 0034AA 2412
> and for consistency
> iw --binary-ssid dev wlan0 connect 0034AA
> 
> Alternatively the option could be "--escaped-ssid" that would 
> activate an escape processing for the SSID as you suggested. My 
> preference is "--binary-ssid", because I'm always a little bit unsure 
> what actually arrives in the program after the shell has done its own 
> escape processing.
> 


Yeah, that seems reasonable, though perhaps easier to do as

  iw dev wlan0 ibss join --binary-ssid 0034AA 2412

since options before the command are treated as generic iw options.

Then again, if all places that use an SSID were to use a
"parse_ssid(argv[7])" function then the former could also be
implemented.

johannes
