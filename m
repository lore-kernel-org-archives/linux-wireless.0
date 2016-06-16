Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34211 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbcFPKVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 06:21:48 -0400
Received: by mail-oi0-f49.google.com with SMTP id d132so61773135oig.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 03:21:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADpKk60njba2Y7NNCwVSSBS+eeFP3zt7zLqA3pnjKuo=n5ozqA@mail.gmail.com>
References: <CADpKk60njba2Y7NNCwVSSBS+eeFP3zt7zLqA3pnjKuo=n5ozqA@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 16 Jun 2016 12:21:46 +0200
Message-ID: <CACna6rya1HMEPBQYs_iJ51gAT+c2gO-jCMndhC2Wiwa9Jkv3Cg@mail.gmail.com> (sfid-20160616_122151_954982_D809DDA0)
Subject: Re: Getting signal strength of a received packets
To: Majid Ashoori <majid.it@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 June 2016 at 12:10, Majid Ashoori <majid.it@gmail.com> wrote:
> Hi everyone,
> I am using OCB mode based on ath9k driver for my wireless connections
> between different nodes. In this mode there is no BS or established
> connection to analyze the signal strength of BS. Thus, I need to know
> the signal strength of received packets in my user-space application
> to do some calculation based on that.
>
> So, here is the question: how can I get signal strength of a received
> packet in a user-space application? I reached to the point that it may
> be performed via cfg80211 or nl80211 and I check them but I am not
> sure how exactly I can get that.

Create monitor interface, read packets from it, parse radiotap header
manually or using this tiny parser:
http://git.sipsolutions.net/?p=radiotap.git

-- 
Rafał
