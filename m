Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37617 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab2CVTNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 15:13:50 -0400
Received: by vcqp1 with SMTP id p1so2292861vcq.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2012 12:13:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201203221958.10427.lindner_marek@yahoo.de>
References: <1332420968-16300-1-git-send-email-yeohchunyeow@gmail.com>
 <201203221133.51928.lindner_marek@yahoo.de> <CAPjQAd8BAjNFjmpjwrdNMpPNphqTBihitEPEPSiVqzS4KsPEAg@mail.gmail.com>
 <201203221958.10427.lindner_marek@yahoo.de>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 22 Mar 2012 12:13:28 -0700
Message-ID: <CAPjQAd-j0mP9faqSkwuDWErX1v+dbzYqO+rL6sKN-2ZMYr_FGA@mail.gmail.com> (sfid-20120322_201353_325741_E578DE40)
Subject: Re: [PATCH v2] mac80211: fix the RANN propagation issues
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	thomas@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 22, 2012 at 11:58 AM, Marek Lindner <lindner_marek@yahoo.de> wrote:
> On Thursday, March 22, 2012 17:31:33 Javier Cardona wrote:
>> >>  #define SN_GT(x, y) ((long) (y) - (long) (x) < 0)
>> >>  #define SN_LT(x, y) ((long) (x) - (long) (y) < 0)
>> >
>> > Your macros tried to address the problem but casting your sequence number
>> > to long also breaks the wrap around.
>>
>> Ah, thanks for your help.  I guess we do need those macros after all
>> but they'd have to be re-written as
>>
>> #define SN_LT(x, y) ((s32)(x - y) < 0)
>> #define SN_GT(x, y) ((s32)(x - y) > 0)
>
> No, you need unsigned values for this arithmetic to work (which is why long
> also fails).

The macro is always used on u32 values, so the arithmetic would be
unsigned in this case.

Cheers,

Javier
