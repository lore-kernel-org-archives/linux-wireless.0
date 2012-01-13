Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39179 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2AMU44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 15:56:56 -0500
Received: by iabz25 with SMTP id z25so4846665iab.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2012 12:56:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201131621410.29680@axis700.grange>
References: <Pine.LNX.4.64.1201061256190.16279@axis700.grange>
 <CAGRGNgUj3EUPKc0SX+3yCbygdbhS7_CN4hgR7ZAzjXuULw9fLg@mail.gmail.com>
 <Pine.LNX.4.64.1201061653050.18586@axis700.grange> <Pine.LNX.4.64.1201130028340.1646@axis700.grange>
 <20120113150800.GB18899@tuxdriver.com> <Pine.LNX.4.64.1201131621410.29680@axis700.grange>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 14 Jan 2012 07:56:35 +1100
Message-ID: <CAGRGNgWwovHAiABNRXjrHxGRLJob2bL2StUMuAsGjm0hNQNqsA@mail.gmail.com> (sfid-20120113_215700_626797_F9440D33)
Subject: Re: [PATCH] wireless: b43: fix Oops on card eject during transfer
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 14, 2012 at 02:26, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi John
>
> On Fri, 13 Jan 2012, John W. Linville wrote:
>
>> Well, you weren't interested in making the minor change suggested
>> by Julian.  So I set it aside with the intent of making the change
>> myself, then neglected to follow through. :-(  I'll try to get to
>> that today.  Or, feel free to submit a new version yourself.
>
> I didn't neglect, I explained, why I considered his suggestion not
> necessarily an improvement. If there were several votes for that change,
> or if it were a maintainer, who requested the change - I would consider
> obeying, but this time it was just an opinion of one developer against
> that of another.

I was going to respond by explaining that taking a mutex is an
expensive operation, adding a label is cheap, both in terms of code
complexity and code run-time.

I personally see no change in code complexity by adding a label to
this function. What does concern me is when actions are performed that
perform work for no real benefit - IMHO this increases the code
complexity: when reading it, one will ask one's self "why?" and then
have to search for why someone has done something un-obvious like
this.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
