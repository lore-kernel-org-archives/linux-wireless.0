Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2DRPFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 11:05:48 -0400
Message-ID: <4F8ED849.4020002@sipsolutions.net> (sfid-20120418_170551_304603_36D559C2)
Date: Wed, 18 Apr 2012 08:05:45 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Javier Cardona <javier@cozybit.com>
CC: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, henry@logout.com,
	"greenmesh@lists.osll.spb.ru" <greenmesh@lists.osll.spb.ru>
Subject: Re: [Greenmesh] [ath9k] mesh powersave hardware sleep + wakeup
References: <4F630AEA.10703@etit.tu-chemnitz.de> <20120316204547.GG18861@tux> <4F63BA31.1080608@etit.tu-chemnitz.de> <4F856449.3000804@etit.tu-chemnitz.de> <1334203508.3788.12.camel@jlt3.sipsolutions.net> <4F868732.1030401@etit.tu-chemnitz.de> <1334714536.3725.33.camel@jlt3.sipsolutions.net> <CAPjQAd99vzQDO0PzC-0jq1j8h4ekQAP_dRE=g5f=w=6EwcXrDw@mail.gmail.com> (sfid-20120418_165725_974666_D9DBAE5F)
In-Reply-To: <CAPjQAd99vzQDO0PzC-0jq1j8h4ekQAP_dRE=g5f=w=6EwcXrDw@mail.gmail.com> (sfid-20120418_165725_974666_D9DBAE5F)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/2012 7:56 AM, Javier Cardona wrote:
> On Tue, Apr 17, 2012 at 7:02 PM, Johannes Berg
> <johannes@sipsolutions.net>  wrote:
>> (...)
>> Keep in mind that TSF == start of TSF field, while rx_status->timestamp
>> == start of first symbol, which I didn't even remember when you guys did
>> all the Toffset things, I'm guessing they're all wrong :-)
>
> I think you guessed wrong :)

Nice! FWIW, our hardware (not that the driver supports mesh now) will 
give the timestamp at the first symbol of the MPDU, so some more offset 
calculations are needed and we don't give valid timestamps today. I 
started working on this but haven't figured out HT preamble duration yet.

johannes

