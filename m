Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37587 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab2CHTvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 14:51:24 -0500
Received: by iagz16 with SMTP id z16so1121888iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 11:51:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B96CD77D9161244899852B5F20DB5B70125BC94@nasanexd02d.na.qualcomm.com>
References: <20120307194001.GA2506@ubuntu-macmini> <20120308174101.GB28133@ubuntu-macmini>
 <CAB=NE6VapPfLjAh5Y+sCA4qA82s9HrQk_Mxr8FpKoCfjudMDig@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BB72@nasanexd02d.na.qualcomm.com>
 <CAB=NE6U04a0XNrvt6HLCwqbHMtGL8CWh8No_=Bx0mwQZYEgGxQ@mail.gmail.com> <4B96CD77D9161244899852B5F20DB5B70125BC94@nasanexd02d.na.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 8 Mar 2012 11:51:03 -0800
Message-ID: <CAB=NE6X9c1m63xayNsEf9XZ3AgPZDV2SiRivg3SV2Day83fPQA@mail.gmail.com> (sfid-20120308_205128_191502_8BA26166)
Subject: Re: Problems with regulatory domain support and BCM43224
To: "Quan, David" <dquan@qca.qualcomm.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	"Green, Michael" <green@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 8, 2012 at 11:45 AM, Quan, David <dquan@qca.qualcomm.com> wrote:
> I think there is to it more than SW.
> Where ever you get this card, is the card tested and regulatory approved for those countries, DFS or not?

Seth, what driver are you using? I know you are using a BCM43224 card.

> It is possible that this card is only regulatory tested for non DFS channels, but now you enable them for passive.

That's a good point.

> This means that yes, you are save and not violate DFS rules because you are in passive mode. However, you are in complete violation if the STA finds an AP on that DFS channel and then connects and transmits as this STA is not allow to transmit on that channel since it is not approved.

If the driver being used is a supported vendor driver then I'll punt
this to the vendor (Broadcom). If this is the reversed engineered
driver (b43) that Broadcom to this day seems to blindly ignore even
for regulatory, then I'm happy to recommend based on your input to
leave the regulatory domain as-is given that we cannot guarantee what
the vendor meant as they have not done any work on releasing either
documentation or code to help with their regulatory situation.

  Luis
